package com.drivingschool.service;

import com.drivingschool.model.Vehicle;
import com.drivingschool.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CRUD 4 – Vehicle Management Service
 * Operations: create, findById, listAll, listAvailable, update, delete
 */
public class VehicleService {

    // ---- INSERT ----
    public boolean create(Vehicle vehicle) throws SQLException {
        String sql = "INSERT INTO vehicles (registration_no, make, model, year, transmission_type, " +
                "fuel_type, seating_capacity, status, category, vehicle_type) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vehicle.getRegistrationNo());
            ps.setString(2, vehicle.getMake());
            ps.setString(3, vehicle.getModel());
            ps.setInt   (4, vehicle.getYear());
            ps.setString(5, vehicle.getTransmissionType());
            ps.setString(6, vehicle.getFuelType());
            ps.setInt   (7, vehicle.getSeatingCapacity() > 0 ? vehicle.getSeatingCapacity() : 5);
            ps.setString(8, vehicle.getStatus() != null ? vehicle.getStatus() : "available");
            ps.setString(9, vehicle.getCategory());
            ps.setString(10, vehicle.getVehicleType());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- SELECT by id ----
    public Vehicle findById(int vehicleId) throws SQLException {
        String sql = "SELECT * FROM vehicles WHERE vehicle_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ---- SELECT all ----
    public List<Vehicle> listAll() throws SQLException {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicles ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- SELECT available vehicles (for schedule dropdowns) ----
    public List<Vehicle> listAvailable() throws SQLException {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicles WHERE status = 'available' ORDER BY make, model";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ---- UPDATE ----
    public boolean update(Vehicle vehicle) throws SQLException {
        String sql = "UPDATE vehicles SET registration_no=?, make=?, model=?, year=?, " +
                "transmission_type=?, fuel_type=?, seating_capacity=?, status=?, category=?, vehicle_type=? WHERE vehicle_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, vehicle.getRegistrationNo());
            ps.setString(2, vehicle.getMake());
            ps.setString(3, vehicle.getModel());
            ps.setInt   (4, vehicle.getYear());
            ps.setString(5, vehicle.getTransmissionType());
            ps.setString(6, vehicle.getFuelType());
            ps.setInt   (7, vehicle.getSeatingCapacity() > 0 ? vehicle.getSeatingCapacity() : 5);
            ps.setString(8, vehicle.getStatus());
            ps.setString(9, vehicle.getCategory());
            ps.setString(10, vehicle.getVehicleType());
            ps.setInt   (11, vehicle.getVehicleId());
            return ps.executeUpdate() > 0;
        }
    }

    // ---- DELETE ----
    public boolean delete(int vehicleId) throws SQLException {
        String sql = "DELETE FROM vehicles WHERE vehicle_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            return ps.executeUpdate() > 0;
        }
    }

    // ---- Count ----
    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM vehicles";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ---- Row mapper ----
    private Vehicle map(ResultSet rs) throws SQLException {
        Vehicle v = new Vehicle();
        v.setVehicleId(rs.getInt("vehicle_id"));
        v.setRegistrationNo(rs.getString("registration_no"));
        v.setMake(rs.getString("make"));
        v.setModel(rs.getString("model"));
        v.setYear(rs.getInt("year"));
        v.setTransmissionType(rs.getString("transmission_type"));
        v.setFuelType(rs.getString("fuel_type"));
        v.setSeatingCapacity(rs.getInt("seating_capacity"));
        v.setStatus(rs.getString("status"));
        v.setCategory(rs.getString("category"));
        v.setVehicleType(rs.getString("vehicle_type"));
        Timestamp ca = rs.getTimestamp("created_at");
        if (ca != null) v.setCreatedAt(ca.toLocalDateTime());
        return v;
    }
}
