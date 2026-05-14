package com.drivingschool.servlet;

import com.drivingschool.model.LessonSlot;
import com.drivingschool.model.Vehicle;
import com.drivingschool.service.CourseService;
import com.drivingschool.service.InstructorService;
import com.drivingschool.service.LessonSlotService;
import com.drivingschool.service.VehicleService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;

@WebServlet("/admin/slots/*")
public class LessonSlotServlet extends HttpServlet {

    private final LessonSlotService slotService       = new LessonSlotService();
    private final InstructorService instructorService = new InstructorService();
    private final VehicleService    vehicleService    = new VehicleService();
    private final CourseService     courseService     = new CourseService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String info = req.getPathInfo();
        if (info == null) info = "/list";

        try {
            switch (info) {
                case "/list":
                    req.setAttribute("slots", slotService.listAll());
                    req.getRequestDispatcher("/WEB-INF/views/slot/list.jsp").forward(req, resp);
                    break;
                case "/new":
                    req.setAttribute("courses",     courseService.listActive());
                    req.setAttribute("instructors", instructorService.listActive());
                    req.setAttribute("vehicles",    vehicleService.listAll());
                    req.getRequestDispatcher("/WEB-INF/views/slot/form.jsp").forward(req, resp);
                    break;
                case "/cancel":
                    slotService.cancel(Integer.parseInt(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/admin/slots/list?msg=cancelled");
                    break;
                case "/delete":
                    slotService.delete(Integer.parseInt(req.getParameter("id")));
                    resp.sendRedirect(req.getContextPath() + "/admin/slots/list?msg=deleted");
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/admin/slots/list");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isAdmin(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        req.setCharacterEncoding("UTF-8");
        String info = req.getPathInfo();

        try {
            if ("/new".equals(info)) {
                int vehicleId = Integer.parseInt(req.getParameter("vehicleId"));

                // Auto-derive capacity from vehicle (seats - 1 for instructor)
                Vehicle veh = vehicleService.findById(vehicleId);
                if (veh == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/slots/new?error=badvehicle");
                    return;
                }
                int capacity = veh.getStudentCapacity();

                LessonSlot s = new LessonSlot();
                s.setCourseId(Integer.parseInt(req.getParameter("courseId")));
                s.setInstructorId(Integer.parseInt(req.getParameter("instructorId")));
                s.setVehicleId(vehicleId);
                s.setLessonDate(LocalDate.parse(req.getParameter("lessonDate")));
                s.setTimeSlot(req.getParameter("timeSlot"));
                s.setDurationMinutes(Integer.parseInt(req.getParameter("durationMinutes")));
                s.setLessonType(req.getParameter("lessonType"));
                s.setCapacity(capacity);
                s.setNotes(req.getParameter("notes"));
                s.setStatus("open");

                slotService.create(s);
                resp.sendRedirect(req.getContextPath() + "/admin/slots/list?msg=created");
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/admin/slots/list");

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "admin".equals(s.getAttribute("role"));
    }
}