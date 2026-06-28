package com.drivingschool.service;

import com.drivingschool.model.Student;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CRUD 2 – Student Management Service
 * Operations: create, findById, findByUserId, listAll, update, delete
 */
public class StudentService {

    // ---- INSERT ----
    public boolean create(Student student) throws SQLException {
        String sql = "INSERT INTO students (user_id, student_reg_no, nic_number, dob, address, license_type, status, trial_date) " +
                     "VALUES (?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, student.getUserId());
            ps.setString(2, student.getStudentRegNo());
            ps.setString(3, student.getNicNumber());
            ps.setDate(4, student.getDob() != null ? Date.valueOf(student.getDob()) : null);
            ps.setString(5, student.getAddress());
            ps.setString(6, student.getLicenseType());
            ps.setString(7, student.getStatus() != null ? student.getStatus() : "pending");
            ps.setDate(8, student.getTrialDate() != null ? Date.valueOf(student.getTrialDate()) : null);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- SELECT by id ----
    public Student findById(int studentId) throws SQLException {
        String sql = "SELECT s.*, u.full_name, u.email, u.phone " +
                     "FROM students s JOIN users u ON s.user_id = u.user_id " +
                     "WHERE s.student_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ---- SELECT by user_id ----
    public Student findByUserId(int userId) throws SQLException {
        String sql = "SELECT s.*, u.full_name, u.email, u.phone " +
                     "FROM students s JOIN users u ON s.user_id = u.user_id " +
                     "WHERE s.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ---- SELECT all ----
    public List<Student> listAll() throws SQLException {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT s.*, u.full_name, u.email, u.phone " +
                     "FROM students s JOIN users u ON s.user_id = u.user_id " +
                     "ORDER BY s.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- UPDATE ----
    public boolean update(Student student) throws SQLException {
        String sql = "UPDATE students SET student_reg_no=?, nic_number=?, dob=?, address=?, license_type=?, status=?, trial_date=? " +
                     "WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, student.getStudentRegNo());
            ps.setString(2, student.getNicNumber());
            ps.setDate(3, student.getDob() != null ? Date.valueOf(student.getDob()) : null);
            ps.setString(4, student.getAddress());
            ps.setString(5, student.getLicenseType());
            ps.setString(6, student.getStatus());
            ps.setDate(7, student.getTrialDate() != null ? Date.valueOf(student.getTrialDate()) : null);
            ps.setInt(8, student.getStudentId());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- DELETE ----
    public boolean delete(int studentId) throws SQLException {
        String sql = "DELETE FROM students WHERE student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Count ----
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM students";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Row mapper ----
    private Student map(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setStudentId(rs.getInt("student_id"));
        s.setUserId(rs.getInt("user_id"));
        s.setStudentRegNo(rs.getString("student_reg_no"));
        s.setNicNumber(rs.getString("nic_number"));
        Date dob = rs.getDate("dob");
        if (dob != null) s.setDob(dob.toLocalDate());
        s.setAddress(rs.getString("address"));
        s.setLicenseType(rs.getString("license_type"));
        s.setStatus(rs.getString("status"));
        Date td = rs.getDate("trial_date");
        if (td != null) s.setTrialDate(td.toLocalDate());
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) s.setCreatedAt(ca.toLocalDateTime());
        // joined
        s.setFullName(rs.getString("full_name"));
        s.setEmail(rs.getString("email"));
        s.setPhone(rs.getString("phone"));
        return s;
    }
}
