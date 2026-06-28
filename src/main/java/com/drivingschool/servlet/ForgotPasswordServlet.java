package com.drivingschool.servlet;

import com.drivingschool.model.User;
import com.drivingschool.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/auth/forgot_password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String email = req.getParameter("email");
        String newPassword = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        try {
            if (!newPassword.equals(confirmPassword)) {
                req.setAttribute("error", "Passwords do not match.");
                req.getRequestDispatcher("/WEB-INF/views/auth/forgot_password.jsp").forward(req, resp);
                return;
            }

            User user = userService.findByEmail(email);
            if (user == null) {
                req.setAttribute("error", "No account found with that email address.");
                req.getRequestDispatcher("/WEB-INF/views/auth/forgot_password.jsp").forward(req, resp);
                return;
            }

            boolean updated = userService.updatePassword(user.getUserId(), newPassword);
            if (updated) {
                req.setAttribute("success", "Password successfully reset. You can now login.");
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("error", "Failed to update password. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/auth/forgot_password.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
