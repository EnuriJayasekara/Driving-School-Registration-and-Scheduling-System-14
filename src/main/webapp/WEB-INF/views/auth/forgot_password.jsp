<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Forgot Password – DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="auth-page">
  <div class="auth-panel-right" style="margin: 0 auto; min-width: 400px; padding: 2rem;">
    <div class="auth-form-box">
      <div style="margin-bottom: 20px;">
        <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); text-decoration: none; font-size: 0.9rem; font-weight: 500; display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s;" onmouseover="this.style.color='var(--gold)'" onmouseout="this.style.color='var(--text-muted)'">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
          Back to Home
        </a>
      </div>
      <h2>Reset Password</h2>
      <p class="sub">Enter your email and a new password.</p>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">&#9888; ${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/forgot-password" method="post">
        <div class="form-group">
          <label for="email">Email address</label>
          <input type="email" id="email" name="email" class="form-control" placeholder="your@email.com" required>
        </div>
        <div class="form-group">
          <label for="newPassword">New Password</label>
          <input type="password" id="newPassword" name="newPassword" class="form-control" placeholder="••••••••" required>
        </div>
        <div class="form-group">
          <label for="confirmPassword">Confirm Password</label>
          <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" placeholder="••••••••" required>
        </div>

        <button type="submit" class="btn btn-primary" style="width:100%;padding:12px;font-size:1rem;margin-top:6px;">
          Reset Password
        </button>
      </form>

      <div class="auth-divider"><span>or</span></div>

      <a href="${pageContext.request.contextPath}/login" class="btn btn-outline" style="width:100%;text-align:center;padding:12px;font-size:.95rem;">
        Back to Login
      </a>
    </div>
  </div>
</div>
</body>
</html>
