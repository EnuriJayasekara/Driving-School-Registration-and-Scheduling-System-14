<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login – DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="auth-page">
  <!-- LEFT PANEL -->
  <div class="auth-panel-left" style="background: linear-gradient(rgba(241, 245, 249, 0.9), rgba(241, 245, 249, 0.9)), url('https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?auto=format&fit=crop&q=80&w=800') center center / cover; border-right: 1px solid var(--border);">
    <a href="${pageContext.request.contextPath}/" style="text-decoration: none; display: block;">
      <div class="auth-brand" style="cursor: pointer;">
        <div class="logo-ring" style="color: var(--gold); border-color: var(--gold); display: flex; align-items: center; justify-content: center;">
          <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <circle cx="12" cy="12" r="3"></circle>
            <line x1="12" y1="2" x2="12" y2="9"></line>
            <line x1="3.5" y1="17" x2="9.5" y2="13.5"></line>
            <line x1="20.5" y1="17" x2="14.5" y2="13.5"></line>
          </svg>
        </div>
        <h1 style="color: var(--text-main)">DriveEdu</h1>
        <p class="tagline" style="color: var(--text-muted)">Your journey to safe driving starts here.</p>
      </div>
    </a>
    <div class="auth-features">
      <div class="auth-feature" style="color: var(--text-muted)">
        <div class="feat-icon" style="color: var(--gold); border-color: rgba(196, 155, 85, 0.2); background: var(--gold-pale); display: flex; align-items: center; justify-content: center;">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 10v6M2 10l10-5 10 5-10 5z"/><path d="M6 12v5c0 2 2 3 6 3s6-1 6-3v-5"/></svg>
        </div>
        <div>
          <strong style="color: var(--text-main)">Students</strong><br>
          Register, enroll in courses, and pick driving lesson slots.
        </div>
      </div>
      <div class="auth-feature" style="color: var(--text-muted)">
        <div class="feat-icon" style="color: var(--gold); border-color: rgba(196, 155, 85, 0.2); background: var(--gold-pale); display: flex; align-items: center; justify-content: center;">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"/><path d="m4.93 4.93 4.24 4.24"/><path d="m14.83 9.17 4.24-4.24"/><path d="M12 12V2"/><path d="M12 12h10"/></svg>
        </div>
        <div>
          <strong style="color: var(--text-main)">Instructors</strong><br>
          Manage lessons, track and update student learning progress.
        </div>
      </div>
      <div class="auth-feature" style="color: var(--text-muted)">
        <div class="feat-icon" style="color: var(--gold); border-color: rgba(196, 155, 85, 0.2); background: var(--gold-pale); display: flex; align-items: center; justify-content: center;">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
        </div>
        <div>
          <strong style="color: var(--text-main)">Admin Portal</strong><br>
          Full control over students, schedules, billing and fleet.
        </div>
      </div>
    </div>
  </div>

  <!-- RIGHT PANEL -->
  <div class="auth-panel-right">
    <div class="auth-form-box">
      <div style="margin-bottom: 20px;">
        <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); text-decoration: none; font-size: 0.9rem; font-weight: 500; display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s;" onmouseover="this.style.color='var(--gold)'" onmouseout="this.style.color='var(--text-muted)'">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
          Back to Home
        </a>
      </div>
      <h2>Welcome back</h2>
      <p class="sub">Sign in to your DriveEdu account</p>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">&#9888; ${error}</div>
      </c:if>
      <c:if test="${not empty success}">
        <div class="alert alert-success">&#10003; ${success}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
          <label for="email">Email address</label>
          <input type="email" id="email" name="email" class="form-control"
                 placeholder="your@email.com" required autocomplete="email">
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input type="password" id="password" name="password" class="form-control"
                 placeholder="••••••••" required>
          <div style="text-align: right; margin-top: 6px;">
            <a href="${pageContext.request.contextPath}/forgot-password" style="font-size: 0.85rem; color: var(--gold);">Forgot password?</a>
          </div>
        </div>

        <button type="submit" class="btn btn-primary" style="width:100%;padding:12px;font-size:1rem;margin-top:6px;">
          Sign In
        </button>
      </form>

      <div class="auth-divider"><span>Don't have an account?</span></div>

      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 12px;">
        <a href="${pageContext.request.contextPath}/register"
           class="btn btn-outline" style="text-align:center; padding:12px; font-size:.9rem; display:block; text-decoration:none;">
          Student Sign Up
        </a>
        <a href="${pageContext.request.contextPath}/instructor-apply"
           class="btn btn-outline" style="text-align:center; padding:12px; font-size:.9rem; display:block; text-decoration:none;">
          Instructor Join
        </a>
      </div>


    </div>
  </div>
</div>
<script>
  document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".alert").forEach(function(alert) {
      if (!alert.querySelector(".alert-close")) {
        var closeBtn = document.createElement("span");
        closeBtn.className = "alert-close";
        closeBtn.innerHTML = "&times;";
        closeBtn.style.marginLeft = "auto";
        closeBtn.style.cursor = "pointer";
        closeBtn.style.fontSize = "1.2rem";
        closeBtn.style.fontWeight = "bold";
        closeBtn.style.lineHeight = "1";
        closeBtn.style.opacity = "0.7";
        closeBtn.style.transition = "opacity 0.2s";
        
        closeBtn.addEventListener("mouseover", function() {
          closeBtn.style.opacity = "1";
        });
        closeBtn.addEventListener("mouseout", function() {
          closeBtn.style.opacity = "0.7";
        });
        closeBtn.addEventListener("click", function() {
          alert.style.display = "none";
        });
        alert.appendChild(closeBtn);
      }
    });
  });
</script>
</body>
</html>
