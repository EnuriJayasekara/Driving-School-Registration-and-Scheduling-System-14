package com.drivingschool.servlet;
import com.drivingschool.model.Course;
import com.drivingschool.model.Enrollment;
import com.drivingschool.model.Student;
import com.drivingschool.service.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/enrollments/*", "/student/enroll", "/student/invoice"})
public class EnrollmentServlet extends HttpServlet {

    private final EnrollmentService enrollmentService = new EnrollmentService();
    private final StudentService    studentService    = new StudentService();
    private final CourseService     courseService     = new CourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String path = req.getServletPath();

        try {
            if ("/student/invoice".equals(path)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Enrollment en = enrollmentService.findById(id);
                if (en != null) {
                    req.setAttribute("enrollment", en);
                    req.setAttribute("course", courseService.findById(en.getCourseId()));
                    // Student details
                    Student st = studentService.findById(en.getStudentId());
                    req.setAttribute("student", st);
                    req.getRequestDispatcher("/WEB-INF/views/enrollment/invoice.jsp").forward(req, resp);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=notfound");
                }
                return;
            }

            if (path.startsWith("/admin")) {
                requireAdmin(req, resp);
                String info = req.getPathInfo();

                if (info == null || "/list".equals(info)) {
                    req.setAttribute("enrollments", enrollmentService.listAll());
                    req.getRequestDispatcher("/WEB-INF/views/enrollment/list.jsp").forward(req, resp);

                } else if ("/new".equals(info)) {
                    req.setAttribute("students", studentService.listAll());
                    req.setAttribute("courses",  courseService.listActive());
                    req.getRequestDispatcher("/WEB-INF/views/enrollment/form.jsp").forward(req, resp);

                } else if ("/edit".equals(info)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("enrollment", enrollmentService.findById(id));
                    req.setAttribute("courses",    courseService.listActive());
                    req.getRequestDispatcher("/WEB-INF/views/enrollment/form.jsp").forward(req, resp);

                } else if ("/delete".equals(info)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    enrollmentService.delete(id);
                    resp.sendRedirect(req.getContextPath() + "/admin/enrollments/list?msg=deleted");
                }

            } else {
                // /student/enroll – GET shows available courses
                req.setAttribute("courses", courseService.listActive());
                req.getRequestDispatcher("/WEB-INF/views/enrollment/student_enroll.jsp").forward(req, resp);
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String path = req.getServletPath();

        try {
            if (path.startsWith("/admin")) {
                requireAdmin(req, resp);
                String info = req.getPathInfo();

                if ("/new".equals(info)) {
                    Enrollment e = buildEnrollment(req);
                    enrollmentService.create(e);
                    resp.sendRedirect(req.getContextPath() + "/admin/enrollments/list?msg=created");

                } else if ("/edit".equals(info)) {
                    int id = Integer.parseInt(req.getParameter("enrollmentId"));
                    Enrollment e = buildEnrollment(req);
                    e.setEnrollmentId(id);
                    enrollmentService.update(e);
                    resp.sendRedirect(req.getContextPath() + "/admin/enrollments/list?msg=updated");
                }
            } else {
                // Student self-enrollment (after payment)
                int userId = (int) session.getAttribute("userId");
                Student student = studentService.findByUserId(userId);

                if (student == null) {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=nostudent");
                    return;
                }

                int courseId = Integer.parseInt(req.getParameter("courseId"));

                // Block double-enrollment in the same course
                boolean already = enrollmentService.listByStudent(student.getStudentId())
                        .stream().anyMatch(en -> en.getCourseId() == courseId);
                if (already) {
                    resp.sendRedirect(req.getContextPath()
                            + "/student/dashboard?error=alreadyenrolled");
                    return;
                }

                // Strictly validate Card Details
                String cardHolderName = req.getParameter("cardHolderName");
                String cardNumber     = req.getParameter("cardNumber");
                String cvv            = req.getParameter("cvv");
                String expiryMonth    = req.getParameter("expiryMonth");
                String expiryYear     = req.getParameter("expiryYear");

                if (cardHolderName == null || cardHolderName.trim().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/student/enroll?courseId=" + courseId + "&error=invalid_cardholder");
                    return;
                }

                String cardClean = (cardNumber != null) ? cardNumber.replaceAll("\\D", "") : "";
                if (cardClean.length() != 16) {
                    resp.sendRedirect(req.getContextPath() + "/student/enroll?courseId=" + courseId + "&error=invalid_cardnumber");
                    return;
                }

                String cvvClean = (cvv != null) ? cvv.replaceAll("\\D", "") : "";
                if (cvvClean.length() != 3 && cvvClean.length() != 4) {
                    resp.sendRedirect(req.getContextPath() + "/student/enroll?courseId=" + courseId + "&error=invalid_cvv");
                    return;
                }

                int month = 0;
                try {
                    month = Integer.parseInt(expiryMonth);
                } catch (Exception ex) {}
                if (month < 1 || month > 12) {
                    resp.sendRedirect(req.getContextPath() + "/student/enroll?courseId=" + courseId + "&error=invalid_month");
                    return;
                }

                int year = 0;
                try {
                    year = Integer.parseInt(expiryYear);
                    if (year < 100) year += 2000;
                } catch (Exception ex) {}
                if (year < 2026) {
                    resp.sendRedirect(req.getContextPath() + "/student/enroll?courseId=" + courseId + "&error=invalid_year");
                    return;
                }

                // Look up the course to record the price actually paid
                Course course = courseService.findById(courseId);
                BigDecimal price = (course != null && course.getPrice() != null)
                        ? course.getPrice() : BigDecimal.ZERO;

                Enrollment e = new Enrollment();
                e.setStudentId(student.getStudentId());
                e.setCourseId(courseId);
                e.setPaymentStatus("paid");
                e.setAmountPaid(price);
                e.setStatus("active");
                e.setNotes("Online payment - Card ending " + safeLast4(cardClean));
                enrollmentService.create(e);

                // Send dynamic course booking/payment notifications
                com.drivingschool.service.NotificationService ns = new com.drivingschool.service.NotificationService();
                
                // Student gets: "you booked a course"
                ns.notify(
                    userId,
                    "Course Booked Successfully",
                    "you booked a course! Course Name: " + (course != null ? course.getCourseName() : "Course") + ".",
                    "/student/dashboard",
                    "success"
                );

                // Admin gets notified of payment & course registration
                ns.notifyAllAdmins(
                    "New Course Enrollment Paid",
                    student.getFullName() + " has successfully booked the course: " + (course != null ? course.getCourseName() : "Course") + ".",
                    "/admin/enrollments/list",
                    "info"
                );

                // Retrieve newly created enrollment record (the latest one) to get its generated ID
                List<Enrollment> enrolledList = enrollmentService.listByStudent(student.getStudentId());
                if (enrolledList != null && !enrolledList.isEmpty()) {
                    Enrollment newEn = enrolledList.get(0);
                    resp.sendRedirect(req.getContextPath() + "/student/invoice?id=" + newEn.getEnrollmentId());
                } else {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard?msg=enrolled");
                }
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private String safeLast4(String cardNumber)
    {
        if (cardNumber == null) return "----";
        String digits = cardNumber.replaceAll("\\D", "");
        if (digits.length() < 4) return "----";
        return digits.substring(digits.length() - 4);
    }

    private Enrollment buildEnrollment(HttpServletRequest req) {
        Enrollment e = new Enrollment();
        String sid = req.getParameter("studentId");
        if (sid != null && !sid.isEmpty()) e.setStudentId(Integer.parseInt(sid));
        e.setCourseId(Integer.parseInt(req.getParameter("courseId")));
        e.setPaymentStatus(req.getParameter("paymentStatus"));
        String amt = req.getParameter("amountPaid");
        e.setAmountPaid(amt != null && !amt.isEmpty() ? new BigDecimal(amt) : BigDecimal.ZERO);
        e.setStatus(req.getParameter("status"));
        e.setNotes(req.getParameter("notes"));
        return e;
    }

    private void requireAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
    }
}
