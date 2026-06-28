package com.drivingschool.servlet;

import com.drivingschool.model.*;
import com.drivingschool.service.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

/**
 * Student: see open slots for each of the courses they're enrolled in, book one.
 *
 * Routes:
 *   GET  /student/slots          -> list open slots grouped by enrolled course
 *   POST /student/slots/book     -> book slot (params: slotId, enrollmentId)
 */
@WebServlet(urlPatterns = {"/student/slots", "/student/slots/book", "/student/slots/request"})
public class StudentSlotServlet extends HttpServlet {

    private final StudentService      studentService      = new StudentService();
    private final EnrollmentService   enrollmentService   = new EnrollmentService();
    private final CourseService       courseService       = new CourseService();
    private final LessonSlotService   slotService         = new LessonSlotService();
    private final ScheduleService     scheduleService     = new ScheduleService();
    private final NotificationService notificationService = new NotificationService();
    private final UserService         userService         = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isStudent(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        try {
            int userId = (Integer) req.getSession().getAttribute("userId");
            Student student = studentService.findByUserId(userId);
            if (student == null) {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard");
                return;
            }

            // Pull active enrollments + the matching course info
            List<Enrollment> myEnrollments = enrollmentService.listByStudent(student.getStudentId());
            List<EnrolledCourseView> courseViews = new ArrayList<>();
            Set<Integer> alreadyBooked = new HashSet<>(
                    slotService.listBookedSlotIdsByStudent(student.getStudentId()));

            for (Enrollment en : myEnrollments) {
                if (!"active".equals(en.getStatus())) continue;
                Course course = courseService.findById(en.getCourseId());
                if (course == null) continue;

                List<LessonSlot> slots = slotService.listOpenForCourse(course.getCourseId());
                // Hide slots this student has already booked
                slots.removeIf(s -> alreadyBooked.contains(s.getSlotId()));

                courseViews.add(new EnrolledCourseView(
                        en.getEnrollmentId(), course.getCourseName(),
                        course.getLicenseCategory(), slots));
            }

            req.setAttribute("courseViews", courseViews);
            req.getRequestDispatcher("/WEB-INF/views/slot/student_slots.jsp").forward(req, resp);

        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isStudent(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }
        req.setCharacterEncoding("UTF-8");

        String path = req.getServletPath();
        if ("/student/slots/request".equals(path)) {
            handleCustomRequest(req, resp);
        } else {
            handleBookSlot(req, resp);
        }
    }

    private void handleCustomRequest(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int enrollmentId = Integer.parseInt(req.getParameter("enrollmentId"));
            String lessonDateStr = req.getParameter("lessonDate");
            String timeSlot = req.getParameter("timeSlot");
            String lessonType = req.getParameter("lessonType");
            int userId = (Integer) req.getSession().getAttribute("userId");

            Student student = studentService.findByUserId(userId);
            if (student == null) {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=nostudent");
                return;
            }

            Enrollment en = enrollmentService.findById(enrollmentId);
            if (en == null || en.getStudentId() != student.getStudentId()) {
                resp.sendRedirect(req.getContextPath() + "/student/slots?error=badrequest");
                return;
            }

            // Find an active instructor
            InstructorService instService = new InstructorService();
            List<Instructor> activeInstructors = instService.listActive();
            if (activeInstructors.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/slots?error=noinstructors");
                return;
            }
            int instructorId = activeInstructors.get(0).getInstructorId();

            // Find an available vehicle
            VehicleService vehicleService = new VehicleService();
            List<Vehicle> availableVehicles = vehicleService.listAvailable();
            if (availableVehicles.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/student/slots?error=novehicles");
                return;
            }
            int vehicleId = availableVehicles.get(0).getVehicleId();

            // Create schedule request in PENDING_CONFIRMATION state
            Schedule sch = new Schedule();
            sch.setEnrollmentId(enrollmentId);
            sch.setInstructorId(instructorId);
            sch.setVehicleId(vehicleId);
            sch.setLessonDate(java.time.LocalDate.parse(lessonDateStr));
            sch.setTimeSlot(timeSlot);
            sch.setDurationMinutes(60);
            sch.setLessonType(lessonType != null && !lessonType.isEmpty() ? lessonType : "practical");
            sch.setStatus("scheduled");
            sch.setNotes("PENDING_CONFIRMATION: Student requested custom lesson date & time.");

            int scheduleId = scheduleService.createReturnId(sch);
            if (scheduleId < 0) {
                resp.sendRedirect(req.getContextPath() + "/student/slots?error=failed");
                return;
            }

            User u = userService.findById(userId);
            String fullName = (u != null) ? u.getFullName() : "A student";

            // Notify the student
            notificationService.notify(
                    userId,
                    "Lesson request submitted!",
                    "Your custom lesson request for " + sch.getLessonDate() +
                            " at " + sch.getTimeSlot() + " has been submitted to the Admin for confirmation.",
                    "/student/dashboard",
                    "success"
            );

            // Notify all admins
            notificationService.notifyAllAdmins(
                    "New lesson confirmation requested",
                    fullName + " requested a new lesson on " + sch.getLessonDate() + " at " + sch.getTimeSlot() + ".",
                    "/admin/schedules/list",
                    "info"
            );

            resp.sendRedirect(req.getContextPath() + "/student/dashboard?msg=requested");

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/student/slots?error=badrequest");
        }
    }

