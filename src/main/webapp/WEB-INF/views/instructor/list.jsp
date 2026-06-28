<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Instructors – DriveEdu</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0"></head>
<body>
<div class="wrapper">
  <jsp:include page="../sidebar.jsp"/>
  <div class="main-content">
    <div class="topbar">
      <span class="topbar-title">
        <svg class="nav-icon-svg" style="margin-right:6px;" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg>
        Instructors
      </span>
      <div class="topbar-right"><a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a></div>
    </div>
    <div class="page-body">
      <div class="page-header d-flex justify-between align-center">
        <div>
          <div class="breadcrumb"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo; Instructors</div>
          <h2>Instructor Management</h2>
        </div>
        <a href="${pageContext.request.contextPath}/admin/instructors/new" class="btn btn-primary">&#43; Add Instructor</a>
      </div>
      <c:if test="${param.msg eq 'created'}"><div class="alert alert-success">&#10003; Instructor created successfully.</div></c:if>
      <c:if test="${param.msg eq 'updated'}"><div class="alert alert-success">&#10003; Instructor updated successfully.</div></c:if>
      <c:if test="${param.msg eq 'deleted'}"><div class="alert alert-warning">&#9888; Instructor removed.</div></c:if>
      <div class="card">
        <div class="card-header"><h3>All Instructors (${instructors.size()})</h3></div>
        <div class="card-body">
          <table class="table">
            <thead><tr><th>#</th><th>Reg No</th><th>Name</th><th>Email</th><th>Phone</th><th>License No</th><th>Specialization</th><th>Exp</th><th>Password</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
              <c:choose>
                <c:when test="${empty instructors}">
                  <tr><td colspan="10" class="text-center" style="padding:40px;color:#64748B">No instructors found.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="i" items="${instructors}" varStatus="vs">
                    <tr>
                      <td>${vs.index+1}</td><td><strong style="color:var(--navy);">${i.instructorRegNo}</strong></td><td><strong>${i.fullName}</strong></td>
                      <td>${i.email}</td><td>${i.phone}</td><td>${i.licenseNo}</td>
                      <td>${i.formattedSpecialization}</td><td>${i.experienceYears} yrs</td>
                      <td style="font-family:monospace; color:var(--gold);">${i.assignedPassword}</td>
                      <td>
                        <c:choose>
                          <c:when test="${i.status eq 'active'}"><span class="badge badge-success">Active</span></c:when>
                          <c:when test="${i.status eq 'inactive'}"><span class="badge badge-danger">Inactive</span></c:when>
                          <c:otherwise><span class="badge badge-warning">${i.status}</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/instructors/edit?id=${i.instructorId}" class="btn btn-outline btn-sm" style="display:inline-flex;align-items:center;" title="Edit">
                          <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/instructors/delete?id=${i.instructorId}" class="btn btn-danger btn-sm" style="display:inline-flex;align-items:center;" onclick="return confirm('Delete instructor?')" title="Delete">
                          <svg class="nav-icon-svg" style="width:12px;height:12px;stroke:#fff;" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                        </a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
