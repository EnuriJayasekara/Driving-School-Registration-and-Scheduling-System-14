package com.drivingschool.model;

import com.drivingschool.model.contract.Identifiable;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/** Maps to the `enrollments` table. */
public class Enrollment implements Identifiable {

    /** Identifiable contract: an enrollment is identified by its enrollment_id. */
    @Override
    public int getId() { return enrollmentId; }


    private int           enrollmentId;
    private int           studentId;
    private int           courseId;
    private LocalDate     enrollmentDate;
    private String        paymentStatus;
    private BigDecimal    amountPaid;
    private String        status;
    private String        notes;
    private LocalDateTime createdAt;

    // Joined fields
    private String studentName;
    private String courseName;
    private BigDecimal coursePrice;

    public Enrollment() {}

    // ---- Getters & Setters ----
    public int getEnrollmentId()                          { return enrollmentId; }
    public void setEnrollmentId(int enrollmentId)         { this.enrollmentId = enrollmentId; }

    public int getStudentId()                             { return studentId; }
    public void setStudentId(int studentId)               { this.studentId = studentId; }

    public int getCourseId()                              { return courseId; }
    public void setCourseId(int courseId)                 { this.courseId = courseId; }

    public LocalDate getEnrollmentDate()                  { return enrollmentDate; }
    public void setEnrollmentDate(LocalDate enrollmentDate){ this.enrollmentDate = enrollmentDate; }

    public String getPaymentStatus()                      { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus)    { this.paymentStatus = paymentStatus; }

    public BigDecimal getAmountPaid()                     { return amountPaid; }
    public void setAmountPaid(BigDecimal amountPaid)      { this.amountPaid = amountPaid; }

    public String getStatus()                             { return status; }
    public void setStatus(String status)                  { this.status = status; }

    public String getNotes()                              { return notes; }
    public void setNotes(String notes)                    { this.notes = notes; }

    public LocalDateTime getCreatedAt()                   { return createdAt; }
    public void setCreatedAt(LocalDateTime t)             { this.createdAt = t; }

    public String getStudentName()                        { return studentName; }
    public void setStudentName(String studentName)        { this.studentName = studentName; }

    public String getCourseName()                         { return courseName; }
    public void setCourseName(String courseName)          { this.courseName = courseName; }

    public BigDecimal getCoursePrice()                    { return coursePrice; }
    public void setCoursePrice(BigDecimal coursePrice)    { this.coursePrice = coursePrice; }
}