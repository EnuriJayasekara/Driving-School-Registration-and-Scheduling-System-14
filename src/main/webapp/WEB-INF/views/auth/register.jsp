<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Register – DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="auth-page">
  <div class="auth-panel-left" style="background: linear-gradient(rgba(241, 245, 249, 0.9), rgba(241, 245, 249, 0.9)), url('https://images.unsplash.com/photo-1511919884226-fd3cad34687c?auto=format&fit=crop&q=80&w=800') center center / cover; border-right: 1px solid var(--border);">
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
        <p class="tagline" style="color: var(--text-muted)">Join thousands of successful drivers.</p>
      </div>
    </a>
    <div class="auth-features">
      <div class="auth-feature" style="color: var(--text-muted)">
        <div class="feat-icon" style="color: var(--gold); border-color: rgba(196, 155, 85, 0.2); background: var(--gold-pale); display: flex; align-items: center; justify-content: center;">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"/></svg>
        </div>
        <div>Free registration – no hidden fees</div>
      </div>
      <div class="auth-feature" style="color: var(--text-muted)">
        <div class="feat-icon" style="color: var(--gold); border-color: rgba(196, 155, 85, 0.2); background: var(--gold-pale); display: flex; align-items: center; justify-content: center;">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
        </div>
        <div>Flexible lesson scheduling at your convenience</div>
      </div>
      <div class="auth-feature" style="color: var(--text-muted)">
        <div class="feat-icon" style="color: var(--gold); border-color: rgba(196, 155, 85, 0.2); background: var(--gold-pale); display: flex; align-items: center; justify-content: center;">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
        </div>
        <div>All license categories – A1, A, B, B1, C, CE, D</div>
      </div>
    </div>
  </div>

  <div class="auth-panel-right">
    <div class="auth-form-box" style="max-width:480px">
      <div style="margin-bottom: 20px;">
        <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); text-decoration: none; font-size: 0.9rem; font-weight: 500; display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s;" onmouseover="this.style.color='var(--gold)'" onmouseout="this.style.color='var(--text-muted)'">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
          Back to Home
        </a>
      </div>
      <h2>Create Account</h2>
      <p class="sub">Register as a new student</p>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">&#9888; ${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="form-row">
          <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullName" class="form-control" placeholder="John Silva" required>
          </div>
          <div class="form-group">
            <label>Phone Number</label>
            <input type="tel" name="phone" class="form-control" placeholder="07X XXX XXXX">
          </div>
        </div>

        <div class="form-group">
          <label>Email Address</label>
          <input type="email" name="email" class="form-control" placeholder="you@email.com" required>
        </div>

        <div class="form-group">
          <label>Password</label>
          <input type="password" name="password" class="form-control"
                 placeholder="Min 8 characters" required minlength="8">
        </div>

        <div class="form-row">
          <div class="form-group">
            <label>NIC Number</label>
            <input type="text" name="nicNumber" class="form-control" placeholder="XXXXXXXXXV or XXXXXXXXXXXX" required>
          </div>
          <div class="form-group">
            <label>License Type</label>
            <select name="licenseType" class="form-control">
              <option value="B">B – Car</option>
              <option value="A">A – Motor Cycle</option>
              <option value="A1">A1 – Motor Cycle (Small)</option>
              <option value="B1">B1 – Light Vehicle</option>
              <option value="C">C – Heavy Vehicle</option>
              <option value="CE">CE – Articulated</option>
              <option value="D">D – Passenger</option>
            </select>
          </div>
        </div>

        <div class="form-group">
          <label>Address</label>
          <textarea name="address" class="form-control" rows="2" placeholder="Your home address"></textarea>
        </div>

        <button type="submit" class="btn btn-primary"
                style="width:100%;padding:12px;font-size:1rem;margin-top:4px;">
          Create Account
        </button>
      </form>

      <div class="auth-divider"><span>Already have an account?</span></div>
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
        <a href="${pageContext.request.contextPath}/login"
           class="btn btn-outline" style="text-align:center; padding:12px; font-size:.9rem; text-decoration:none;">
          Sign In
        </a>
        <a href="${pageContext.request.contextPath}/instructor-apply"
           class="btn btn-outline" style="text-align:center; padding:12px; font-size:.9rem; text-decoration:none;">
          Teach With Us
        </a>
      </div>
    </div>
  </div>
</div>
</body>
</html>
