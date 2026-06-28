package com.drivingschool.servlet;

import com.drivingschool.model.*;
import com.drivingschool.service.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/admin/schedules/*")
public class ScheduleServlet extends HttpServlet {

    private final ScheduleService    scheduleService    = new ScheduleService();
    private final InstructorService  instructorService  = new InstructorService();
    private final VehicleService     vehicleService     = new VehicleService();
    private final EnrollmentService  enrollmentService  = new EnrollmentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        requireAdmin(req, resp);
        String info = req.getPathInfo();

        try {
            if (info == null || "/list".equals(info)) {
                List<Schedule> schedules = scheduleService.listAll();
                req.setAttribute("schedules", schedules);
                forward(req, resp, "/WEB-INF/views/schedule/list.jsp");

            } else if ("/new".equals(info)) {
                req.setAttribute("instructors", instructorService.listActive());
                req.setAttribute("vehicles",    vehicleService.listAvailable());
                req.setAttribute("enrollments", enrollmentService.listAll());
                forward(req, resp, "/WEB-INF/views/schedule/form.jsp");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Schedule schedule = scheduleService.findById(id);
                req.setAttribute("schedule",    schedule);
                req.setAttribute("instructors", instructorService.listActive());
                req.setAttribute("vehicles",    vehicleService.listAll());
                req.setAttribute("enrollments", enrollmentService.listAll());
                forward(req, resp, "/WEB-INF/views/schedule/form.jsp");

            } else if ("/approve-reschedule".equals(info)) {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Schedule schedule = scheduleService.findById(id);
                    if (schedule != null && schedule.getNotes() != null && schedule.getNotes().contains("RESCHEDULE_REQUESTED")) {
                        String notes = schedule.getNotes();
                        int startIdx = notes.indexOf("(");
                        int endIdx = notes.indexOf(")");
                        if (startIdx != -1 && endIdx != -1) {
                            String dateTimePart = notes.substring(startIdx + 1, endIdx).trim();
                            int spaceIdx = dateTimePart.indexOf(" ");
                            if (spaceIdx != -1) {
                                String newDate = dateTimePart.substring(0, spaceIdx).trim();
                                String newTime = dateTimePart.substring(spaceIdx + 1).trim();
                                schedule.setLessonDate(LocalDate.parse(newDate));
                                schedule.setTimeSlot(newTime);
                            } else {
                                schedule.setLessonDate(LocalDate.parse(dateTimePart));
                            }
                        }
                        
                        int lastColon = notes.indexOf("):");
                        if (lastColon != -1) {
                            schedule.setNotes(notes.substring(lastColon + 2).trim());
                        } else {
                            schedule.setNotes("");
                        }
                        
                        schedule.setStatus("scheduled");
                        scheduleService.update(schedule);

                        com.drivingschool.model.Enrollment e = enrollmentService.findById(schedule.getEnrollmentId());
                        if (e != null) {
                            com.drivingschool.service.StudentService ss = new com.drivingschool.service.StudentService();
                            com.drivingschool.model.Student st = ss.findById(e.getStudentId());
                            if (st != null) {
                                com.drivingschool.service.NotificationService ns = new com.drivingschool.service.NotificationService();
                                ns.notify(st.getUserId(), 
                                    "Reschedule Confirmed", 
                                    "Your requested lesson reschedule has been confirmed for " + schedule.getLessonDate() + " at " + schedule.getTimeSlot(), 
                                    "/student/dashboard", 
                                    "success");
                            }
                        }
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin/schedules/list?msg=rescheduled");
                } catch (Exception ex) {
                    ex.printStackTrace();
                    resp.sendRedirect(req.getContextPath() + "/admin/schedules/list?error=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8"));
                }
                return;
            } else if ("/approve-booking".equals(info)) {
                try {
                    int id = Integer.parseInt(req.getParameter("id"));
                    Schedule schedule = scheduleService.findById(id);
                    if (schedule != null && schedule.getNotes() != null && schedule.getNotes().contains("PENDING_CONFIRMATION")) {
                        schedule.setNotes(schedule.getNotes().replace("PENDING_CONFIRMATION:", "").trim());
                        schedule.setStatus("scheduled");
                        scheduleService.update(schedule);
                        
                        com.drivingschool.model.Enrollment e = enrollmentService.findById(schedule.getEnrollmentId());
                        if (e != null) {
                            com.drivingschool.service.StudentService ss = new com.drivingschool.service.StudentService();
                            com.drivingschool.model.Student st = ss.findById(e.getStudentId());
                            if (st != null) {
                                com.drivingschool.service.NotificationService ns = new com.drivingschool.service.NotificationService();
                                ns.notify(st.getUserId(), 
                                    "Lesson Confirmed", 
                                    "Your lesson booking on " + schedule.getLessonDate() + " at " + schedule.getTimeSlot() + " has been confirmed.", 
                                    "/student/dashboard", 
                                    "success");
                            }
                        }
                    }
                    resp.sendRedirect(req.getContextPath() + "/admin/schedules/list?msg=confirmed");
                } catch (Exception ex) {
                    ex.printStackTrace();
                    resp.sendRedirect(req.getContextPath() + "/admin/schedules/list?error=" + java.net.URLEncoder.encode(ex.getMessage(), "UTF-8"));
                }
                return;

            } else if ("/delete".equals(info)) {
                int id = Integer.parseInt(req.getParameter("id"));
                scheduleService.delete(id);
                resp.sendRedirect(req.getContextPath() + "/admin/schedules/list?msg=deleted");
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
                Schedule schedule = buildSchedule(req);
                scheduleService.create(schedule);
                resp.sendRedirect(req.getContextPath() + "/admin/schedules/list?msg=created");

            } else if ("/edit".equals(info)) {
                int id = Integer.parseInt(req.getParameter("scheduleId"));
                Schedule oldSchedule = scheduleService.findById(id);
                Schedule schedule = buildSchedule(req);
                schedule.setScheduleId(id);
                
                // Clear the reschedule requested flag if present
                if (schedule.getNotes() != null && schedule.getNotes().contains("RESCHEDULE_REQUESTED:")) {
                    schedule.setNotes(schedule.getNotes().replace("RESCHEDULE_REQUESTED:", "").trim());
                }

                scheduleService.update(schedule);
                
                // Notify student if it was a reschedule request
                if (oldSchedule != null && oldSchedule.getNotes() != null && oldSchedule.getNotes().contains("RESCHEDULE_REQUESTED:")) {
                    com.drivingschool.model.Enrollment e = enrollmentService.findById(schedule.getEnrollmentId());
                    if (e != null) {
                        com.drivingschool.service.StudentService ss = new com.drivingschool.service.StudentService();
                        com.drivingschool.model.Student st = ss.findById(e.getStudentId());
                        if (st != null) {
                            com.drivingschool.service.NotificationService ns = new com.drivingschool.service.NotificationService();
                            ns.notify(st.getUserId(), 
                                "Reschedule Confirmed", 
                                "Your requested lesson reschedule has been confirmed for " + schedule.getLessonDate() + " at " + schedule.getTimeSlot(), 
                                "/student/dashboard", 
                                "success");
                        }
                    }
                }

                resp.sendRedirect(req.getContextPath() + "/admin/schedules/list?msg=updated");
            }

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private Schedule buildSchedule(HttpServletRequest req) {
        Schedule s = new Schedule();
        s.setEnrollmentId(Integer.parseInt(req.getParameter("enrollmentId")));
        s.setInstructorId(Integer.parseInt(req.getParameter("instructorId")));
        s.setVehicleId(Integer.parseInt(req.getParameter("vehicleId")));
        s.setLessonDate(LocalDate.parse(req.getParameter("lessonDate")));
        s.setTimeSlot(req.getParameter("timeSlot"));
        String dur = req.getParameter("durationMinutes");
        s.setDurationMinutes(dur != null && !dur.isEmpty() ? Integer.parseInt(dur) : 60);
        s.setLessonType(req.getParameter("lessonType"));
        s.setStatus(req.getParameter("status") != null ? req.getParameter("status") : "scheduled");
        s.setNotes(req.getParameter("notes"));
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
