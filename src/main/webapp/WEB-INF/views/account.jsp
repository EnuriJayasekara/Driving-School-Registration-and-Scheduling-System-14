<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Account &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">My Account</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/${sessionScope.role eq 'admin' ? 'admin' : (sessionScope.role eq 'instructor' ? 'instructor' : 'student')}/dashboard">Dashboard</a>
                    &rsaquo; My Account
                </div>
                <h2>Account Settings</h2>
                <p style="color:#777;margin:4px 0 0;">Update your profile details or change your password.</p>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success">&#10003; ${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">&#9888; ${error}</div>
            </c:if>

            <%-- ============== Profile card ============== --%>
            <div class="card">
                <div class="card-header">
                    <h3>Profile Information</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/account" method="post">
                        <input type="hidden" name="formType" value="profile">

                        <div class="form-row">
                            <div class="form-group">
                                <label>Full Name *</label>
                                <input type="text" name="fullName" class="form-control"
                                       value="${user.fullName}" required maxlength="100">
                            </div>
                            <div class="form-group">
                                <label>Role</label>
                                <input type="text" class="form-control" value="${user.role}" disabled>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Email *</label>
                                <input type="email" name="email" class="form-control"
                                       value="${user.email}" required maxlength="150">
                            </div>
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="text" name="phone" class="form-control"
                                       value="${user.phone}" maxlength="20" placeholder="07X XXX XXXX">
                            </div>
                        </div>

                        <c:if test="${sessionScope.role eq 'instructor'}">
                            <div class="form-row" style="margin-top: 12px;">
                                <div class="form-group" style="flex: 1;">
                                    <label>Registration Number (License No) *</label>
                                    <input type="text" name="licenseNo" class="form-control"
                                           value="${instructor.licenseNo}" required maxlength="50">
                                </div>
                                <div class="form-group" style="flex: 1.2;">
                                    <label>Specialization</label>
                                    <input type="text" name="specialization" class="form-control"
                                           value="${not empty instructor ? instructor.cleanSpecialization : ''}" placeholder="e.g. Light Vehicles, Heavy Trucks" maxlength="100">
                                </div>
                                <div class="form-group" style="flex: 1.3;">
                                    <label>Experience (Years)</label>
                                    <div style="display:flex; gap:10px; align-items:center;">
                                        <input type="number" id="experienceYears" name="experienceYears" class="form-control"
                                               value="${instructor.experienceYears}" min="0" style="flex:1;">
                                        <span id="designation-badge" style="padding: 10px 14px; font-size: 0.85rem; font-weight: 600; white-space: nowrap; height: 42px; display: inline-flex; align-items: center; justify-content: center; border-radius: 8px; transition: all 0.3s ease;"></span>
                                    </div>
                                </div>
                            </div>
                        </c:if>

                        <div class="d-flex gap-2" style="gap:12px;margin-top:8px;">
                            <button type="submit" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;"><svg class="nav-icon-svg" style="width:14px;height:14px;" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg> Save Profile</button>
                        </div>
                    </form>
                </div>
            </div>

            <%-- ============== Password card ============== --%>
            <div class="card" style="margin-top:24px;">
                <div class="card-header">
                    <h3>Change Password</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/account" method="post" autocomplete="off">
                        <input type="hidden" name="formType" value="password">

                        <div class="form-group">
                            <label>Current Password *</label>
                            <input type="password" name="currentPassword" class="form-control"
                                   required autocomplete="current-password">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>New Password *</label>
                                <input type="password" name="newPassword" class="form-control"
                                       required minlength="6" autocomplete="new-password">
                                <small style="color:#888;">At least 6 characters.</small>
                            </div>
                            <div class="form-group">
                                <label>Confirm New Password *</label>
                                <input type="password" name="confirmPassword" class="form-control"
                                       required minlength="6" autocomplete="new-password">
                            </div>
                        </div>

                        <div class="d-flex gap-2" style="gap:12px;margin-top:8px;">
                            <button type="submit" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;"><svg class="nav-icon-svg" style="width:14px;height:14px;" viewBox="0 0 24 24"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg> Update Password</button>
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
        if (!expInput || !badge) return;
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
