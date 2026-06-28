package com.drivingschool.model.contract;

import java.time.LocalDateTime;

/**
 * Abstract base for any human user of the driving-school system
 * (Student, Instructor, and in future possibly Admin).
 * <p>
 * Centralises the fields that Student and Instructor were duplicating
 * (full name, email, phone, status, etc.) and forces every concrete
 * subclass to declare its <em>role</em> via {@link #getRole()}.
 * </p>
 *
 * <h3>OOP concepts demonstrated</h3>
 * <ul>
 *   <li><b>Inheritance</b> &mdash; Student & Instructor extend Person.</li>
 *   <li><b>Abstraction</b> &mdash; abstract class with one abstract method
 *       ({@link #getRole()}); you cannot instantiate {@code new Person()}.</li>
 *   <li><b>Polymorphism</b> &mdash; a {@code List<Person>} can hold a mix
 *       of students and instructors and each will return its own role.</li>
 *   <li><b>Encapsulation</b> &mdash; all fields private with controlled
 *       access through getters/setters.</li>
 * </ul>
 */
public abstract class Person implements Identifiable {

    // ---- shared identity fields (from users table, joined in service layer) ----
    private int           userId;
    private String        fullName;
    private String        email;
    private String        phone;
    private String        status;
    private LocalDateTime createdAt;

    protected Person() { /* required for service-layer row mapping */ }

    // ---- ABSTRACT: every concrete subclass must answer "what role am I?" ----
    /**
     * @return the role this person plays in the system,
     *         e.g. {@code "student"} or {@code "instructor"}.
     *         Matches the value used in the {@code users.role} column.
     */
    public abstract String getRole();

    // ---- concrete helper shared by all subclasses ----
    /** Human-friendly label used in admin lists and dashboards. */
    public String getDisplayName() {
        if (fullName == null || fullName.isEmpty()) return "(unnamed " + getRole() + ")";
        return fullName + " <" + (email == null ? "" : email) + ">";
    }

    // ---- Identifiable contract ----
    /**
     * Default identity is the {@code user_id}; subclasses with a
     * dedicated PK (student_id / instructor_id) should override this.
     */
    @Override
    public int getId() { return userId; }

    // ---- standard getters / setters ----
    public int getUserId()                       { return userId; }
    public void setUserId(int userId)            { this.userId = userId; }

    public String getFullName()                  { return fullName; }
    public void setFullName(String fullName)     { this.fullName = fullName; }

    public String getEmail()                     { return email; }
    public void setEmail(String email)           { this.email = email; }

    public String getPhone()                     { return phone; }
    public void setPhone(String phone)           { this.phone = phone; }

    public String getStatus()                    { return status; }
    public void setStatus(String status)         { this.status = status; }

    public LocalDateTime getCreatedAt()          { return createdAt; }
    public void setCreatedAt(LocalDateTime t)    { this.createdAt = t; }
}