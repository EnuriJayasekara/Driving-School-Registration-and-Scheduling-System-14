<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Students – DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
  <jsp:include page="../sidebar.jsp"/>
  <div class="main-content">
    <div class="topbar">
      <span class="topbar-title">
        <svg class="nav-icon-svg" style="margin-right:6px;" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
        Students
      </span>
      <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
      </div>
    </div>

    <div class="page-body">
      <div class="page-header d-flex justify-between align-center">
        <div>
          <div class="breadcrumb"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo; Students</div>
          <h2>Student Management</h2>
        </div>
        <a href="${pageContext.request.contextPath}/admin/students/new" class="btn btn-primary">&#43; Add Student</a>
      </div>

      <c:if test="${param.msg eq 'created'}"><div class="alert alert-success">&#10003; Student created successfully.</div></c:if>
      <c:if test="${param.msg eq 'updated'}"><div class="alert alert-success">&#10003; Student updated successfully.</div></c:if>
      <c:if test="${param.msg eq 'deleted'}"><div class="alert alert-warning">&#9888; Student removed.</div></c:if>

      <div class="card">
        <div class="card-header"><h3>All Students (${students.size()})</h3></div>
        <div class="card-body">
          <table class="table">
            <thead>
              <tr>
                <th>#</th><th>Reg No</th><th>Full Name</th><th>Email</th><th>Phone</th>
                <th>NIC</th><th>License Type</th><th>Status</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty students}">
                  <tr><td colspan="9" class="text-center" style="padding:40px;color:#64748B">No students found.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="s" items="${students}" varStatus="vs">
                    <tr>
                      <td>${vs.index + 1}</td>
                      <td><strong style="color:var(--navy);">${s.studentRegNo}</strong></td>
                      <td><strong>${s.fullName}</strong></td>
                      <td>${s.email}</td>
                      <td>${s.phone}</td>
                      <td>${s.nicNumber}</td>
                      <td><span class="badge badge-navy">${s.licenseType}</span></td>
                      <td>
                        <c:choose>
                          <c:when test="${s.status eq 'active'}"><span class="badge badge-success">Active</span></c:when>
                          <c:when test="${s.status eq 'completed'}"><span class="badge badge-info">Completed</span></c:when>
                          <c:when test="${s.status eq 'suspended'}"><span class="badge badge-danger">Suspended</span></c:when>
                          <c:otherwise><span class="badge badge-warning">${s.status}</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <a href="${pageContext.request.contextPath}/admin/students/edit?id=${s.studentId}"
                           class="btn btn-outline btn-sm" style="display:inline-flex;align-items:center;gap:4px;">
                           <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Edit
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/students/delete?id=${s.studentId}"
                           class="btn btn-danger btn-sm" style="display:inline-flex;align-items:center;gap:4px;"
                           onclick="return confirm('Delete this student?')">
                           <svg class="nav-icon-svg" style="width:12px;height:12px;stroke:#fff;" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg> Delete
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
