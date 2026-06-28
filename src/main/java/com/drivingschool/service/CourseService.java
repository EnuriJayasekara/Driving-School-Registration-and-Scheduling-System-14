package com.drivingschool.service;

import com.drivingschool.model.Course;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CRUD 5 – Course Management Service
 * Operations: create, findById, listAll, listActive, update, delete
 */
public class CourseService {

    // ---- INSERT ----
    public boolean create(Course course) throws SQLException {
        String sql = "INSERT INTO courses (course_name, license_category, total_hours, price, description, is_active) " +
                     "VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getCourseName());
            ps.setString(2, course.getLicenseCategory());
            ps.setInt(3, course.getTotalHours());
            ps.setBigDecimal(4, course.getPrice());
            ps.setString(5, course.getDescription());
            ps.setBoolean(6, course.isActive());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- SELECT by id ----
    public Course findById(int courseId) throws SQLException {
        String sql = "SELECT * FROM courses WHERE course_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ---- SELECT all ----
    public List<Course> listAll() throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- SELECT active only (for enrollment dropdowns) ----
    public List<Course> listActive() throws SQLException {
        List<Course> list = new ArrayList<>();
        String sql = "SELECT * FROM courses WHERE is_active = 1 ORDER BY license_category, course_name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- UPDATE ----
    public boolean update(Course course) throws SQLException {
        String sql = "UPDATE courses SET course_name=?, license_category=?, total_hours=?, price=?, " +
                     "description=?, is_active=? WHERE course_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, course.getCourseName());
            ps.setString(2, course.getLicenseCategory());
            ps.setInt(3, course.getTotalHours());
            ps.setBigDecimal(4, course.getPrice());
            ps.setString(5, course.getDescription());
            ps.setBoolean(6, course.isActive());
            ps.setInt(7, course.getCourseId());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- DELETE ----
    public boolean delete(int courseId) throws SQLException {
        String sql = "DELETE FROM courses WHERE course_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, courseId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Count ----
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM courses WHERE is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Row mapper ----
    private Course map(ResultSet rs) throws SQLException {
        Course c = new Course();
        c.setCourseId(rs.getInt("course_id"));
        c.setCourseName(rs.getString("course_name"));
        c.setLicenseCategory(rs.getString("license_category"));
        c.setTotalHours(rs.getInt("total_hours"));
        c.setPrice(rs.getBigDecimal("price"));
        c.setDescription(rs.getString("description"));
        c.setActive(rs.getBoolean("is_active"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) c.setCreatedAt(ca.toLocalDateTime());
        return c;
    }
}
