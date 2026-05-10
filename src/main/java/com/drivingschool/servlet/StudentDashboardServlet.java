package com.drivingschool.servlet;

import com.drivingschool.model.Schedule;
import com.drivingschool.model.Student;
import com.drivingschool.model.User;

import com.drivingschool.service.CourseService;
import com.drivingschool.service.EnrollmentService;
import com.drivingschool.service.NotificationService;
import com.drivingschool.service.ScheduleService;
import com.drivingschool.service.StudentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    private final StudentService studentService = new StudentService();
    private final EnrollmentService enrollmentService = new EnrollmentService();
    private final ScheduleService scheduleService = new ScheduleService();
    private final CourseService courseService = new CourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null ||
                (!"student".equals(session.getAttribute("role")) &&
                        !"admin".equals(session.getAttribute("role")))) {

            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try {

            Student student = studentService.findByUserId(userId);

            if (student != null) {

                req.setAttribute("student", student);

                req.setAttribute(
                        "enrollments",
                        enrollmentService.listByStudent(student.getStudentId())
                );

                java.util.List<Schedule> schedules =
                        scheduleService.listByStudent(student.getStudentId());

                req.setAttribute("schedules", schedules);

                // Extract unique instructors and vehicles
                java.util.Set<String> assignedInstructors =
                        new java.util.HashSet<>();

                java.util.Set<String> assignedVehicles =
                        new java.util.HashSet<>();

                for (Schedule s : schedules) {

                    if (s.getInstructorName() != null) {
                        assignedInstructors.add(s.getInstructorName());
                    }

                    if (s.getVehicleInfo() != null) {
                        assignedVehicles.add(s.getVehicleInfo());
                    }
                }

                req.setAttribute(
                        "assignedInstructors",
                        assignedInstructors
                );

                req.setAttribute(
                        "assignedVehicles",
                        assignedVehicles
                );
            }

            req.setAttribute(
                    "courses",
                    courseService.listActive()
            );

        } catch (SQLException e) {
            throw new ServletException(e);
        }

        req.getRequestDispatcher(
                "/WEB-INF/views/student/dashboard.jsp"
        ).forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null ||
                !"student".equals(session.getAttribute("role"))) {

            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        if ("reschedule".equals(action)) {

            try {

                int scheduleId =
                        Integer.parseInt(req.getParameter("scheduleId"));
                String newDate = req.getParameter("newDate");
                String newTime = req.getParameter("newTime");

                if (newDate == null || newTime == null || newDate.trim().isEmpty() || newTime.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=missing_datetime");
                    return;
                }

                // Find schedule
                Schedule s = scheduleService.findById(scheduleId);

                int userId = (int) session.getAttribute("userId");

                Student student =
                        studentService.findByUserId(userId);

                // Verify ownership
                boolean isOwner =
                        scheduleService
                                .listByStudent(student.getStudentId())
                                .stream()
                                .anyMatch(
                                        sch -> sch.getScheduleId() == scheduleId
                                );

                if (isOwner &&
                        s != null &&
                        "scheduled".equals(s.getStatus())) {

                    scheduleService.requestReschedule(scheduleId, newDate, newTime);

                    // Notify Admin
                    NotificationService notificationService =
                            new NotificationService();

                    notificationService.notifyAllAdmins(
                            "Reschedule Requested",
                            student.getFullName()
                                    + " requested to reschedule lesson from "
                                    + s.getLessonDate() + " to " + newDate + " " + newTime,
                            "/admin/schedules/list",
                            "warning"
                    );

                    resp.sendRedirect(
                            req.getContextPath()
                                    + "/student/dashboard?msg=reschedule_requested"
                    );

                } else {

                    resp.sendRedirect(
                            req.getContextPath()
                                    + "/student/dashboard?error=invalid_schedule"
                    );
                }

            } catch (Exception e) {

                e.printStackTrace();

                resp.sendRedirect(
                        req.getContextPath()
                                + "/student/dashboard?error=failed"
                );
            }
        }
    }
}