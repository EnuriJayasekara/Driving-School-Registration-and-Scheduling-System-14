package com.drivingschool.servlet;

import com.drivingschool.model.User;
import com.drivingschool.service.UserService;
import com.drivingschool.util.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Handles "My Account" page – the logged-in user can update their
 * own profile (name / email / phone) and change their password.
 */
@WebServlet("/account")
public class AccountServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            int userId = (Integer) req.getSession().getAttribute("userId");
            User user = userService.findById(userId);
            req.setAttribute("user", user);

            if ("instructor".equals(user.getRole())) {
                com.drivingschool.service.InstructorService instService = new com.drivingschool.service.InstructorService();
                com.drivingschool.model.Instructor inst = instService.findByUserId(userId);
                req.setAttribute("instructor", inst);
            }

            req.getRequestDispatcher("/WEB-INF/views/account.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isLoggedIn(req)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        int userId = (Integer) session.getAttribute("userId");
        String formType = req.getParameter("formType");

        try {
            User current = userService.findById(userId);
            if (current == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if ("profile".equals(formType)) {
                handleProfileUpdate(req, current);
                // Refresh the session copy so the sidebar / topbar reflect changes
                session.setAttribute("loggedUser", userService.findById(userId));
                req.setAttribute("success", "Profile updated successfully.");

            } else if ("password".equals(formType)) {
                handlePasswordChange(req, current);
                req.setAttribute("success", "Password changed successfully.");
            }

        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", ex.getMessage());
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        // Re-render the page with the updated user + message
        try {
            User updatedUser = userService.findById(userId);
            req.setAttribute("user", updatedUser);
            if ("instructor".equals(updatedUser.getRole())) {
                com.drivingschool.service.InstructorService instService = new com.drivingschool.service.InstructorService();
                req.setAttribute("instructor", instService.findByUserId(userId));
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        req.getRequestDispatcher("/WEB-INF/views/account.jsp").forward(req, resp);
    }

    // ---- helpers ----

    private void handleProfileUpdate(HttpServletRequest req, User current)
            throws SQLException {

        String fullName = trim(req.getParameter("fullName"));
        String email    = trim(req.getParameter("email"));
        String phone    = trim(req.getParameter("phone"));

        if (fullName == null || fullName.isEmpty())
            throw new IllegalArgumentException("Full name is required.");
        if (email == null || email.isEmpty())
            throw new IllegalArgumentException("Email is required.");
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"))
            throw new IllegalArgumentException("Please enter a valid email address.");

        // If the email is changing, make sure it isn't already taken
        if (!email.equalsIgnoreCase(current.getEmail()) && userService.emailExists(email)) {
            throw new IllegalArgumentException("That email is already in use by another account.");
        }

        current.setFullName(fullName);
        current.setEmail(email);
        current.setPhone(phone);
        userService.updateProfile(current);

        if ("instructor".equals(current.getRole())) {
            com.drivingschool.service.InstructorService instService = new com.drivingschool.service.InstructorService();
            com.drivingschool.model.Instructor inst = instService.findByUserId(current.getUserId());
            if (inst != null) {
                String licenseNo = trim(req.getParameter("licenseNo"));
                String specialization = trim(req.getParameter("specialization"));
                String expStr = trim(req.getParameter("experienceYears"));
                int experienceYears = (expStr == null || expStr.isEmpty()) ? 0 : Integer.parseInt(expStr);

                if (licenseNo == null || licenseNo.isEmpty()) {
                    throw new IllegalArgumentException("Registration Number (License No) is required.");
                }

                inst.setLicenseNo(licenseNo);
                inst.setSpecialization(specialization);
                inst.setExperienceYears(experienceYears);
                instService.update(inst);
            }
        }
    }

    private void handlePasswordChange(HttpServletRequest req, User current)
            throws SQLException {

        String currentPass = req.getParameter("currentPassword");
        String newPass     = req.getParameter("newPassword");
        String confirmPass = req.getParameter("confirmPassword");

        if (currentPass == null || newPass == null || confirmPass == null
                || currentPass.isEmpty() || newPass.isEmpty() || confirmPass.isEmpty()) {
            throw new IllegalArgumentException("All password fields are required.");
        }
        if (!PasswordUtil.verify(currentPass, current.getPasswordHash())) {
            throw new IllegalArgumentException("Current password is incorrect.");
        }
        if (newPass.length() < 6) {
            throw new IllegalArgumentException("New password must be at least 6 characters.");
        }
        if (!newPass.equals(confirmPass)) {
            throw new IllegalArgumentException("New password and confirmation do not match.");
        }
        if (newPass.equals(currentPass)) {
            throw new IllegalArgumentException("New password must be different from current password.");
        }

        userService.updatePassword(current.getUserId(), newPass);
    }

    private boolean isLoggedIn(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && s.getAttribute("userId") != null;
    }

    private String trim(String s) {
        return s == null ? null : s.trim();
    }
}