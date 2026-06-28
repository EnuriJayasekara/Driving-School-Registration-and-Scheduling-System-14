package com.drivingschool.service;

import com.drivingschool.model.Instructor;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CRUD 3 – Instructor Management Service
 * Operations: create, findById, findByUserId, listAll, update, delete
 */
public class InstructorService {

    // ---- INSERT ----
    public boolean create(Instructor instructor) throws SQLException {
        String sql = "INSERT INTO instructors (user_id, instructor_reg_no, license_no, specialization, experience_years, status, assigned_password) " +
                     "VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, instructor.getUserId());
            ps.setString(2, instructor.getInstructorRegNo());
            ps.setString(3, instructor.getLicenseNo());
            ps.setString(4, instructor.getSpecialization());
            ps.setInt(5, instructor.getExperienceYears());
            ps.setString(6, instructor.getStatus() != null ? instructor.getStatus() : "active");
            ps.setString(7, instructor.getAssignedPassword());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- SELECT by id ----
    public Instructor findById(int instructorId) throws SQLException {
        String sql = "SELECT i.*, u.full_name, u.email, u.phone " +
                     "FROM instructors i JOIN users u ON i.user_id = u.user_id " +
                     "WHERE i.instructor_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ---- SELECT by user_id ----
    public Instructor findByUserId(int userId) throws SQLException {
        String sql = "SELECT i.*, u.full_name, u.email, u.phone " +
                     "FROM instructors i JOIN users u ON i.user_id = u.user_id " +
                     "WHERE i.user_id = ?";
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
    public List<Instructor> listAll() throws SQLException {
        List<Instructor> list = new ArrayList<>();
        String sql = "SELECT i.*, u.full_name, u.email, u.phone " +
                     "FROM instructors i JOIN users u ON i.user_id = u.user_id " +
                     "ORDER BY i.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- SELECT active instructors (for schedule dropdowns) ----
    public List<Instructor> listActive() throws SQLException {
        List<Instructor> list = new ArrayList<>();
        String sql = "SELECT i.*, u.full_name, u.email, u.phone " +
                     "FROM instructors i JOIN users u ON i.user_id = u.user_id " +
                     "WHERE i.status = 'active' ORDER BY u.full_name";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- UPDATE ----
    public boolean update(Instructor instructor) throws SQLException {
        String sql = "UPDATE instructors SET instructor_reg_no=?, license_no=?, specialization=?, experience_years=?, status=?, assigned_password=? " +
                     "WHERE instructor_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, instructor.getInstructorRegNo());
            ps.setString(2, instructor.getLicenseNo());
            ps.setString(3, instructor.getSpecialization());
            ps.setInt(4, instructor.getExperienceYears());
            ps.setString(5, instructor.getStatus());
            ps.setString(6, instructor.getAssignedPassword());
            ps.setInt(7, instructor.getInstructorId());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- DELETE ----
    public boolean delete(int instructorId) throws SQLException {
        String sql = "DELETE FROM instructors WHERE instructor_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Count ----
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM instructors";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Row mapper ----
    private Instructor map(ResultSet rs) throws SQLException {
        Instructor i = new Instructor();
        i.setInstructorId(rs.getInt("instructor_id"));
        i.setUserId(rs.getInt("user_id"));
        i.setInstructorRegNo(rs.getString("instructor_reg_no"));
        i.setLicenseNo(rs.getString("license_no"));
        i.setSpecialization(rs.getString("specialization"));
        i.setExperienceYears(rs.getInt("experience_years"));
        i.setStatus(rs.getString("status"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) i.setCreatedAt(ca.toLocalDateTime());
        i.setFullName(rs.getString("full_name"));
        i.setEmail(rs.getString("email"));
        i.setPhone(rs.getString("phone"));
        i.setAssignedPassword(rs.getString("assigned_password"));
        return i;
    }

    // ---- Student Progress Model ----
    public static class StudentProgress {
        private int progressId;
        private int studentId;
        private int instructorId;
        private String topic;
        private String achievement;
        private String comments;
        private java.time.LocalDateTime createdAt;
        private String studentName;

        public int getProgressId() { return progressId; }
        public void setProgressId(int progressId) { this.progressId = progressId; }
        public int getStudentId() { return studentId; }
        public void setStudentId(int studentId) { this.studentId = studentId; }
        public int getInstructorId() { return instructorId; }
        public void setInstructorId(int instructorId) { this.instructorId = instructorId; }
        public String getTopic() { return topic; }
        public void setTopic(String topic) { this.topic = topic; }
        public String getAchievement() { return achievement; }
        public void setAchievement(String achievement) { this.achievement = achievement; }
        public String getComments() { return comments; }
        public void setComments(String comments) { this.comments = comments; }
        public java.time.LocalDateTime getCreatedAt() { return createdAt; }
        public void setCreatedAt(java.time.LocalDateTime createdAt) { this.createdAt = createdAt; }
        public String getStudentName() { return studentName; }
        public void setStudentName(String studentName) { this.studentName = studentName; }
    }

    // ---- CRUD: Student Progress ----
    public List<com.drivingschool.model.Student> getAssignedStudents(int instructorId) throws SQLException {
        List<com.drivingschool.model.Student> list = new ArrayList<>();
        String sql = "SELECT DISTINCT s.*, u.full_name, u.email, u.phone " +
                     "FROM students s " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "JOIN enrollments e ON s.student_id = e.student_id " +
                     "JOIN schedules sc ON e.enrollment_id = sc.enrollment_id " +
                     "WHERE sc.instructor_id = ? ORDER BY u.full_name";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, instructorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.drivingschool.model.Student s = new com.drivingschool.model.Student();
                    s.setStudentId(rs.getInt("student_id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setNicNumber(rs.getString("nic_number"));
                    s.setAddress(rs.getString("address"));
                    s.setLicenseType(rs.getString("license_type"));
                    s.setStatus(rs.getString("status"));
                    s.setFullName(rs.getString("full_name"));
                    s.setEmail(rs.getString("email"));
                    s.setPhone(rs.getString("phone"));
                    list.add(s);
                }
            }
        }
        return list;
    }

    public List<StudentProgress> getProgressByStudent(int studentId) throws SQLException {
        List<StudentProgress> list = new ArrayList<>();
        String sql = "SELECT sp.*, u.full_name AS student_name " +
                     "FROM student_progress sp " +
                     "JOIN students s ON sp.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE sp.student_id = ? ORDER BY sp.updated_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    StudentProgress p = new StudentProgress();
                    p.setProgressId(rs.getInt("progress_id"));
                    p.setStudentId(rs.getInt("student_id"));
                    p.setInstructorId(rs.getInt("instructor_id"));
                    p.setTopic(rs.getString("topic"));
                    p.setAchievement(rs.getString("status"));
                    p.setComments(rs.getString("remarks"));
                    Timestamp ts = rs.getTimestamp("updated_at");
                    if (ts != null) p.setCreatedAt(ts.toLocalDateTime());
                    p.setStudentName(rs.getString("student_name"));
                    list.add(p);
                }
            }
        }
        return list;
    }

    public boolean createProgress(StudentProgress progress) throws SQLException {
        String sql = "INSERT INTO student_progress (student_id, instructor_id, topic, status, remarks, score, updated_at) VALUES (?,?,?,?,?,100,CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, progress.getStudentId());
            ps.setInt(2, progress.getInstructorId());
            ps.setString(3, progress.getTopic());
            ps.setString(4, progress.getAchievement());
            ps.setString(5, progress.getComments());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateProgress(StudentProgress progress) throws SQLException {
        String sql = "UPDATE student_progress SET topic=?, status=?, remarks=?, updated_at=CURRENT_TIMESTAMP WHERE progress_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, progress.getTopic());
            ps.setString(2, progress.getAchievement());
            ps.setString(3, progress.getComments());
            ps.setInt(4, progress.getProgressId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteProgress(int progressId) throws SQLException {
        String sql = "DELETE FROM student_progress WHERE progress_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, progressId);
            return ps.executeUpdate() > 0;
        }
    }

    public StudentProgress findProgressById(int progressId) throws SQLException {
        String sql = "SELECT sp.*, u.full_name AS student_name " +
                     "FROM student_progress sp " +
                     "JOIN students s ON sp.student_id = s.student_id " +
                     "JOIN users u ON s.user_id = u.user_id " +
                     "WHERE sp.progress_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, progressId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    StudentProgress p = new StudentProgress();
                    p.setProgressId(rs.getInt("progress_id"));
                    p.setStudentId(rs.getInt("student_id"));
                    p.setInstructorId(rs.getInt("instructor_id"));
                    p.setTopic(rs.getString("topic"));
                    p.setAchievement(rs.getString("status"));
                    p.setComments(rs.getString("remarks"));
                    Timestamp ts = rs.getTimestamp("updated_at");
                    if (ts != null) p.setCreatedAt(ts.toLocalDateTime());
                    p.setStudentName(rs.getString("student_name"));
                    return p;
                }
            }
        }
        return null;
    }
}
