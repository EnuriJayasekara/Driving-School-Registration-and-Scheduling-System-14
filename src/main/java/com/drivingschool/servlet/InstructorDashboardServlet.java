package com.drivingschool.servlet;

import com.drivingschool.model.Instructor;
import com.drivingschool.model.Schedule;
import com.drivingschool.service.InstructorService;
import com.drivingschool.service.ScheduleService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/instructor/dashboard")
public class InstructorDashboardServlet extends HttpServlet {

    private final InstructorService instructorService = new InstructorService();
    private final ScheduleService scheduleService = new ScheduleService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"instructor".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String view = req.getParameter("view");
        if (view == null || view.isEmpty()) {
            view = "profile";
        }

        try {
            Instructor instructor = instructorService.findByUserId(userId);
            if (instructor == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }
            req.setAttribute("instructor", instructor);

            if ("profile".equals(view)) {
                // Extract unique assigned students and vehicles using the robust DB queries
                List<com.drivingschool.model.Student> studentsList = instructorService.getAssignedStudents(instructor.getInstructorId());
                req.setAttribute("assignedStudents", studentsList);

                List<Schedule> mySchedules = scheduleService.listByInstructor(instructor.getInstructorId());
                java.util.Set<String> assignedVehicles = new java.util.HashSet<>();
                for (Schedule s : mySchedules) {
                    if (s.getVehicleInfo() != null) assignedVehicles.add(s.getVehicleInfo());
                }
                req.setAttribute("assignedVehicles", assignedVehicles);
                req.setAttribute("instructorSchedules", mySchedules);

            } else if ("lessons".equals(view) || "edit-lesson".equals(view)) {
                List<Schedule> mySchedules = scheduleService.listByInstructor(instructor.getInstructorId());

                long upcoming = mySchedules.stream()
                        .filter(s -> "scheduled".equals(s.getStatus())).count();
                long completed = mySchedules.stream()
                        .filter(s -> "completed".equals(s.getStatus())).count();

                req.setAttribute("upcomingCount", upcoming);
                req.setAttribute("completedCount", completed);
                req.setAttribute("totalCount", mySchedules.size());

                String filter = req.getParameter("filter");
                if (filter == null || filter.isEmpty()) {
                    filter = "all";
                }
                req.setAttribute("activeFilter", filter);

                List<Schedule> filteredSchedules;
                if ("upcoming".equals(filter)) {
                    filteredSchedules = mySchedules.stream()
                            .filter(s -> "scheduled".equals(s.getStatus()))
                            .collect(java.util.stream.Collectors.toList());
                } else if ("completed".equals(filter)) {
                    filteredSchedules = mySchedules.stream()
                            .filter(s -> "completed".equals(s.getStatus()))
                            .collect(java.util.stream.Collectors.toList());
                } else {
                    filteredSchedules = mySchedules;
                }
                req.setAttribute("schedules", filteredSchedules);

                // Load enrollments and vehicles for scheduling CRUD
                com.drivingschool.service.EnrollmentService enrollmentService = new com.drivingschool.service.EnrollmentService();
                com.drivingschool.service.VehicleService vehicleService = new com.drivingschool.service.VehicleService();
                req.setAttribute("allEnrollments", enrollmentService.listAll());
                req.setAttribute("allVehicles", vehicleService.listAll());

                // Handle loading a schedule to edit
                String editScheduleIdStr = req.getParameter("editScheduleId");
                if (editScheduleIdStr != null && !editScheduleIdStr.isEmpty()) {
                    int editScheduleId = Integer.parseInt(editScheduleIdStr);
                    Schedule editSchedule = scheduleService.findById(editScheduleId);
                    if (editSchedule != null && editSchedule.getInstructorId() == instructor.getInstructorId()) {
                        req.setAttribute("editSchedule", editSchedule);
                    }
                }

            } else if ("progress".equals(view)) {
                // Handle viewing specific student progress
                String studentIdStr = req.getParameter("studentId");
                if (studentIdStr != null && !studentIdStr.isEmpty()) {
                    int selectedStudentId = Integer.parseInt(studentIdStr);
                    List<InstructorService.StudentProgress> progressList = instructorService.getProgressByStudent(selectedStudentId);
                    req.setAttribute("selectedStudentId", selectedStudentId);
                    req.setAttribute("studentProgressList", progressList);
                    
                    // Fetch student name to show
                    com.drivingschool.service.StudentService studentService = new com.drivingschool.service.StudentService();
                    com.drivingschool.model.Student selStudent = studentService.findById(selectedStudentId);
                    req.setAttribute("selectedStudent", selStudent);

                    // Fetch student's full schedules (lessons)
                    List<Schedule> studentSchedules = scheduleService.listByStudent(selectedStudentId);
                    List<Schedule> studentCompleted = new java.util.ArrayList<>();
                    List<Schedule> studentUpcoming = new java.util.ArrayList<>();
                    for (Schedule s : studentSchedules) {
                        if ("completed".equalsIgnoreCase(s.getStatus())) {
                            studentCompleted.add(s);
                        } else if ("scheduled".equalsIgnoreCase(s.getStatus())) {
                            studentUpcoming.add(s);
                        }
                    }
                    req.setAttribute("studentCompletedLessons", studentCompleted);
                    req.setAttribute("studentUpcomingLessons", studentUpcoming);

                    // Calculate stats for the graphs
                    long excellent = progressList.stream().filter(p -> "Excellent".equalsIgnoreCase(p.getAchievement())).count();
                    long satisfactory = progressList.stream().filter(p -> "Satisfactory".equalsIgnoreCase(p.getAchievement())).count();
                    long needsImp = progressList.stream().filter(p -> "Needs Improvement".equalsIgnoreCase(p.getAchievement())).count();
                    
                    req.setAttribute("excellentCount", excellent);
                    req.setAttribute("satisfactoryCount", satisfactory);
                    req.setAttribute("needsImprovementCount", needsImp);
                    req.setAttribute("totalTopicsCount", progressList.size());
                }

                // Handle loading an entry to edit
                String editProgressIdStr = req.getParameter("editProgressId");
                if (editProgressIdStr != null && !editProgressIdStr.isEmpty()) {
                    int editProgressId = Integer.parseInt(editProgressIdStr);
                    InstructorService.StudentProgress editProgress = instructorService.findProgressById(editProgressId);
                    req.setAttribute("editProgress", editProgress);
                }
            } else if ("vehicle".equals(view)) {
                String vehicleIdStr = req.getParameter("vehicleId");
                if (vehicleIdStr != null && !vehicleIdStr.isEmpty()) {
                    int vehicleId = Integer.parseInt(vehicleIdStr);
                    com.drivingschool.service.VehicleService vehicleService = new com.drivingschool.service.VehicleService();
                    com.drivingschool.model.Vehicle selectedVehicle = vehicleService.findById(vehicleId);
                    req.setAttribute("selectedVehicle", selectedVehicle);

                    List<Schedule> vehicleSchedules = scheduleService.listByVehicle(vehicleId);
                    req.setAttribute("vehicleSchedules", vehicleSchedules);
                }
            }

        } catch (Exception e) {
            req.setAttribute("error", "Could not load dashboard: " + e.getMessage());
        }

