package com.drivingschool.servlet;

import com.drivingschool.model.Course;
import com.drivingschool.service.CourseService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/courses/*")
public class CourseServlet extends HttpServlet {

    private final CourseService courseService = new CourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        requireAdmin(req, resp);
        String info = req.getPathInfo();

        try {
            if (info == null || "/list".equals(info)) {
                List<Course> courses = courseService.listAll();
                req.setAttribute("courses", courses);
                forward(req, resp, "/WEB-INF/views/course/list.jsp");

            } else if ("/new".equals(info)) {
                forward(req, resp, "/WEB-INF/views/course/form.jsp");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Course course = courseService.findById(id);
                req.setAttribute("course", course);
                forward(req, resp, "/WEB-INF/views/course/form.jsp");

            } else if ("/delete".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                courseService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/courses/list?msg=deleted");
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

        try {
            if ("/new".equals(info)) {
                Course course = buildCourse(req);
                courseService.create(course);
                resp.sendRedirect(req.getContextPath() + "/admin/courses/list?msg=created");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("courseId"));
                Course course = buildCourse(req);
                course.setCourseId(id);
                courseService.update(course);
                resp.sendRedirect(req.getContextPath() + "/admin/courses/list?msg=updated");
                
            } else if ("/delete".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                courseService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/courses/list?msg=deleted");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private Course buildCourse(HttpServletRequest req) {
        Course c = new Course();
        c.setCourseName(req.getParameter("courseName"));
        c.setLicenseCategory(req.getParameter("licenseCategory"));
        String hrs = req.getParameter("totalHours");
        c.setTotalHours(hrs != null && !hrs.isEmpty() ? Integer.parseInt(hrs) : 20);
        String price = req.getParameter("price");
        c.setPrice(price != null && !price.isEmpty() ? new BigDecimal(price) : BigDecimal.ZERO);
        c.setDescription(req.getParameter("description"));
        c.setActive("on".equals(req.getParameter("isActive")) || "true".equals(req.getParameter("isActive")));
        return c;
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
