package com.drivingschool.servlet;

import com.drivingschool.model.Student;
import com.drivingschool.model.User;
import com.drivingschool.service.StudentService;
import com.drivingschool.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/students/*")
public class StudentServlet extends HttpServlet {

    private final StudentService studentService = new StudentService();
    private final UserService    userService    = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        requireAdmin(req, resp);
        String info = req.getPathInfo();   // /list | /new | /edit | /delete

        try {
            if (info == null || "/list".equals(info)) {
                List<Student> students = studentService.listAll();
                req.setAttribute("students", students);
                forward(req, resp, "/WEB-INF/views/student/list.jsp");

            } else if ("/new".equals(info)) {
                forward(req, resp, "/WEB-INF/views/student/form.jsp");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Student student = studentService.findById(id);
                req.setAttribute("student", student);
                forward(req, resp, "/WEB-INF/views/student/form.jsp");

            } else if ("/delete".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                studentService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/students/list?msg=deleted");
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

        String email    = req.getParameter("email");
        String fullName = req.getParameter("fullName");
        String phone    = req.getParameter("phone");
        String password = req.getParameter("password");
        String nic      = req.getParameter("nicNumber");

        // Validations
        if (email != null && email.contains(" ")) {
            req.setAttribute("error", "Email address must not contain spaces.");
            forward(req, resp, "/WEB-INF/views/student/form.jsp");
            return;
        }
        if (phone != null && !phone.matches("^\\d{10}$")) {
            req.setAttribute("error", "Contact phone number must be exactly 10 digits.");
            forward(req, resp, "/WEB-INF/views/student/form.jsp");
            return;
        }
        if (nic != null && (!nic.matches("^\\d{12}$") && !nic.matches("^\\d{9}[Vv]$"))) {
            req.setAttribute("error", "NIC must be exactly 12 digits (new) or 10 characters ending in V/v (old).");
            forward(req, resp, "/WEB-INF/views/student/form.jsp");
            return;
        }
        if ("/new".equals(info) && password != null) {
            String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$";
            if (!password.matches(passwordPattern)) {
                req.setAttribute("error", "Password must contain at least one uppercase letter, one lowercase letter, one digit, one special symbol, and be at least 8 characters long.");
                forward(req, resp, "/WEB-INF/views/student/form.jsp");
                return;
            }
        }

        try {
            if ("/new".equals(info)) {
                if (userService.emailExists(email)) {
                    req.setAttribute("error", "Email already exists.");
                    forward(req, resp, "/WEB-INF/views/student/form.jsp");
                    return;
                }

                User user = new User(fullName, email, password, phone, "student");
                userService.register(user);
                User saved = userService.findByEmail(email);

                Student student = buildStudent(req, saved.getUserId());
                studentService.create(student);
                resp.sendRedirect(req.getContextPath() + "/admin/students/list?msg=created");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("studentId"));
                Student student = buildStudent(req, 0);
                student.setStudentId(id);
                studentService.update(student);

                // also update name / phone in users table
                Student existing = studentService.findById(id);
                User user = userService.findById(existing.getUserId());
                user.setFullName(req.getParameter("fullName"));
                user.setPhone(req.getParameter("phone"));
                userService.update(user);

                resp.sendRedirect(req.getContextPath() + "/admin/students/list?msg=updated");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private Student buildStudent(HttpServletRequest req, int userId) {
        Student s = new Student();
        s.setUserId(userId);
        s.setStudentRegNo(req.getParameter("studentRegNo"));
        s.setNicNumber(req.getParameter("nicNumber"));
        String dob = req.getParameter("dob");
        if (dob != null && !dob.isEmpty()) s.setDob(LocalDate.parse(dob));
        s.setAddress(req.getParameter("address"));
        s.setLicenseType(req.getParameter("licenseType"));
        s.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "pending");
        String td = req.getParameter("trialDate");
        if (td != null && !td.isEmpty()) s.setTrialDate(LocalDate.parse(td));
        return s;
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
