package com.drivingschool.service;

import com.drivingschool.model.Testimonial;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TestimonialService {

    public List<Testimonial> listApproved() throws SQLException {
        List<Testimonial> list = new ArrayList<>();
        String sql = "SELECT * FROM testimonials WHERE is_approved = 1 ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public boolean create(Testimonial t) throws SQLException {
        String sql = "INSERT INTO testimonials (student_name, rating, message, license_category, is_approved) VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getStudentName());
            ps.setInt(2, t.getRating());
            ps.setString(3, t.getMessage());
            ps.setString(4, t.getLicenseCategory() != null ? t.getLicenseCategory() : "B-Class Student");
            ps.setInt(5, 1); // Approved by default for this simple public submission flow
            return ps.executeUpdate() > 0;
        }
    }

    private Testimonial map(ResultSet rs) throws SQLException {
        Testimonial t = new Testimonial();
        t.setTestimonialId(rs.getInt("testimonial_id"));
        t.setStudentName(rs.getString("student_name"));
        t.setRating(rs.getInt("rating"));
        t.setMessage(rs.getString("message"));
        t.setLicenseCategory(rs.getString("license_category"));
        t.setApproved(rs.getInt("is_approved") == 1);
        t.setCreatedAt(rs.getTimestamp("created_at"));
        return t;
    }
}
