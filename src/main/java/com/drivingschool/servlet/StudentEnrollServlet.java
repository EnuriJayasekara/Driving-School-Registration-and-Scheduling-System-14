package com.drivingschool.servlet;

import com.drivingschool.model.Course;
import com.drivingschool.model.Student;
import com.drivingschool.service.CourseService;
import com.drivingschool.service.EnrollmentService;
import com.drivingschool.service.StudentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

/**
 * Handles the student-facing course details page and payment page.
 * Browse page is still served by EnrollmentServlet at /student/enroll.
 *
 * Routes:
 *   GET /student/enroll/details?courseId=X  -> show course details
 *   GET /student/enroll/payment?courseId=X  -> show fake payment form
 */
@WebServlet(urlPatterns = {"/student/enroll/details", "/student/enroll/payment"})
public class StudentEnrollServlet extends HttpServlet {

    private final CourseService     courseService     = new CourseService();
    private final StudentService    studentService    = new StudentService();
    private final EnrollmentService enrollmentService = new EnrollmentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"student".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String courseIdStr = req.getParameter("courseId");
        if (courseIdStr == null || courseIdStr.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/enroll");
            return;
        }

        try {
            int courseId = Integer.parseInt(courseIdStr);
            Course course = courseService.findById(courseId);

            if (course == null || !course.isActive()) {
                resp.sendRedirect(req.getContextPath() + "/student/enroll?error=notfound");
                return;
            }

            // Already-enrolled check (so the student can't pay twice for the same course)
            int userId = (Integer) session.getAttribute("userId");
            Student student = studentService.findByUserId(userId);
            boolean alreadyEnrolled = false;
            if (student != null) {
                alreadyEnrolled = enrollmentService.listByStudent(student.getStudentId())
                        .stream()
                        .anyMatch(e -> e.getCourseId() == courseId);
            }

            req.setAttribute("course", course);
            req.setAttribute("alreadyEnrolled", alreadyEnrolled);

            String path = req.getServletPath();   // "/student/enroll/details" or "/student/enroll/payment"
            if ("/student/enroll/payment".equals(path)) {
                if (alreadyEnrolled) {
                    resp.sendRedirect(req.getContextPath() +
                            "/student/enroll/details?courseId=" + courseId);
                    return;
                }
                req.getRequestDispatcher("/WEB-INF/views/enrollment/payment.jsp").forward(req, resp);
            } else {
                req.getRequestDispatcher("/WEB-INF/views/enrollment/course_details.jsp").forward(req, resp);
            }

        } catch (NumberFormatException nfe) {
            resp.sendRedirect(req.getContextPath() + "/student/enroll");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}