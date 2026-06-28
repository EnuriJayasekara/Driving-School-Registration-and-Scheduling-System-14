package com.drivingschool.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for MySQL database connections.
 * Provides a singleton-style static connection factory.
 */
public class DBConnection {

    private static final String DRIVER   = "com.mysql.cj.jdbc.Driver";
    private static final String URL      = "jdbc:mysql://localhost:3306/driving_school_db_v3"
                                         + "?useSSL=false&serverTimezone=Asia/Colombo"
                                         + "&allowPublicKeyRetrieval=true"
                                         + "&characterEncoding=UTF-8";
    private static final String DB_USER  = "root";
    private static final String DB_PASS  = "Enuri12345@$";          // change to your MySQL password

    static {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    /** Returns a new Connection.  Caller must close it in a finally / try-with-resources block. */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, DB_USER, DB_PASS);
    }

    /** Silently closes a Connection (null-safe). */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
