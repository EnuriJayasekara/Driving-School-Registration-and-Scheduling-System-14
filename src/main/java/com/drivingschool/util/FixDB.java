package com.drivingschool.util;

import java.sql.Connection;
import java.sql.Statement;

public class FixDB {
    public static void main(String[] args) {
        String sql = "CREATE TABLE IF NOT EXISTS notifications (" +
                "notification_id INT NOT NULL AUTO_INCREMENT, " +
                "user_id INT NOT NULL, " +
                "title VARCHAR(255) NOT NULL, " +
                "message TEXT NOT NULL, " +
                "link VARCHAR(255), " +
                "type VARCHAR(50) DEFAULT 'info', " +
                "is_read TINYINT(1) DEFAULT 0, " +
                "created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, " +
                "PRIMARY KEY (notification_id), " +
                "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE" +
                ") ENGINE=InnoDB;";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
            System.out.println("Notifications table created successfully!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
