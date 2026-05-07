package com.drivingschool.model;

import com.drivingschool.model.contract.Identifiable;

import java.time.LocalDate;
import java.time.LocalDateTime;

/** Maps to the `schedules` table. */
public class Schedule implements Identifiable {

    /** Identifiable contract: a schedule is identified by its schedule_id. */
    @Override
    public int getId() { return scheduleId; }


    private int           scheduleId;
    private int           enrollmentId;
    private int           instructorId;
    private int           vehicleId;
    private LocalDate     lessonDate;
    private String        timeSlot;
    private int           durationMinutes;
    private String        lessonType;
    private String        status;
    private String        notes;
    private LocalDateTime createdAt;

    // Joined fields
    private int studentId;
    private String studentName;
    private String instructorName;
    private String vehicleInfo;
    private String courseName;

    public Schedule() {}

    public int getStudentId()                            { return studentId; }
    public void setStudentId(int studentId)              { this.studentId = studentId; }

    // ---- Getters & Setters ----
    public int getScheduleId()                           { return scheduleId; }
    public void setScheduleId(int scheduleId)            { this.scheduleId = scheduleId; }

    public int getEnrollmentId()                         { return enrollmentId; }
    public void setEnrollmentId(int enrollmentId)        { this.enrollmentId = enrollmentId; }

    public int getInstructorId()                         { return instructorId; }
    public void setInstructorId(int instructorId)        { this.instructorId = instructorId; }

    public int getVehicleId()                            { return vehicleId; }
    public void setVehicleId(int vehicleId)              { this.vehicleId = vehicleId; }

    public LocalDate getLessonDate()                     { return lessonDate; }
    public void setLessonDate(LocalDate lessonDate)      { this.lessonDate = lessonDate; }

    public String getTimeSlot()                          { return timeSlot; }
    public void setTimeSlot(String timeSlot)             { this.timeSlot = timeSlot; }

    public int getDurationMinutes()                      { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes)  { this.durationMinutes = durationMinutes; }

    public String getLessonType()                        { return lessonType; }
    public void setLessonType(String lessonType)         { this.lessonType = lessonType; }

    public String getStatus()                            { return status; }
    public void setStatus(String status)                 { this.status = status; }

    public String getNotes()                             { return notes; }
    public void setNotes(String notes)                   { this.notes = notes; }

    public LocalDateTime getCreatedAt()                  { return createdAt; }
    public void setCreatedAt(LocalDateTime t)            { this.createdAt = t; }

    public String getStudentName()                       { return studentName; }
    public void setStudentName(String studentName)       { this.studentName = studentName; }

    public String getInstructorName()                    { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }

    public String getVehicleInfo()                       { return vehicleInfo; }
    public void setVehicleInfo(String vehicleInfo)       { this.vehicleInfo = vehicleInfo; }

    public String getCourseName()                        { return courseName; }
    public void setCourseName(String courseName)         { this.courseName = courseName; }
}