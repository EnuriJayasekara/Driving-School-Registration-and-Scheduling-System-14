<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.drivingschool.util.DBConnection" %>
<html>
<head><title>Database Migration - Testimonials</title></head>
<body>
<h3>Database Migration Status</h3>
<%
    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement()) {
        
        // 1. Create testimonials table
        String sql = "CREATE TABLE IF NOT EXISTS testimonials (" +
                     "  testimonial_id INT NOT NULL AUTO_INCREMENT," +
                     "  student_name VARCHAR(100) NOT NULL," +
                     "  rating INT NOT NULL DEFAULT 5," +
                     "  message TEXT NOT NULL," +
                     "  license_category VARCHAR(50) DEFAULT 'B-Class'," +
                     "  is_approved TINYINT(1) NOT NULL DEFAULT 1," +
                     "  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
                     "  PRIMARY KEY (testimonial_id)" +
                     ") ENGINE=InnoDB";
        stmt.executeUpdate(sql);
        out.println("<p style='color:green;'>✓ Testimonials table created successfully or already existed.</p>");
        
        // 2. Insert sample testimonials if empty
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM testimonials");
        if (rs.next() && rs.getInt(1) == 0) {
            stmt.executeUpdate("INSERT INTO testimonials (student_name, rating, message, license_category) VALUES (" +
                               "  'Dilhan Perera', 5, 'Passed my driving exam on the very first try! My instructor was incredibly patient and structured the lessons to cover exactly what I needed to know.', 'B-Class Graduate')");
            stmt.executeUpdate("INSERT INTO testimonials (student_name, rating, message, license_category) VALUES (" +
                               "  'Anjali Silva', 5, 'The online scheduling platform made it so easy to book lessons around my work hours. I highly recommend DriveEdu to anyone looking for a stress-free experience.', 'A1 Motorcycle Student')");
            stmt.executeUpdate("INSERT INTO testimonials (student_name, rating, message, license_category) VALUES (" +
                               "  'Mohammed Rifan', 5, 'Excellent training for commercial heavy vehicles. The trucks are in top condition and the instructors have years of real road experience.', 'CE-Class Heavy Truck Student')");
            out.println("<p style='color:green;'>✓ Populated default testimonials successfully.</p>");
        } else {
            out.println("<p>ℹ Testimonials table already contains data.</p>");
        }
        
    } catch (Exception ex) {
        out.println("<p style='color:red;'>✗ Migration failed: " + ex.getMessage() + "</p>");
        ex.printStackTrace(new java.io.PrintWriter(out));
    }
%>
</body>
</html>