        req.getRequestDispatcher("/WEB-INF/views/instructor/dashboard.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null
                || !"instructor".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        int userId = (int) session.getAttribute("userId");

        try {
            Instructor instructor = instructorService.findByUserId(userId);
            if (instructor == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if ("createProgress".equals(action)) {
                int studentId = Integer.parseInt(req.getParameter("studentId"));
                String topic = req.getParameter("topic");
                String achievement = req.getParameter("achievement");
                String comments = req.getParameter("comments");

                InstructorService.StudentProgress p = new InstructorService.StudentProgress();
                p.setStudentId(studentId);
                p.setInstructorId(instructor.getInstructorId());
                p.setTopic(topic);
                p.setAchievement(achievement);
                p.setComments(comments);

                instructorService.createProgress(p);
                resp.sendRedirect(req.getContextPath() + "/instructor/dashboard?view=progress&studentId=" + studentId + "&msg=progress_created");
                return;

            } else if ("updateProgress".equals(action)) {
                int progressId = Integer.parseInt(req.getParameter("progressId"));
                int studentId = Integer.parseInt(req.getParameter("studentId"));
                String topic = req.getParameter("topic");
                String achievement = req.getParameter("achievement");
                String comments = req.getParameter("comments");

                InstructorService.StudentProgress p = new InstructorService.StudentProgress();
                p.setProgressId(progressId);
                p.setTopic(topic);
                p.setAchievement(achievement);
                p.setComments(comments);

                instructorService.updateProgress(p);
                resp.sendRedirect(req.getContextPath() + "/instructor/dashboard?view=progress&studentId=" + studentId + "&msg=progress_updated");
                return;

            } else if ("deleteProgress".equals(action)) {
                int progressId = Integer.parseInt(req.getParameter("progressId"));
                int studentId = Integer.parseInt(req.getParameter("studentId"));

                instructorService.deleteProgress(progressId);
                resp.sendRedirect(req.getContextPath() + "/instructor/dashboard?view=progress&studentId=" + studentId + "&msg=progress_deleted");
                return;

            } else if ("createSchedule".equals(action)) {
                Schedule s = new Schedule();
                s.setEnrollmentId(Integer.parseInt(req.getParameter("enrollmentId")));
                s.setInstructorId(instructor.getInstructorId());
                s.setVehicleId(Integer.parseInt(req.getParameter("vehicleId")));
                s.setLessonDate(java.time.LocalDate.parse(req.getParameter("lessonDate")));
                s.setTimeSlot(req.getParameter("timeSlot"));
                String dur = req.getParameter("durationMinutes");
                s.setDurationMinutes(dur != null && !dur.isEmpty() ? Integer.parseInt(dur) : 60);
                s.setLessonType(req.getParameter("lessonType"));
                s.setStatus("scheduled");
                s.setNotes(req.getParameter("notes"));

                scheduleService.create(s);
                resp.sendRedirect(req.getContextPath() + "/instructor/dashboard?view=lessons&msg=schedule_created");
                return;

            } else if ("updateSchedule".equals(action)) {
                int scheduleId = Integer.parseInt(req.getParameter("scheduleId"));
                Schedule s = scheduleService.findById(scheduleId);
                if (s != null && s.getInstructorId() == instructor.getInstructorId()) {
                    s.setEnrollmentId(Integer.parseInt(req.getParameter("enrollmentId")));
                    s.setVehicleId(Integer.parseInt(req.getParameter("vehicleId")));
                    s.setLessonDate(java.time.LocalDate.parse(req.getParameter("lessonDate")));
                    s.setTimeSlot(req.getParameter("timeSlot"));
                    String dur = req.getParameter("durationMinutes");
                    s.setDurationMinutes(dur != null && !dur.isEmpty() ? Integer.parseInt(dur) : 60);
                    s.setLessonType(req.getParameter("lessonType"));
                    s.setStatus(req.getParameter("status"));
                    s.setNotes(req.getParameter("notes"));

                    scheduleService.update(s);
                }
                resp.sendRedirect(req.getContextPath() + "/instructor/dashboard?view=lessons&msg=schedule_updated");
                return;

            } else if ("deleteSchedule".equals(action)) {
                int scheduleId = Integer.parseInt(req.getParameter("scheduleId"));
                Schedule s = scheduleService.findById(scheduleId);
                if (s != null && s.getInstructorId() == instructor.getInstructorId()) {
                    scheduleService.delete(scheduleId);
                }
                resp.sendRedirect(req.getContextPath() + "/instructor/dashboard?view=lessons&msg=schedule_deleted");
                return;
            }

        } catch (Exception e) {
            req.setAttribute("error", "Error managing progress: " + e.getMessage());
        }

        doGet(req, resp);
    }
}
