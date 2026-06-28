package com.drivingschool.servlet;

import com.drivingschool.model.Vehicle;
import com.drivingschool.service.VehicleService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/vehicles/*", "/vehicles"})
public class VehicleServlet extends HttpServlet {

    private final VehicleService vehicleService = new VehicleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/vehicles".equals(path)) {
            try {
                List<Vehicle> vehicles = vehicleService.listAll();
                req.setAttribute("vehicles", vehicles);
                String catFilter = req.getParameter("category");
                req.setAttribute("categoryFilter", catFilter);
                forward(req, resp, "/WEB-INF/views/public_vehicles.jsp");
            } catch (SQLException e) {
                throw new ServletException(e);
            }
            return;
        }

        requireAdmin(req, resp);
        String info = req.getPathInfo();

        try {
            if (info == null || "/list".equals(info)) {
                List<Vehicle> vehicles = vehicleService.listAll();
                req.setAttribute("vehicles", vehicles);
                forward(req, resp, "/WEB-INF/views/vehicle/list.jsp");

            } else if ("/new".equals(info)) {
                forward(req, resp, "/WEB-INF/views/vehicle/form.jsp");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Vehicle vehicle = vehicleService.findById(id);
                req.setAttribute("vehicle", vehicle);
                forward(req, resp, "/WEB-INF/views/vehicle/form.jsp");

            } else if ("/delete".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                try {
                    vehicleService.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/vehicles/list?msg=deleted");
                } catch (SQLException ex) {
                    resp.sendRedirect(req.getContextPath() + "/admin/vehicles/list?error=referenced");
                }
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        requireAdmin(req, resp);
        req.setCharacterEncoding("UTF-8");
        String info = req.getPathInfo();

        String seatStr = req.getParameter("seatingCapacity");
        int seatingCapacity = seatStr != null && !seatStr.isEmpty() ? Integer.parseInt(seatStr) : 5;

        if (seatingCapacity <= 1) {
            req.setAttribute("error", "Seating capacity cannot be 0, -1, or less than 2.");
            if ("/edit".equals(info)) {
                try {
                    int id = Integer.parseInt(req.getParameter("vehicleId"));
                    req.setAttribute("vehicle", vehicleService.findById(id));
                } catch (Exception ex) {}
            }
            forward(req, resp, "/WEB-INF/views/vehicle/form.jsp");
            return;
        }

        try {
            if ("/new".equals(info)) {
                Vehicle vehicle = buildVehicle(req);
                vehicleService.create(vehicle);
                resp.sendRedirect(req.getContextPath() + "/admin/vehicles/list?msg=created");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("vehicleId"));
                Vehicle vehicle = buildVehicle(req);
                vehicle.setVehicleId(id);
                vehicleService.update(vehicle);
                resp.sendRedirect(req.getContextPath() + "/admin/vehicles/list?msg=updated");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private Vehicle buildVehicle(HttpServletRequest req) {
        Vehicle v = new Vehicle();
        v.setRegistrationNo(req.getParameter("registrationNo"));
        v.setMake(req.getParameter("make"));
        v.setModel(req.getParameter("model"));
        String yr = req.getParameter("year");
        v.setYear(yr != null && !yr.isEmpty() ? Integer.parseInt(yr) : 2023);
        v.setTransmissionType(req.getParameter("transmissionType"));
        v.setFuelType(req.getParameter("fuelType"));
        v.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "available");
        
        String seatStr = req.getParameter("seatingCapacity");
        int seatingCapacity = seatStr != null && !seatStr.isEmpty() ? Integer.parseInt(seatStr) : 5;
        v.setSeatingCapacity(seatingCapacity);

        // Auto-categorize based on seating capacity if category is empty/not specified
        String category = req.getParameter("category");
        if (category == null || category.trim().isEmpty() || "Auto-detect".equals(category)) {
            if (seatingCapacity >= 10) {
                category = "Heavy Vehicle";
            } else {
                category = "Light Vehicle";
            }
        }
        v.setCategory(category);
        
        String vehicleType = req.getParameter("vehicleType");
        v.setVehicleType(vehicleType != null && !vehicleType.isEmpty() ? vehicleType : "Car");
        
        return v;
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }

    private void requireAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
