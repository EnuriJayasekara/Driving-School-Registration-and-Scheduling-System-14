package com.drivingschool.service;

import com.drivingschool.model.Enrollment;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/** Enrollment CRUD – used primarily by Student and Admin servlets. */
public class EnrollmentService {

    // ---- INSERT ----
    public boolean create(Enrollment enrollment) throws SQLException {
        String sql = "INSERT INTO enrollments (student_id, course_id, enrollment_date, payment_status, amount_paid, status, notes) " +
                     "VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, enrollment.getStudentId());
            ps.setInt(2, enrollment.getCourseId());
            ps.setDate(3, Date.valueOf(LocalDate.now()));
            ps.setString(4, enrollment.getPaymentStatus() != null ? enrollment.getPaymentStatus() : "pending");
            ps.setBigDecimal(5, enrollment.getAmountPaid());
            ps.setString(6, enrollment.getStatus() != null ? enrollment.getStatus() : "active");
            ps.setString(7, enrollment.getNotes());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- SELECT by id ----
    public Enrollment findById(int enrollmentId) throws SQLException {
        String sql = buildJoinedQuery() + " WHERE e.enrollment_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, enrollmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ---- SELECT all ----
    public List<Enrollment> listAll() throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = buildJoinedQuery() + " ORDER BY e.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- SELECT by student ----
    public List<Enrollment> listByStudent(int studentId) throws SQLException {
        List<Enrollment> list = new ArrayList<>();
        String sql = buildJoinedQuery() + " WHERE e.student_id = ? ORDER BY e.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    // ---- UPDATE ----
    public boolean update(Enrollment enrollment) throws SQLException {
        String sql = "UPDATE enrollments SET course_id=?, payment_status=?, amount_paid=?, status=?, notes=? " +
                     "WHERE enrollment_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, enrollment.getCourseId());
            ps.setString(2, enrollment.getPaymentStatus());
            ps.setBigDecimal(3, enrollment.getAmountPaid());
            ps.setString(4, enrollment.getStatus());
            ps.setString(5, enrollment.getNotes());
            ps.setInt(6, enrollment.getEnrollmentId());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- DELETE ----
    public boolean delete(int enrollmentId) throws SQLException {
        String sql = "DELETE FROM enrollments WHERE enrollment_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, enrollmentId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Count active ----
    public int countActive() throws SQLException {
        String sql = "SELECT COUNT(*) FROM enrollments WHERE status='active'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private String buildJoinedQuery() {
        return "SELECT e.*, u.full_name AS student_name, c.course_name, c.price AS course_price " +
               "FROM enrollments e " +
               "JOIN students st ON e.student_id = st.student_id " +
               "JOIN users u     ON st.user_id   = u.user_id " +
               "JOIN courses c   ON e.course_id  = c.course_id";
    }

    private Enrollment map(ResultSet rs) throws SQLException {
        Enrollment e = new Enrollment();
        e.setEnrollmentId(rs.getInt("enrollment_id"));
        e.setStudentId(rs.getInt("student_id"));
        e.setCourseId(rs.getInt("course_id"));
        Date ed = rs.getDate("enrollment_date");
        if (ed != null) e.setEnrollmentDate(ed.toLocalDate());
        e.setPaymentStatus(rs.getString("payment_status"));
        e.setAmountPaid(rs.getBigDecimal("amount_paid"));
        e.setStatus(rs.getString("status"));
        e.setNotes(rs.getString("notes"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) e.setCreatedAt(ca.toLocalDateTime());
        e.setStudentName(rs.getString("student_name"));
        e.setCourseName(rs.getString("course_name"));
        e.setCoursePrice(rs.getBigDecimal("course_price"));
        return e;
    }
}
