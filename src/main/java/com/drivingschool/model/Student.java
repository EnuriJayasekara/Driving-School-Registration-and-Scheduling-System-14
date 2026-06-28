package com.drivingschool.model;

import com.drivingschool.model.contract.Person;

import java.time.LocalDate;

/**
 * Maps to the {@code students} table.  Joined with {@code users} in the service layer.
 * <p>
 * Now extends {@link Person} (which holds userId, fullName, email, phone, status,
 * createdAt). All existing getter/setter signatures are preserved &mdash;
 * services and JSPs work unchanged.
 * </p>
 */
public class Student extends Person {

    // ---- student-specific fields ----
    private int       studentId;
    private String    studentRegNo;
    private String    nicNumber;
    private LocalDate dob;
    private String    address;
    private String    licenseType;
    private LocalDate trialDate;

    public Student() {}

    // ---- Person contract ----
    /** {@inheritDoc} Always {@code "student"}. */
    @Override
    public String getRole() { return "student"; }

    /** Override Identifiable: a student is identified by its student_id. */
    @Override
    public int getId() { return studentId; }

    // ---- student-specific getters / setters ----
    public int getStudentId()                        { return studentId; }
    public void setStudentId(int studentId)          { this.studentId = studentId; }

    public String getStudentRegNo()                  { return studentRegNo; }
    public void setStudentRegNo(String studentRegNo) { this.studentRegNo = studentRegNo; }

    public String getNicNumber()                     { return nicNumber; }
    public void setNicNumber(String nicNumber)       { this.nicNumber = nicNumber; }

    public LocalDate getDob()                        { return dob; }
    public void setDob(LocalDate dob)                { this.dob = dob; }

    public String getAddress()                       { return address; }
    public void setAddress(String address)           { this.address = address; }

    public String getLicenseType()                   { return licenseType; }
    public void setLicenseType(String licenseType)   { this.licenseType = licenseType; }

    public LocalDate getTrialDate()                  { return trialDate; }
    public void setTrialDate(LocalDate trialDate)    { this.trialDate = trialDate; }

    // NOTE: getStatus / setStatus, getFullName / setFullName, getEmail / setEmail,
    // getPhone / setPhone, getUserId / setUserId, getCreatedAt / setCreatedAt
    // are all INHERITED from Person -- no need to redeclare them.
}