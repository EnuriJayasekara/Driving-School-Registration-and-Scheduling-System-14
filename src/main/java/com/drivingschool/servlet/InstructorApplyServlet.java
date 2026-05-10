package com.drivingschool.servlet;

import com.drivingschool.model.Instructor;
import com.drivingschool.model.User;
import com.drivingschool.service.InstructorService;
import com.drivingschool.service.NotificationService;
import com.drivingschool.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/instructor-apply")
public class InstructorApplyServlet extends HttpServlet {

    private final UserService userService = new UserService();
    private final InstructorService instructorService = new InstructorService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/instructor_apply.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String nic = req.getParameter("nic");
        String specialization = req.getParameter("specialization");
        String experienceYearsStr = req.getParameter("experienceYears");
        
        int experienceYears = 0;
        try {
            if (experienceYearsStr != null && !experienceYearsStr.isEmpty()) {
                experienceYears = Integer.parseInt(experienceYearsStr);
            }
        } catch (NumberFormatException e) {
            // ignore
        }

        try {
            if (userService.emailExists(email)) {
                req.setAttribute("error", "Email is already registered. Please login or use a different email.");
                req.getRequestDispatcher("/WEB-INF/views/auth/instructor_apply.jsp").forward(req, resp);
                return;
            }

            // Create inactive user with dummy password
            // Admin will assign a password when approving
            String dummyPassword = "Pending123!";
            User user = new User(fullName, email, dummyPassword, phone, "instructor");
            user.setActive(false); // Inactive until admin approves
            
            boolean created = userService.register(user);
            if (!created) {
                req.setAttribute("error", "Application failed. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/auth/instructor_apply.jsp").forward(req, resp);
                return;
            }

            // Find generated user_id
            User saved = userService.findByEmail(email);
            if (saved != null) {
                // Manually set is_active = 0 since register sets it to true initially (wait, register sets it to what we passed? Let's assume we need an update)
                saved.setActive(false);
                userService.update(saved); // Force it to be inactive
                
                Instructor instructor = new Instructor();
                instructor.setUserId(saved.getUserId());
                instructor.setLicenseNo("PENDING-" + System.currentTimeMillis());
                
                instructor.setSpecialization(specialization);
                instructor.setExperienceYears(experienceYears);
                // "inactive" status until admin approves
                instructor.setStatus("inactive"); 

                instructorService.create(instructor);
                
                // Notify admin
                notificationService.notifyAllAdmins(
                    "New Instructor Application",
                    "A new instructor application has been received from " + fullName,
                    "/admin/instructors/list",
                    "info"
                );
            }

            req.setAttribute("success", "Application submitted successfully! The admin will review and assign you a password.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