    private void handleBookSlot(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int slotId       = Integer.parseInt(req.getParameter("slotId"));
            int enrollmentId = Integer.parseInt(req.getParameter("enrollmentId"));
            int userId       = (Integer) req.getSession().getAttribute("userId");

            Student student = studentService.findByUserId(userId);
            if (student == null) {
                resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=nostudent");
                return;
            }

            User u = userService.findById(userId);
            String fullName = (u != null) ? u.getFullName() : "A student";

            // Sanity check: the enrollment must belong to this student, and to the same course as the slot
            Enrollment en = enrollmentService.findById(enrollmentId);
            LessonSlot slot = slotService.findById(slotId);
            if (en == null || slot == null
                    || en.getStudentId() != student.getStudentId()
                    || en.getCourseId() != slot.getCourseId()) {
                resp.sendRedirect(req.getContextPath() + "/student/slots?error=badrequest");
                return;
            }

            // 1. Try to claim a seat (atomic, race-safe)
            boolean claimed = slotService.claimSeat(slotId);
            if (!claimed) {
                resp.sendRedirect(req.getContextPath() + "/student/slots?error=taken");
                return;
            }

            // 2. Create the confirmed schedule row for this student
            Schedule sch = new Schedule();
            sch.setEnrollmentId(enrollmentId);
            sch.setInstructorId(slot.getInstructorId());
            sch.setVehicleId(slot.getVehicleId());
            sch.setLessonDate(slot.getLessonDate());
            sch.setTimeSlot(slot.getTimeSlot());
            sch.setDurationMinutes(slot.getDurationMinutes());
            sch.setLessonType(slot.getLessonType());
            sch.setStatus("scheduled");
            sch.setNotes("PENDING_CONFIRMATION: Booked from slot #" + slotId);
            int scheduleId = scheduleService.createReturnId(sch);
            if (scheduleId < 0) {
                resp.sendRedirect(req.getContextPath() + "/student/slots?error=failed");
                return;
            }

            // 3. Audit record in slot_bookings (UNIQUE constraint guards against double-booking)
            try {
                slotService.recordBooking(slotId, student.getStudentId(), enrollmentId, scheduleId);
            } catch (SQLException dupe) {
                resp.sendRedirect(req.getContextPath() + "/student/slots?error=alreadybooked");
                return;
            }

            // 4. Notify the student
            notificationService.notify(
                    userId,
                    "Lesson booked!",
                    "Your slot booking request on " + slot.getLessonDate() +
                            " at " + slot.getTimeSlot() + " has been submitted to the Admin for confirmation.",
                    "/student/dashboard",
                    "success"
            );

            // 5. Notify the Instructor
            if (slot.getInstructorId() > 0) {
                try {
                    com.drivingschool.service.InstructorService instService = new com.drivingschool.service.InstructorService();
                    com.drivingschool.model.Instructor inst = instService.findById(slot.getInstructorId());
                    if (inst != null) {
                        notificationService.notify(
                            inst.getUserId(),
                            "New Lesson Booked",
                            fullName + " has booked a lesson with you on " + slot.getLessonDate() + " at " + slot.getTimeSlot() + " (Pending confirmation).",
                            "/instructor/dashboard",
                            "info"
                        );
                    }
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }

            // 6. Notify all admins
            notificationService.notifyAllAdmins(
                    "New slot booking",
                    fullName + " booked the " + slot.getCourseName() +
                            " slot on " + slot.getLessonDate() + " " + slot.getTimeSlot() + " (Pending confirmation).",
                    "/admin/slots/list",
                    "info"
            );

            resp.sendRedirect(req.getContextPath() + "/student/dashboard?msg=booked");

        } catch (NumberFormatException nfe) {
            resp.sendRedirect(req.getContextPath() + "/student/slots?error=badrequest");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private boolean isStudent(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "student".equals(s.getAttribute("role"));
    }

    // View holder for JSP
    public static class EnrolledCourseView {
        private final int enrollmentId;
        private final String courseName;
        private final String licenseCategory;
        private final List<LessonSlot> slots;
        public EnrolledCourseView(int eid, String cn, String lc, List<LessonSlot> slots) {
            this.enrollmentId = eid; this.courseName = cn;
            this.licenseCategory = lc; this.slots = slots;
        }
        public int getEnrollmentId()      { return enrollmentId; }
        public String getCourseName()     { return courseName; }
        public String getLicenseCategory(){ return licenseCategory; }
        public List<LessonSlot> getSlots(){ return slots; }
        public int getSlotsCount()        { return slots.size(); }
    }
}