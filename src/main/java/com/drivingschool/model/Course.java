package com.drivingschool.model;

import com.drivingschool.model.contract.Identifiable;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/** Maps to the `courses` table. */
public class Course implements Identifiable {

    /** Identifiable contract: a course is identified by its course_id. */
    @Override
    public int getId() { return courseId; }


    private int           courseId;
    private String        courseName;
    private String        licenseCategory;
    private int           totalHours;
    private BigDecimal    price;
    private String        description;
    private boolean       isActive;
    private LocalDateTime createdAt;

    public Course() {}

    // ---- Getters & Setters ----
    public int getCourseId()                           { return courseId; }
    public void setCourseId(int courseId)              { this.courseId = courseId; }

    public String getCourseName()                      { return courseName; }
    public void setCourseName(String courseName)       { this.courseName = courseName; }

    public String getLicenseCategory()                 { return licenseCategory; }
    public void setLicenseCategory(String lc)          { this.licenseCategory = lc; }

    public int getTotalHours()                         { return totalHours; }
    public void setTotalHours(int totalHours)          { this.totalHours = totalHours; }

    public BigDecimal getPrice()                       { return price; }
    public void setPrice(BigDecimal price)             { this.price = price; }

    public String getDescription()                     { return description; }
    public void setDescription(String description)     { this.description = description; }

    public boolean isActive()                          { return isActive; }
    public void setActive(boolean active)              { this.isActive = active; }

    public LocalDateTime getCreatedAt()                { return createdAt; }
    public void setCreatedAt(LocalDateTime t)          { this.createdAt = t; }
}