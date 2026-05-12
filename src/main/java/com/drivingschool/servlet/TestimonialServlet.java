package com.drivingschool.servlet;

import com.drivingschool.model.Testimonial;
import com.drivingschool.service.TestimonialService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/testimonials")
public class TestimonialServlet extends HttpServlet {

    private final TestimonialService testimonialService = new TestimonialService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        try {
            List<Testimonial> list = testimonialService.listApproved();
            req.setAttribute("testimonials", list);
            req.getRequestDispatcher("/WEB-INF/views/public_testimonials.jsp").forward(req, resp);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name     = req.getParameter("studentName");
        String rateStr  = req.getParameter("rating");
        String message  = req.getParameter("message");
        String category = req.getParameter("licenseCategory");

        if (name == null || name.trim().isEmpty() || message == null || message.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/testimonials?error=empty");
            return;
        }

        int rating = 5;
        if (rateStr != null && !rateStr.isEmpty()) {
            try {
                rating = Integer.parseInt(rateStr);
            } catch (NumberFormatException e) {
                // Fallback to 5
            }
        }

        Testimonial t = new Testimonial();
        t.setStudentName(name);
        t.setRating(rating);
        t.setMessage(message);
        t.setLicenseCategory(category != null && !category.trim().isEmpty() ? category : "Student");

        try {
            testimonialService.create(t);
            resp.sendRedirect(req.getContextPath() + "/testimonials?msg=success");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
