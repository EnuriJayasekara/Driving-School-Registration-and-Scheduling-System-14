<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Instructor Registration – DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="auth-page">
  <div class="auth-panel-right" style="margin: 0 auto; min-width: 500px; padding: 2rem;">
    <div class="auth-form-box" style="max-width: none;">
      <div style="margin-bottom: 20px;">
        <a href="${pageContext.request.contextPath}/" style="color: var(--text-muted); text-decoration: none; font-size: 0.9rem; font-weight: 500; display: inline-flex; align-items: center; gap: 6px; transition: color 0.2s;" onmouseover="this.style.color='var(--gold)'" onmouseout="this.style.color='var(--text-muted)'">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
          Back to Home
        </a>
      </div>
      <h2>Instructor Registration</h2>
      <p class="sub">Register to join our team of professional driving instructors.</p>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">&#9888; ${error}</div>
      </c:if>

      <form action="${pageContext.request.contextPath}/instructor-apply" method="post">
        
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
            <div class="form-group">
              <label for="fullName">Full Name</label>
              <input type="text" id="fullName" name="fullName" class="form-control" placeholder="e.g. David Smith" required>
            </div>
            <div class="form-group">
              <label for="email">Email address</label>
              <input type="email" id="email" name="email" class="form-control" placeholder="david@email.com" required>
            </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
            <div class="form-group">
              <label for="nic">NIC Number</label>
              <input type="text" id="nic" name="nic" class="form-control" placeholder="XXXXXXXXXV / XXXXXXXXXXXX" required>
            </div>
            <div class="form-group">
              <label for="phone">Contact Number</label>
              <input type="text" id="phone" name="phone" class="form-control" placeholder="e.g. 0771234567" required>
            </div>
        </div>

        <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:16px;">
            <div class="form-group">
              <label for="dob">Date of Birth</label>
              <input type="date" id="dob" name="dob" class="form-control" required>
            </div>
            <div class="form-group">
              <label for="gender">Gender</label>
              <select id="gender" name="gender" class="form-control" required>
                  <option value="Male">Male</option>
                  <option value="Female">Female</option>
              </select>
            </div>
            <div class="form-group">
              <label for="experienceYears">Experience (Years)</label>
              <input type="number" id="experienceYears" name="experienceYears" class="form-control" min="0" required>
            </div>
        </div>

        <div class="form-group">
          <label for="specialization">Specialization & Qualifications</label>
          <input type="text" id="specialization" name="specialization" class="form-control" placeholder="e.g. Heavy Vehicles, Defensive Driving Certified" required>
        </div>

        <button type="submit" class="btn btn-primary" style="width:100%;padding:12px;font-size:1rem;margin-top:6px;">
          Submit Instructor Application
        </button>
      </form>

      <div class="auth-divider"><span>or</span></div>

      <a href="${pageContext.request.contextPath}/login" class="btn btn-outline" style="width:100%;text-align:center;padding:12px;font-size:.95rem;text-decoration:none;display:block;">
        Back to Login
      </a>
    </div>
  </div>
</div>
</body>
</html>
