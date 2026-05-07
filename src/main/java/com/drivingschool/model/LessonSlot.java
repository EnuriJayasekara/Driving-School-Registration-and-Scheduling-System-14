package com.drivingschool.model;

import com.drivingschool.model.contract.Bookable;
import com.drivingschool.model.contract.Identifiable;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Maps to the {@code lesson_slots} table.
 * <p>
 * Implements:
 * <ul>
 *   <li>{@link Identifiable} &mdash; uniform identity contract.</li>
 *   <li>{@link Bookable} &mdash; capacity / booking-count / status contract.
 *       {@code isFull()}, {@code getSeatsLeft()} and {@code isBookable()}
 *       come from the interface as <em>default methods</em>, so we don't
 *       reimplement them here.</li>
 * </ul>
 * </p>
 */
public class LessonSlot implements Identifiable, Bookable {

    private int slotId;
    private int courseId;
    private int instructorId;
    private int vehicleId;
    private LocalDate lessonDate;
    private String timeSlot;
    private int durationMinutes = 60;
    private String lessonType = "practical";
    private int capacity = 1;
    private int bookingsCount = 0;
    private String status = "open";
    private String notes;
    private LocalDateTime createdAt;

    // joined fields populated by service queries
    private String courseName;
    private String licenseCategory;
    private String instructorName;
    private String vehicleInfo;

    // ---- Identifiable ----
    @Override
    public int getId() { return slotId; }

    // ---- Bookable: getCapacity / getBookingsCount / getStatus come from the
    //                 standard getters below. isFull / getSeatsLeft / isBookable
    //                 are provided as default methods on Bookable itself.

    public int getSlotId() { return slotId; }
    public void setSlotId(int slotId) { this.slotId = slotId; }

    public int getCourseId() { return courseId; }
    public void setCourseId(int courseId) { this.courseId = courseId; }

    public int getInstructorId() { return instructorId; }
    public void setInstructorId(int instructorId) { this.instructorId = instructorId; }

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public LocalDate getLessonDate() { return lessonDate; }
    public void setLessonDate(LocalDate lessonDate) { this.lessonDate = lessonDate; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int durationMinutes) { this.durationMinutes = durationMinutes; }

    public String getLessonType() { return lessonType; }
    public void setLessonType(String lessonType) { this.lessonType = lessonType; }

    @Override
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    @Override
    public int getBookingsCount() { return bookingsCount; }
    public void setBookingsCount(int bookingsCount) { this.bookingsCount = bookingsCount; }

    @Override
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public String getCourseName() { return courseName; }
    public void setCourseName(String courseName) { this.courseName = courseName; }

    public String getLicenseCategory() { return licenseCategory; }
    public void setLicenseCategory(String licenseCategory) { this.licenseCategory = licenseCategory; }

    public String getInstructorName() { return instructorName; }
    public void setInstructorName(String instructorName) { this.instructorName = instructorName; }

    public String getVehicleInfo() { return vehicleInfo; }
    public void setVehicleInfo(String vehicleInfo) { this.vehicleInfo = vehicleInfo; }
}