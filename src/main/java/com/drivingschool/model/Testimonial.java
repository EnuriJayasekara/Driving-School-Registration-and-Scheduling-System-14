package com.drivingschool.model;

import java.sql.Timestamp;

public class Testimonial {
    private int testimonialId;
    private String studentName;
    private int rating;
    private String message;
    private String licenseCategory;
    private boolean isApproved;
    private Timestamp createdAt;

    // Getters and Setters
    public int getTestimonialId() {
        return testimonialId;
    }
    public void setTestimonialId(int testimonialId) {
        this.testimonialId = testimonialId;
    }

    public String getStudentName() {
        return studentName;
    }
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }

    public int getRating() {
        return rating;
    }
    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getMessage() {
        return message;
    }
    public void setMessage(String message) {
        this.message = message;
    }

    public String getLicenseCategory() {
        return licenseCategory;
    }
    public void setLicenseCategory(String licenseCategory) {
        this.licenseCategory = licenseCategory;
    }

    public boolean isApproved() {
        return isApproved;
    }
    public void setApproved(boolean isApproved) {
        this.isApproved = isApproved;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
