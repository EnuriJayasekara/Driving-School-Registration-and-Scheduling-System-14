package com.drivingschool.model;

import com.drivingschool.model.contract.Identifiable;

import java.time.LocalDateTime;

/** Maps to the `users` table. */
public class User implements Identifiable {

    /** Identifiable contract: a user is identified by its user_id. */
    @Override
    public int getId() { return userId; }


    private int           userId;
    private String        fullName;
    private String        email;
    private String        passwordHash;
    private String        phone;
    private String        role;          // admin | student | instructor
    private boolean       isActive;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public User() {}

    public User(String fullName, String email, String passwordHash, String phone, String role) {
        this.fullName     = fullName;
        this.email        = email;
        this.passwordHash = passwordHash;
        this.phone        = phone;
        this.role         = role;
        this.isActive     = true;
    }

    // ---- Getters & Setters ----
    public int getUserId()                        { return userId; }
    public void setUserId(int userId)             { this.userId = userId; }

    public String getFullName()                   { return fullName; }
    public void setFullName(String fullName)      { this.fullName = fullName; }

    public String getEmail()                      { return email; }
    public void setEmail(String email)            { this.email = email; }

    public String getPasswordHash()               { return passwordHash; }
    public void setPasswordHash(String h)         { this.passwordHash = h; }

    public String getPhone()                      { return phone; }
    public void setPhone(String phone)            { this.phone = phone; }

    public String getRole()                       { return role; }
    public void setRole(String role)              { this.role = role; }

    public boolean isActive()                     { return isActive; }
    public void setActive(boolean active)         { this.isActive = active; }

    public LocalDateTime getCreatedAt()           { return createdAt; }
    public void setCreatedAt(LocalDateTime t)     { this.createdAt = t; }

    public LocalDateTime getUpdatedAt()           { return updatedAt; }
    public void setUpdatedAt(LocalDateTime t)     { this.updatedAt = t; }
}