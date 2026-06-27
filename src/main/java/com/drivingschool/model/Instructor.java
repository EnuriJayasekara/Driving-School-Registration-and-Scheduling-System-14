package com.drivingschool.model;

import com.drivingschool.model.contract.Person;

/**
 * Maps to the {@code instructors} table. Joined with {@code users} in the service layer.
 * <p>
 * Extends {@link Person} (which holds userId, fullName, email, phone, status, createdAt).
 * All existing getter/setter signatures are preserved.
 * </p>
 */
public class Instructor extends Person {

    // ---- instructor-specific fields ----
    private int    instructorId;
    private String instructorRegNo;
    private String licenseNo;
    private String specialization;
    private int    experienceYears;
    private String assignedPassword;

    public Instructor() {}

    // ---- Person contract ----
    /** {@inheritDoc} Always {@code "instructor"}. */
    @Override
    public String getRole() { return "instructor"; }

    /** Override Identifiable: an instructor is identified by its instructor_id. */
    @Override
    public int getId() { return instructorId; }

    // ---- instructor-specific getters / setters ----
    public int getInstructorId()                         { return instructorId; }
    public void setInstructorId(int instructorId)        { this.instructorId = instructorId; }

    public String getInstructorRegNo()                  { return instructorRegNo; }
    public void setInstructorRegNo(String instructorRegNo) { this.instructorRegNo = instructorRegNo; }

    public String getLicenseNo()                         { return licenseNo; }
    public void setLicenseNo(String licenseNo)           { this.licenseNo = licenseNo; }

    public String getSpecialization()                    { return specialization; }
    public void setSpecialization(String specialization) { this.specialization = specialization; }

    public String getCleanSpecialization() {
        if (specialization == null) return "";
        String clean = specialization.trim();
        if (clean.toLowerCase().startsWith("senior instructor - ")) {
            return clean.substring("senior instructor - ".length());
        }
        if (clean.toLowerCase().startsWith("junior instructor - ")) {
            return clean.substring("junior instructor - ".length());
        }
        if (clean.equalsIgnoreCase("senior instructor") || clean.equalsIgnoreCase("junior instructor")) {
            return "";
        }
        return clean;
    }

    public String getFormattedSpecialization() {
        if (specialization == null || specialization.trim().isEmpty()) {
            return experienceYears >= 5 ? "Senior Instructor" : "Junior Instructor";
        }
        String specLower = specialization.toLowerCase().trim();
        if (specLower.startsWith("senior") || specLower.startsWith("junior")) {
            return specialization;
        }
        return (experienceYears >= 5 ? "Senior Instructor - " : "Junior Instructor - ") + specialization;
    }

    public int getExperienceYears()                      { return experienceYears; }
    public void setExperienceYears(int experienceYears)  { this.experienceYears = experienceYears; }

    public String getAssignedPassword()                  { return assignedPassword; }
    public void setAssignedPassword(String assignedPassword) { this.assignedPassword = assignedPassword; }

    // NOTE: getStatus / setStatus, getFullName / setFullName, getEmail / setEmail,
    // getPhone / setPhone, getUserId / setUserId, getCreatedAt / setCreatedAt
    // are all INHERITED from Person.
}