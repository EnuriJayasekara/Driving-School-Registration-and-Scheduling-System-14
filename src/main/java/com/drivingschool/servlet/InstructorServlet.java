package com.drivingschool.servlet;

import com.drivingschool.model.Instructor;
import com.drivingschool.model.User;
import com.drivingschool.service.InstructorService;
import com.drivingschool.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/instructors/*")
public class InstructorServlet extends HttpServlet {

    private final InstructorService instructorService = new InstructorService();
    private final UserService       userService       = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        requireAdmin(req, resp);
        String info = req.getPathInfo();

        try {
            if (info == null || "/list".equals(info)) {
                List<Instructor> instructors = instructorService.listAll();
                req.setAttribute("instructors", instructors);
                forward(req, resp, "/WEB-INF/views/instructor/list.jsp");

            } else if ("/new".equals(info)) {
                forward(req, resp, "/WEB-INF/views/instructor/form.jsp");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Instructor instructor = instructorService.findById(id);
                req.setAttribute("instructor", instructor);
                forward(req, resp, "/WEB-INF/views/instructor/form.jsp");

            } else if ("/delete".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                instructorService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/instructors/list?msg=deleted");
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
        String phone    = req.getParameter("phone");
        String exp      = req.getParameter("experienceYears");
        int expYears    = (exp != null && !exp.isEmpty()) ? Integer.parseInt(exp) : 0;

        // Shared Validations
        if (email != null && email.contains(" ")) {
            req.setAttribute("error", "Email address must not contain spaces.");
            if ("/edit".equals(info)) {
                try {
                    int id = Integer.parseInt(req.getParameter("instructorId"));
                    req.setAttribute("instructor", instructorService.findById(id));
                } catch (Exception e) {}
            }
            forward(req, resp, "/WEB-INF/views/instructor/form.jsp");
            return;
        }
        if (phone != null && !phone.matches("^\\d{10}$")) {
            req.setAttribute("error", "Contact phone number must be exactly 10 digits.");
            if ("/edit".equals(info)) {
                try {
                    int id = Integer.parseInt(req.getParameter("instructorId"));
                    req.setAttribute("instructor", instructorService.findById(id));
                } catch (Exception e) {}
            }
            forward(req, resp, "/WEB-INF/views/instructor/form.jsp");
            return;
        }
        if (expYears < 0) {
            req.setAttribute("error", "Experience years cannot be a negative number.");
            if ("/edit".equals(info)) {
                try {
                    int id = Integer.parseInt(req.getParameter("instructorId"));
                    req.setAttribute("instructor", instructorService.findById(id));
                } catch (Exception e) {}
            }
            forward(req, resp, "/WEB-INF/views/instructor/form.jsp");
            return;
        }

        try {
            if ("/new".equals(info)) {
                String fullName = req.getParameter("fullName");
                String password = req.getParameter("password");

                // Password Validation Logic
                String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$";
                if (password == null || !password.matches(passwordPattern)) {
                    req.setAttribute("error", "Password must be at least 8 characters, with 1 uppercase, 1 lowercase, 1 digit, and 1 special character.");
                    forward(req, resp, "/WEB-INF/views/instructor/form.jsp");
                    return;
                }

                User user = new User(fullName, email, password, phone, "instructor");
                userService.register(user);
                User saved = userService.findByEmail(email);

                Instructor instructor = buildInstructor(req, saved.getUserId());
                instructor.setAssignedPassword(password);
                instructorService.create(instructor);
                resp.sendRedirect(req.getContextPath() + "/admin/instructors/list?msg=created");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("instructorId"));
                String newPassword = req.getParameter("newPassword");
                
                Instructor instructor = buildInstructor(req, 0);
                instructor.setInstructorId(id);
                
                // Password Validation Logic
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#])[A-Za-z\\d@$!%*?&#]{8,}$";
                    if (!newPassword.matches(passwordPattern)) {
                        req.setAttribute("error", "Password must be at least 8 characters, with 1 uppercase, 1 lowercase, 1 digit, and 1 special character.");
                        req.setAttribute("instructor", instructorService.findById(id));
                        forward(req, resp, "/WEB-INF/views/instructor/form.jsp");
                        return;
                    }
                    instructor.setAssignedPassword(newPassword);
                } else {
                    // Retain old assigned password if not changing
                    Instructor existing = instructorService.findById(id);
                    instructor.setAssignedPassword(existing.getAssignedPassword());
                }

                instructorService.update(instructor);

                // Update user table
                Instructor existing = instructorService.findById(id);
                User user = userService.findById(existing.getUserId());
                user.setFullName(req.getParameter("fullName"));
                user.setPhone(req.getParameter("phone"));
                
                if (newPassword != null && !newPassword.trim().isEmpty()) {
                    userService.updatePassword(user.getUserId(), newPassword);
                    // Automatically activate if assigning password
                    user.setActive(true);
                    instructor.setStatus("active");
                    instructorService.update(instructor);
                } else if (!user.isActive() && "active".equals(instructor.getStatus())) {
                    user.setActive(true);
                }
                
                userService.update(user);
                resp.sendRedirect(req.getContextPath() + "/admin/instructors/list?msg=updated");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private Instructor buildInstructor(HttpServletRequest req, int userId) {
        Instructor i = new Instructor();
        i.setUserId(userId);
        i.setInstructorRegNo(req.getParameter("instructorRegNo"));
        i.setLicenseNo(req.getParameter("licenseNo"));
        i.setSpecialization(req.getParameter("specialization"));
        String exp = req.getParameter("experienceYears");
        i.setExperienceYears(exp != null && !exp.isEmpty() ? Integer.parseInt(exp) : 0);
        i.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "active");
        return i;
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
