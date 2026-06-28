package com.drivingschool.service;

import com.drivingschool.model.LessonSlot;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LessonSlotService {

    private static final String JOIN_SQL =
            "SELECT s.*, " +
                    "       c.course_name, c.license_category, " +
                    "       u.full_name AS instructor_name, " +
                    "       CONCAT(v.registration_no, ' - ', v.make, ' ', v.model) AS vehicle_info " +
                    "FROM lesson_slots s " +
                    "JOIN courses     c ON s.course_id     = c.course_id " +
                    "JOIN instructors i ON s.instructor_id = i.instructor_id " +
                    "JOIN users       u ON i.user_id       = u.user_id " +
                    "JOIN vehicles    v ON s.vehicle_id    = v.vehicle_id ";

    public int create(LessonSlot slot) throws SQLException {
        String sql = "INSERT INTO lesson_slots " +
                "(course_id, instructor_id, vehicle_id, lesson_date, time_slot, " +
                " duration_minutes, lesson_type, capacity, bookings_count, status, notes) " +
                "VALUES (?,?,?,?,?,?,?,?,0,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt   (1, slot.getCourseId());
            ps.setInt   (2, slot.getInstructorId());
            ps.setInt   (3, slot.getVehicleId());
            ps.setDate  (4, Date.valueOf(slot.getLessonDate()));
            ps.setString(5, slot.getTimeSlot());
            ps.setInt   (6, slot.getDurationMinutes());
            ps.setString(7, slot.getLessonType());
            ps.setInt   (8, slot.getCapacity());
            ps.setString(9, slot.getStatus() == null ? "open" : slot.getStatus());
            ps.setString(10, slot.getNotes());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public LessonSlot findById(int slotId) throws SQLException {
        String sql = JOIN_SQL + "WHERE s.slot_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    public List<LessonSlot> listAll() throws SQLException {
        List<LessonSlot> out = new ArrayList<>();
        String sql = JOIN_SQL + "ORDER BY s.lesson_date DESC, s.time_slot DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(map(rs));
        }
        return out;
    }

    /** Open (not full, not cancelled) future slots for the given course. */
    public List<LessonSlot> listOpenForCourse(int courseId) throws SQLException {
        List<LessonSlot> out = new ArrayList<>();
        String sql = JOIN_SQL +
                "WHERE s.status = 'open' " +
                "  AND s.course_id = ? " +
                "  AND s.lesson_date >= CURRENT_DATE " +
                "ORDER BY s.lesson_date ASC, s.time_slot ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(map(rs));
            }
        }
        return out;
    }

    /** List slot_ids the given student has already booked (so we hide them). */
    public List<Integer> listBookedSlotIdsByStudent(int studentId) throws SQLException {
        List<Integer> out = new ArrayList<>();
        String sql = "SELECT slot_id FROM slot_bookings WHERE student_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) out.add(rs.getInt(1));
            }
        }
        return out;
    }

    /**
     * Atomically claim one seat on a slot. Returns true on success.
     * If the slot is already full / cancelled, returns false without modifying anything.
     * Also auto-flips status to 'full' when the last seat is taken.
     */
    public boolean claimSeat(int slotId) throws SQLException {
        String sql = "UPDATE lesson_slots " +
                "SET bookings_count = bookings_count + 1, " +
                "    status = CASE WHEN bookings_count + 1 >= capacity THEN 'full' ELSE 'open' END " +
                "WHERE slot_id = ? AND status = 'open' AND bookings_count < capacity";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean cancel(int slotId) throws SQLException {
        String sql = "UPDATE lesson_slots SET status='cancelled' WHERE slot_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean delete(int slotId) throws SQLException {
        String sql = "DELETE FROM lesson_slots WHERE slot_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Insert a row into slot_bookings. Throws on UNIQUE violation (student already booked). */
    public int recordBooking(int slotId, int studentId, int enrollmentId, int scheduleId)
            throws SQLException {
        String sql = "INSERT INTO slot_bookings (slot_id, student_id, enrollment_id, schedule_id) " +
                "VALUES (?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, slotId);
            ps.setInt(2, studentId);
            ps.setInt(3, enrollmentId);
            ps.setInt(4, scheduleId);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    private LessonSlot map(ResultSet rs) throws SQLException {
        LessonSlot s = new LessonSlot();
        s.setSlotId(rs.getInt("slot_id"));
        s.setCourseId(rs.getInt("course_id"));
        s.setInstructorId(rs.getInt("instructor_id"));
        s.setVehicleId(rs.getInt("vehicle_id"));
        Date d = rs.getDate("lesson_date");
        if (d != null) s.setLessonDate(d.toLocalDate());
        s.setTimeSlot(rs.getString("time_slot"));
        s.setDurationMinutes(rs.getInt("duration_minutes"));
        s.setLessonType(rs.getString("lesson_type"));
        s.setCapacity(rs.getInt("capacity"));
        s.setBookingsCount(rs.getInt("bookings_count"));
        s.setStatus(rs.getString("status"));
        s.setNotes(rs.getString("notes"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) s.setCreatedAt(ts.toLocalDateTime());
        s.setCourseName(rs.getString("course_name"));
        s.setLicenseCategory(rs.getString("license_category"));
        s.setInstructorName(rs.getString("instructor_name"));
        s.setVehicleInfo(rs.getString("vehicle_info"));
        return s;
    }
}