package com.drivingschool.servlet;

import com.drivingschool.service.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final StudentService    studentService    = new StudentService();
    private final InstructorService instructorService = new InstructorService();
    private final VehicleService    vehicleService    = new VehicleService();
    private final CourseService     courseService     = new CourseService();
    private final EnrollmentService enrollmentService = new EnrollmentService();
    private final ScheduleService   scheduleService   = new ScheduleService();

    private final UserService       userService       = new UserService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            req.setAttribute("totalStudents",    studentService.count());
            req.setAttribute("totalInstructors", instructorService.count());
            req.setAttribute("totalVehicles",    vehicleService.count());
            req.setAttribute("totalCourses",     courseService.count());
            req.setAttribute("activeEnrollments",enrollmentService.countActive());
            req.setAttribute("upcomingLessons",  scheduleService.countUpcoming());
            req.setAttribute("usersList",        userService.listAll());
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("sendNotification".equals(action)) {
                int targetUserId = Integer.parseInt(req.getParameter("targetUserId"));
                String title = req.getParameter("title");
                String message = req.getParameter("message");
                String type = req.getParameter("type");

                notificationService.notify(targetUserId, title, message, "/notifications", type);
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard?msg=alert_sent");
                return;
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }
}
