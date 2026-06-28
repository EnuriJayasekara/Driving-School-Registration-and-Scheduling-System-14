package com.drivingschool.model;

import com.drivingschool.model.contract.Identifiable;

import java.time.LocalDateTime;

public class Notification implements Identifiable {

    /** Identifiable contract: a notification is identified by its notification_id. */
    @Override
    public int getId() { return notificationId; }

    private int notificationId;
    private int userId;
    private String title;
    private String message;
    private String link;
    private String type = "info";       // info / success / warning / reminder
    private boolean isRead = false;
    private LocalDateTime createdAt;

    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public String getLink() { return link; }
    public void setLink(String link) { this.link = link; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}