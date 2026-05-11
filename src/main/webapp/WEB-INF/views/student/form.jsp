<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>${empty student ? 'Add' : 'Edit'} Student – DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
  <jsp:include page="../sidebar.jsp"/>
  <div class="main-content">
    <div class="topbar">
      <span class="topbar-title">${empty student ? 'Add New Student' : 'Edit Student'}</span>
      <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
      </div>
    </div>

    <div class="page-body">
      <div class="page-header">
        <div class="breadcrumb">
          <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo;
          <a href="${pageContext.request.contextPath}/admin/students/list">Students</a> &rsaquo;
          ${empty student ? 'Add New' : 'Edit'}
        </div>
        <h2>${empty student ? 'Add New Student' : 'Edit Student'}</h2>
      </div>

      <c:if test="${not empty error}">
        <div class="alert alert-danger">&#9888; ${error}</div>
      </c:if>

      <div class="card">
        <div class="card-header">
          <h3>${empty student ? 'Student Registration' : 'Update Student Info'}</h3>
        </div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/admin/students/${empty student ? 'new' : 'edit'}" method="post">
            <c:if test="${not empty student}">
              <input type="hidden" name="studentId" value="${student.studentId}">
            </c:if>

            <div class="form-row-3">
              <div class="form-group">
                <label>Registration No *</label>
                <input type="text" name="studentRegNo" class="form-control"
                       value="${student.studentRegNo}" required placeholder="STU-0001">
              </div>
              <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="fullName" class="form-control"
                       value="${student.fullName}" required placeholder="John Silva">
              </div>
              <div class="form-group">
                <label>Phone</label>
                <input type="tel" name="phone" class="form-control"
                       value="${student.phone}" placeholder="07X XXX XXXX">
              </div>
            </div>

            <c:if test="${empty student}">
              <div class="form-row">
                <div class="form-group">
                  <label>Email Address *</label>
                  <input type="email" name="email" class="form-control" required placeholder="student@email.com">
                </div>
                <div class="form-group">
                  <label>Password *</label>
                  <input type="password" name="password" class="form-control" required minlength="6" placeholder="Min 6 characters">
                </div>
              </div>
            </c:if>

            <div class="form-row">
              <div class="form-group">
                <label>NIC Number *</label>
                <input type="text" name="nicNumber" class="form-control"
                       value="${student.nicNumber}" required placeholder="XXXXXXXXXV">
              </div>
              <div class="form-group">
                <label>Date of Birth</label>
                <input type="date" name="dob" class="form-control" value="${student.dob}">
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label>License Category *</label>
                <select name="licenseType" class="form-control" required>
                  <c:set var="licType" value="${student.licenseType}"/>
                  <option value="B"  ${licType eq 'B'  ? 'selected' : ''}>B – Car</option>
                  <option value="A"  ${licType eq 'A'  ? 'selected' : ''}>A – Motor Cycle</option>
                  <option value="A1" ${licType eq 'A1' ? 'selected' : ''}>A1 – Motor Cycle (Small)</option>
                  <option value="B1" ${licType eq 'B1' ? 'selected' : ''}>B1 – Light Vehicle</option>
                  <option value="C"  ${licType eq 'C'  ? 'selected' : ''}>C – Heavy Vehicle</option>
                  <option value="CE" ${licType eq 'CE' ? 'selected' : ''}>CE – Articulated</option>
                  <option value="D"  ${licType eq 'D'  ? 'selected' : ''}>D – Passenger</option>
                </select>
              </div>
              <div class="form-group">
                <label>Status</label>
                <select name="status" class="form-control">
                  <c:set var="st" value="${student.status}"/>
                  <option value="pending"   ${st eq 'pending'   ? 'selected' : ''}>Pending</option>
                  <option value="active"    ${st eq 'active'    ? 'selected' : ''}>Active</option>
                  <option value="completed" ${st eq 'completed' ? 'selected' : ''}>Completed</option>
                  <option value="suspended" ${st eq 'suspended' ? 'selected' : ''}>Suspended</option>
                </select>
              </div>
            </div>

            <div class="form-group">
              <label>Address</label>
              <textarea name="address" class="form-control" rows="3"
                        placeholder="Home address">${student.address}</textarea>
            </div>

            <div class="d-flex gap-2" style="gap:12px;margin-top:8px;">
              <button type="submit" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;">
                <c:choose>
                  <c:when test="${empty student}">
                    <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg> Create Student
                  </c:when>
                  <c:otherwise>
                    <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Update Student
                  </c:otherwise>
                </c:choose>
              </button>
              <a href="${pageContext.request.contextPath}/admin/students/list" class="btn btn-outline">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
