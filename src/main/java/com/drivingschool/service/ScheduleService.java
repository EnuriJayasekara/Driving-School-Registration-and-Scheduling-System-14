package com.drivingschool.service;

import com.drivingschool.model.*;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CRUD 6 – Schedule Management Service
 * Operations: create, findById, listAll, listByStudent, listByInstructor, update, delete
 */
public class ScheduleService {

    // ---- INSERT ----
    public boolean create(Schedule schedule) throws SQLException {
        String sql = "INSERT INTO schedules (enrollment_id, instructor_id, vehicle_id, lesson_date, " +
                "time_slot, duration_minutes, lesson_type, status, notes) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, schedule.getEnrollmentId());
            ps.setInt(2, schedule.getInstructorId());
            ps.setInt(3, schedule.getVehicleId());
            ps.setDate(4, Date.valueOf(schedule.getLessonDate()));
            ps.setString(5, schedule.getTimeSlot());
            ps.setInt(6, schedule.getDurationMinutes());
            ps.setString(7, schedule.getLessonType());
            ps.setString(8, schedule.getStatus() != null ? schedule.getStatus() : "scheduled");
            ps.setString(9, schedule.getNotes());
            boolean success = ps.executeUpdate() > 0;
            if (success) {
                try { notifyUsersOnSchedule(schedule, "new"); } catch (Exception ex) {}
            }
            return success;
        }
    }

    // ---- INSERT and return generated schedule_id ----
    /**
     * Inserts a schedule and returns the generated schedule_id.
     * Returns -1 on failure. Used by the slot-booking flow so the booking
     * audit row can reference the created schedule.
     */
    public int createReturnId(Schedule schedule) throws SQLException {
        String sql = "INSERT INTO schedules (enrollment_id, instructor_id, vehicle_id, lesson_date, " +
                "time_slot, duration_minutes, lesson_type, status, notes) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, schedule.getEnrollmentId());
            ps.setInt(2, schedule.getInstructorId());
            ps.setInt(3, schedule.getVehicleId());
            ps.setDate(4, Date.valueOf(schedule.getLessonDate()));
            ps.setString(5, schedule.getTimeSlot());
            ps.setInt(6, schedule.getDurationMinutes());
            ps.setString(7, schedule.getLessonType());
            ps.setString(8, schedule.getStatus() != null ? schedule.getStatus() : "scheduled");
            ps.setString(9, schedule.getNotes());

            int affected = ps.executeUpdate();
            if (affected == 0) return -1;

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    int newId = keys.getInt(1);
                    schedule.setScheduleId(newId);
                    try { notifyUsersOnSchedule(schedule, "new"); } catch (Exception ex) {}
                    return newId;
                }
            }
            return -1;
        }
    }

    // ---- SELECT by id ----
    public Schedule findById(int scheduleId) throws SQLException {
        String sql = buildJoinedQuery() + " WHERE sc.schedule_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ---- SELECT all ----
    public List<Schedule> listAll() throws SQLException {
        List<Schedule> list = new ArrayList<>();
        String sql = buildJoinedQuery() + " ORDER BY sc.lesson_date DESC, sc.time_slot";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- SELECT by student (via enrollment) ----
    public List<Schedule> listByStudent(int studentId) throws SQLException {
        List<Schedule> list = new ArrayList<>();
        String sql = buildJoinedQuery() +
                " WHERE e.student_id = ? ORDER BY sc.lesson_date DESC, sc.time_slot";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    // ---- SELECT by instructor ----
    public List<Schedule> listByInstructor(int instructorId) throws SQLException {
        List<Schedule> list = new ArrayList<>();
        String sql = buildJoinedQuery() +
                " WHERE sc.instructor_id = ? ORDER BY sc.lesson_date DESC, sc.time_slot";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    // ---- SELECT by vehicle ----
    public List<Schedule> listByVehicle(int vehicleId) throws SQLException {
        List<Schedule> list = new ArrayList<>();
        String sql = buildJoinedQuery() +
                " WHERE sc.vehicle_id = ? ORDER BY sc.lesson_date DESC, sc.time_slot";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    // ---- UPDATE ----
    public boolean update(Schedule schedule) throws SQLException {
        String sql = "UPDATE schedules SET instructor_id=?, vehicle_id=?, lesson_date=?, " +
                "time_slot=?, duration_minutes=?, lesson_type=?, status=?, notes=? " +
                "WHERE schedule_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, schedule.getInstructorId());
            ps.setInt(2, schedule.getVehicleId());
            ps.setDate(3, Date.valueOf(schedule.getLessonDate()));
            ps.setString(4, schedule.getTimeSlot());
            ps.setInt(5, schedule.getDurationMinutes());
            ps.setString(6, schedule.getLessonType());
            ps.setString(7, schedule.getStatus());
            ps.setString(8, schedule.getNotes());
            ps.setInt(9, schedule.getScheduleId());
            boolean success = ps.executeUpdate() > 0;
            if (success) {
                try { notifyUsersOnSchedule(schedule, "edit"); } catch (Exception ex) {}
            }
            return success;
        }
    }

    public boolean requestReschedule(int scheduleId, String newDate, String newTime) throws SQLException {
        String msg = "RESCHEDULE_REQUESTED (" + newDate + " " + newTime + "): ";
        String sql = "UPDATE schedules SET notes = CONCAT(?, IFNULL(notes,'')) WHERE schedule_id=? AND status='scheduled'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, msg);
            ps.setInt(2, scheduleId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- DELETE ----
    public boolean delete(int scheduleId) throws SQLException {
        String sql = "DELETE FROM schedules WHERE schedule_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, scheduleId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Count upcoming ----
    public int countUpcoming() throws SQLException {
        String sql = "SELECT COUNT(*) FROM schedules WHERE lesson_date >= CURDATE() AND status='scheduled'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Shared JOIN query ----
    private String buildJoinedQuery() {
        return "SELECT sc.*, " +
                "st.student_id, " +
                "u_s.full_name AS student_name, " +
                "u_i.full_name AS instructor_name, " +
                "CONCAT(v.make,' ',v.model,' (',v.registration_no,')') AS vehicle_info, " +
                "c.course_name " +
                "FROM schedules sc " +
                "JOIN enrollments e   ON sc.enrollment_id   = e.enrollment_id " +
                "JOIN students   st   ON e.student_id        = st.student_id " +
                "JOIN users      u_s  ON st.user_id          = u_s.user_id " +
                "JOIN instructors ins ON sc.instructor_id    = ins.instructor_id " +
                "JOIN users      u_i  ON ins.user_id         = u_i.user_id " +
                "JOIN vehicles   v    ON sc.vehicle_id       = v.vehicle_id " +
                "JOIN courses    c    ON e.course_id         = c.course_id";
    }

    // ---- Row mapper ----
    private Schedule map(ResultSet rs) throws SQLException {
        Schedule s = new Schedule();
        s.setScheduleId(rs.getInt("schedule_id"));
        s.setEnrollmentId(rs.getInt("enrollment_id"));
        s.setInstructorId(rs.getInt("instructor_id"));
        s.setVehicleId(rs.getInt("vehicle_id"));
        Date ld = rs.getDate("lesson_date");
        if (ld != null) s.setLessonDate(ld.toLocalDate());
        s.setTimeSlot(rs.getString("time_slot"));
        s.setDurationMinutes(rs.getInt("duration_minutes"));
        s.setLessonType(rs.getString("lesson_type"));
        s.setStatus(rs.getString("status"));
        s.setNotes(rs.getString("notes"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) s.setCreatedAt(ca.toLocalDateTime());
        s.setStudentId(rs.getInt("student_id"));
        s.setStudentName(rs.getString("student_name"));
        s.setInstructorName(rs.getString("instructor_name"));
        s.setVehicleInfo(rs.getString("vehicle_info"));
        s.setCourseName(rs.getString("course_name"));
        return s;
    }

    private void notifyUsersOnSchedule(Schedule schedule, String action) {
        try {
            EnrollmentService enrollmentService = new EnrollmentService();
            com.drivingschool.model.Enrollment e = enrollmentService.findById(schedule.getEnrollmentId());
            if (e != null) {
                StudentService ss = new StudentService();
                com.drivingschool.model.Student st = ss.findById(e.getStudentId());
                if (st != null) {
                    InstructorService is = new InstructorService();
                    com.drivingschool.model.Instructor inst = is.findById(schedule.getInstructorId());
                    if (inst != null) {
                        NotificationService ns = new NotificationService();
                        String title = "New Lesson Scheduled";
                        String studentMsg = "You have been scheduled for a " + schedule.getLessonType() + 
                                           " lesson on " + schedule.getLessonDate() + " at " + schedule.getTimeSlot() + 
                                           " with Instructor " + inst.getFullName() + ".";
                        String instructorMsg = "You have been assigned to conduct a " + schedule.getLessonType() + 
                                             " lesson on " + schedule.getLessonDate() + " at " + schedule.getTimeSlot() + 
                                             " for student " + st.getFullName() + ".";
                        
                        if ("edit".equalsIgnoreCase(action)) {
                            title = "Lesson Schedule Updated";
                            studentMsg = "Your lesson on " + schedule.getLessonDate() + " at " + schedule.getTimeSlot() + 
                                         " has been updated. Instructor: " + inst.getFullName() + ".";
                            instructorMsg = "Your assigned lesson on " + schedule.getLessonDate() + " at " + schedule.getTimeSlot() + 
                                             " for student " + st.getFullName() + " has been updated.";
                        }
                        
                        // Notify Student
                        ns.notify(st.getUserId(), title, studentMsg, "/student/dashboard", "info");
                        
                        // Notify Instructor
                        ns.notify(inst.getUserId(), title, instructorMsg, "/instructor/dashboard?view=lessons", "info");
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

}