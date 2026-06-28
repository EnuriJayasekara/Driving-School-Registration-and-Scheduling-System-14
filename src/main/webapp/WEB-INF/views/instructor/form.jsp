<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8">
<title>${empty instructor ? 'Add' : 'Edit'} Instructor – DriveEdu</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0"></head>
<body>
<div class="wrapper">
  <jsp:include page="../sidebar.jsp"/>
  <div class="main-content">
    <div class="topbar">
      <span class="topbar-title">${empty instructor ? 'Add Instructor' : 'Edit Instructor'}</span>
      <div class="topbar-right"><a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a></div>
    </div>
    <div class="page-body">
      <div class="page-header">
        <div class="breadcrumb"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo; <a href="${pageContext.request.contextPath}/admin/instructors/list">Instructors</a> &rsaquo; ${empty instructor ? 'Add' : 'Edit'}</div>
        <h2>${empty instructor ? 'Add New Instructor' : 'Edit Instructor'}</h2>
      </div>
      <c:if test="${not empty error}"><div class="alert alert-danger">&#9888; ${error}</div></c:if>
      <div class="card">
        <div class="card-header"><h3>Instructor Details</h3></div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/admin/instructors/${empty instructor ? 'new' : 'edit'}" method="post">
            <c:if test="${not empty instructor}">
              <input type="hidden" name="instructorId" value="${instructor.instructorId}">
            </c:if>
            <div class="form-row-3">
              <div class="form-group">
                <label>Registration No *</label>
                <input type="text" name="instructorRegNo" class="form-control" value="${instructor.instructorRegNo}" required placeholder="INS-0001">
              </div>
              <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="fullName" class="form-control" value="${instructor.fullName}" required placeholder="Instructor name">
              </div>
              <div class="form-group">
                <label>Phone</label>
                <input type="tel" name="phone" class="form-control" value="${instructor.phone}" placeholder="07X XXX XXXX">
              </div>
            </div>
            <c:if test="${empty instructor}">
              <div class="form-row">
                <div class="form-group">
                  <label>Email *</label>
                  <input type="email" name="email" class="form-control" required placeholder="instructor@email.com">
                </div>
                <div class="form-group">
                  <label>Password *</label>
                  <input type="password" name="password" class="form-control" required placeholder="8+ chars, Uppercase, Lowercase, Digit, Special">
                  <small style="color:var(--text-muted); font-size:0.75rem;">At least 8 chars, 1 Uppercase, 1 Lowercase, 1 Digit, 1 Special Char.</small>
                </div>
              </div>
            </c:if>
            <c:if test="${not empty instructor}">
              <div class="form-row">
                <div class="form-group">
                  <label>Email</label>
                  <input type="email" class="form-control" value="${instructor.email}" readonly style="background: rgba(255,255,255,0.02); color: var(--text-muted); cursor: not-allowed; border-color: rgba(255,255,255,0.05);">
                </div>
                <div class="form-group">
                  <label>Assign New Password (required for approval)</label>
                  <input type="password" name="newPassword" class="form-control" placeholder="8+ chars, Uppercase, Lowercase, Digit, Special">
                  <small style="color:var(--text-muted); font-size:0.75rem;">At least 8 chars, 1 Uppercase, 1 Lowercase, 1 Digit, 1 Special Char.</small>
                </div>
              </div>
            </c:if>
            <div class="form-row">
              <div class="form-group">
                <label>License No *</label>
                <input type="text" name="licenseNo" class="form-control" value="${instructor.licenseNo}" required placeholder="DL-XXXXXXXX">
              </div>
              <div class="form-group">
                <label>Experience (years)</label>
                <div style="display:flex; gap:10px; align-items:center;">
                  <input type="number" id="experienceYears" name="experienceYears" class="form-control" value="${instructor.experienceYears}" min="0" max="50" placeholder="5" style="flex:1;">
                  <span id="designation-badge" style="padding: 10px 14px; font-size: 0.85rem; font-weight: 600; white-space: nowrap; height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; transition: all 0.3s ease;"></span>
                </div>
              </div>
            </div>
            <div class="form-row">
              <div class="form-group">
                <label>Specialization</label>
                <input type="text" name="specialization" class="form-control" value="${not empty instructor ? instructor.cleanSpecialization : ''}" placeholder="e.g. Heavy Vehicle, Motor Cycle">
              </div>
              <div class="form-group">
                <label>Status</label>
                <select name="status" class="form-control">
                  <option value="active"    ${instructor.status eq 'active'    ? 'selected' : ''}>Active</option>
                  <option value="inactive"  ${instructor.status eq 'inactive'  ? 'selected' : ''}>Inactive</option>
                  <option value="on_leave"  ${instructor.status eq 'on_leave'  ? 'selected' : ''}>On Leave</option>
                </select>
              </div>
            </div>
             <div class="d-flex" style="gap:12px;margin-top:8px;">
               <button type="submit" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;">
                 <c:choose>
                   <c:when test="${empty instructor}">
                     <svg class="nav-icon-svg" style="width:12px;height:12px;margin-right:2px;" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg> Create
                   </c:when>
                   <c:otherwise>
                     <svg class="nav-icon-svg" style="width:12px;height:12px;margin-right:2px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Update
                   </c:otherwise>
                 </c:choose>
               </button>
              <a href="${pageContext.request.contextPath}/admin/instructors/list" class="btn btn-outline">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<script>
document.addEventListener("DOMContentLoaded", function() {
    var expInput = document.getElementById("experienceYears");
    var badge = document.getElementById("designation-badge");
    
    function updateBadge() {
        var exp = parseInt(expInput.value) || 0;
        if (exp >= 5) {
            badge.textContent = "Senior Instructor";
            badge.style.background = "var(--gold)";
            badge.style.color = "#fff";
            badge.style.border = "1px solid var(--gold)";
        } else {
            badge.textContent = "Junior Instructor";
            badge.style.background = "rgba(255, 255, 255, 0.05)";
            badge.style.color = "var(--text-muted)";
            badge.style.border = "1px solid var(--border)";
        }
    }
    
    if (expInput && badge) {
        expInput.addEventListener("input", updateBadge);
        expInput.addEventListener("change", updateBadge);
        updateBadge();
    }
});
</script>
</body>
</html>
