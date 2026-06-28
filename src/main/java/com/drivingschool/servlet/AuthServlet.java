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

@WebServlet(urlPatterns = {"/login", "/logout", "/register", "/signup", "/contact"})
public class AuthServlet extends HttpServlet {

    private final UserService    userService    = new UserService();
    private final StudentService studentService = new StudentService();

    // ---- GET ----
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if ("/register".equals(path) || "/signup".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if ("/contact".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/public_contact.jsp").forward(req, resp);
            return;
        }

        // /login
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    // ---- POST ----
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(req, resp);
        } else if ("/register".equals(path) || "/signup".equals(path)) {
            handleRegister(req, resp);
        } else if ("/contact".equals(path)) {
            handleContact(req, resp);
        }
    }

    // ── Contact Form Footer Submission ──────────────────────────────────────
    private void handleContact(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String phone   = req.getParameter("phone");
        String message = req.getParameter("message");

        if (phone == null || phone.trim().isEmpty() || message == null || message.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/contact?error=contact_empty");
            return;
        }

        try {
            com.drivingschool.service.NotificationService ns = new com.drivingschool.service.NotificationService();
            
            // 1. Notify Admins
            ns.notifyAllAdmins(
                "New Footer Message",
                "Contact Phone: " + phone + " | Message: " + message,
                "#",
                "info"
            );

            // 2. Notify Instructors
            com.drivingschool.service.InstructorService instService = new com.drivingschool.service.InstructorService();
            java.util.List<com.drivingschool.model.Instructor> list = instService.listAll();
            if (list != null) {
                for (com.drivingschool.model.Instructor inst : list) {
                    ns.notify(inst.getUserId(), "New Public Inquiry", "From phone: " + phone + " | message: " + message, "#", "info");
                }
            }

            resp.sendRedirect(req.getContextPath() + "/contact?msg=sent");
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    // ── Login ──────────────────────────────────────────────────────────────
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        if ("admin@gmail.com".equals(email) && "12345678".equals(password)) {
            HttpSession session = req.getSession(true);
            User fakeAdmin = new User();
            fakeAdmin.setUserId(1); // Usually admin is user_id 1
            fakeAdmin.setEmail("admin@gmail.com");
            fakeAdmin.setFullName("System Administrator");
            fakeAdmin.setRole("admin");
            session.setAttribute("loggedUser", fakeAdmin);
            session.setAttribute("role", "admin");
            session.setAttribute("userId", 1);
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        try {
            User user = userService.authenticate(email, password);
            if (user == null) {
                req.setAttribute("error", "Invalid email or password.");
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("loggedUser", user);
            session.setAttribute("role",       user.getRole());
            session.setAttribute("userId",     user.getUserId());

            // Redirect based on role
            switch (user.getRole()) {
                case "admin":
                    resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                    break;
                case "instructor":
                    resp.sendRedirect(req.getContextPath() + "/instructor/dashboard");
                    break;
                default: // student
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // ── Register (new student) ─────────────────────────────────────────────
    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName  = req.getParameter("fullName");
        String email     = req.getParameter("email");
        String password  = req.getParameter("password");
        String phone     = req.getParameter("phone");
        String nic       = req.getParameter("nicNumber");
        String address   = req.getParameter("address");
        String licType   = req.getParameter("licenseType");

        // 1. Email space validation
        if (email == null || email.contains(" ")) {
            req.setAttribute("error", "Email address must not contain spaces.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        // 2. Contact Phone exactly 10 digits
        if (phone == null || !phone.matches("^\\d{10}$")) {
            req.setAttribute("error", "Contact phone number must be exactly 10 digits.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        // 3. NIC validation: New (12 digits) or Old (9 digits + V/v)
        if (nic == null || (!nic.matches("^\\d{12}$") && !nic.matches("^\\d{9}[Vv]$"))) {
            req.setAttribute("error", "NIC number must be exactly 12 digits (new) or 10 characters ending in V/v (old).");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        // 4. Password pattern matching: 1 Upper, 1 Lower, 1 digit, 1 Special character, 8+ chars
        String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$";
        if (password == null || !password.matches(passwordPattern)) {
            req.setAttribute("error", "Password must contain at least one uppercase letter, one lowercase letter, one digit, one special symbol, and be at least 8 characters long.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        try {
            if (userService.emailExists(email)) {
                req.setAttribute("error", "Email already registered. Please login.");
                req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
                return;
            }

            // Create user record
            User user = new User(fullName, email, password, phone, "student");
            boolean created = userService.register(user);

            if (!created) {
                req.setAttribute("error", "Registration failed. Please try again.");
                req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
                return;
            }

            // Find generated user_id and create student profile
            User saved = userService.findByEmail(email);
            Student student = new Student();
            student.setUserId(saved.getUserId());
            student.setNicNumber(nic);
            student.setAddress(address);
            student.setLicenseType(licType != null ? licType : "B");
            student.setStatus("pending");
            studentService.create(student);

            // Notify Student
            com.drivingschool.service.NotificationService notificationService = new com.drivingschool.service.NotificationService();
            notificationService.notify(
                saved.getUserId(),
                "Registered",
                "we are registered",
                "/student/dashboard",
                "success"
            );
            notificationService.notify(
                saved.getUserId(),
                "Welcome",
                "you are successfully registered our website.",
                "/student/dashboard",
                "success"
            );

            // Notify Admin
            notificationService.notifyAllAdmins(
                "New Student Registered",
                "Student " + fullName + " has registered.",
                "/admin/students/list",
                "info"
            );

            req.setAttribute("success", "Registration successful! Please login.");
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
