package com.drivingschool.servlet;

import com.drivingschool.service.NotificationService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Shared for all roles - lists notifications for the logged-in user.
 *
 * Routes:
 *   GET  /notifications              -> list all (last 50)
 *   POST /notifications/read         -> mark one read (param: id)
 *   POST /notifications/read-all     -> mark all read
 */
@WebServlet(urlPatterns = {"/notifications", "/notifications/read", "/notifications/read-all", "/notifications/delete"})
public class NotificationServlet extends HttpServlet {

    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int userId = (Integer) s.getAttribute("userId");

        try {
            req.setAttribute("notifications", notificationService.listRecent(userId, 50));
            req.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        int userId = (Integer) s.getAttribute("userId");
        String path = req.getServletPath();

        try {
            if ("/notifications/read".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id"));
                notificationService.markRead(id, userId);
            } else if ("/notifications/delete".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id"));
                notificationService.delete(id, userId);
            } else if ("/notifications/read-all".equals(path)) {
                notificationService.markAllRead(userId);
            }
            resp.sendRedirect(req.getContextPath() + "/notifications");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}