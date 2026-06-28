<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Dashboard – DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
  <jsp:include page="../sidebar.jsp"/>
  <div class="main-content">
    <div class="topbar">
      <span class="topbar-title">My Dashboard</span>
      <div class="topbar-right">
        <div class="avatar-chip">
          <div class="avatar">${sessionScope.loggedUser.fullName.charAt(0)}</div>
          <span class="avatar-name">${sessionScope.loggedUser.fullName}</span>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
      </div>
    </div>

    <div class="page-body">
      <div class="page-header">
        <h2>Welcome, ${sessionScope.loggedUser.fullName}!</h2>
        <p>Track your enrollments and upcoming driving lessons below.</p>
      </div>

      <c:if test="${param.msg eq 'enrolled'}">
        <div class="alert alert-success" style="display:flex; justify-content:space-between; align-items:center;">
          <span>&#10003; Successfully enrolled! Your payment was processed successfully.</span>
          <c:if test="${not empty enrollments}">
             <a href="${pageContext.request.contextPath}/student/invoice?id=${enrollments[0].enrollmentId}" target="_blank" class="btn btn-gold btn-sm" style="margin-left:12px; white-space:nowrap; text-decoration:none;">
                 Print Invoice
             </a>
          </c:if>
        </div>
        
        <!-- Premium Modal Overlay for Automated Invoice -->
        <c:if test="${not empty enrollments}">
            <div id="invoiceModal" style="position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.7); display:flex; justify-content:center; align-items:center; z-index:9999;">
                <div style="background:var(--white); border:1px solid var(--border); border-radius:12px; padding:2rem; max-width:420px; text-align:center; box-shadow:0 12px 40px rgba(0,0,0,0.6); animation: fadeIn 0.3s ease;">
                    <div style="font-size:3rem; color:var(--gold); margin-bottom:1rem;">&#128179;</div>
                    <h3 style="margin:0 0 0.5rem; color:var(--text-main); font-weight:700;">Payment Successful!</h3>
                    <p style="color:var(--text-muted); font-size:0.92rem; margin:0 0 1.5rem; line-height:1.5;">Your card payment was processed securely. Would you like to generate and view your official invoice automatically?</p>
                    <div style="display:flex; gap:12px; justify-content:center;">
                        <a href="${pageContext.request.contextPath}/student/invoice?id=${enrollments[0].enrollmentId}" target="_blank" onclick="document.getElementById('invoiceModal').style.display='none';" class="btn btn-gold" style="text-decoration:none;">
                            Yes, Generate Now
                        </a>
                        <button type="button" onclick="document.getElementById('invoiceModal').style.display='none';" class="btn btn-outline" style="cursor:pointer;">
                            Maybe Later
                        </button>
                    </div>
                </div>
            </div>
        </c:if>
      </c:if>
      <c:if test="${param.msg eq 'reschedule_requested'}">
        <div class="alert alert-success">&#10003; Reschedule requested successfully! The admin will review it.</div>
      </c:if>
      <c:if test="${param.error eq 'invalid_schedule'}">
        <div class="alert alert-danger">&#9888; Invalid schedule or not allowed to reschedule.</div>
      </c:if>

      <!-- Student Profile Card -->
      <c:if test="${not empty student}">
        <div class="card mb-3" style="margin-bottom:24px;">
          <div class="card-header"><h3>My Profile</h3></div>
          <div class="card-body">
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:16px;">
              <div><label style="color:var(--text-muted)">Registration No</label><p style="color:var(--text-main);font-weight:600;color:var(--gold);">${student.studentRegNo}</p></div>
              <div><label style="color:var(--text-muted)">NIC</label><p style="color:var(--text-main);font-weight:500">${student.nicNumber}</p></div>
              <div><label style="color:var(--text-muted)">License Category</label><p style="color:var(--text-main)"><span class="badge badge-navy">${student.licenseType}</span></p></div>
              <div><label style="color:var(--text-muted)">Status</label>
                <c:choose>
                  <c:when test="${student.status eq 'active'}"><span class="badge badge-success">Active</span></c:when>
                  <c:otherwise><span class="badge badge-warning">${student.status}</span></c:otherwise>
                </c:choose>
              </div>
              <div><label style="color:var(--text-muted)">Phone</label><p style="color:var(--text-main)">${sessionScope.loggedUser.phone}</p></div>
            </div>
            
            <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(250px,1fr));gap:16px;margin-top:24px;padding-top:16px;border-top:1px solid var(--border);">
                <div>
                    <label style="color:var(--text-muted)">Assigned Instructors</label>
                    <c:choose>
                        <c:when test="${not empty assignedInstructors}">
                            <ul style="margin:8px 0 0;padding-left:20px;color:var(--text-main)">
                                <c:forEach var="inst" items="${assignedInstructors}">
                                    <li>${inst}</li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise><p style="color:var(--text-muted);font-style:italic">No instructors assigned yet</p></c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <label style="color:var(--text-muted)">Assigned Vehicles</label>
                    <c:choose>
                        <c:when test="${not empty assignedVehicles}">
                            <ul style="margin:8px 0 0;padding-left:20px;color:var(--text-main)">
                                <c:forEach var="veh" items="${assignedVehicles}">
                                    <li>${veh}</li>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise><p style="color:var(--text-muted);font-style:italic">No vehicles assigned yet</p></c:otherwise>
                    </c:choose>
                </div>
            </div>
          </div>
        </div>
      </c:if>

      <!-- Enrollments -->
      <div class="card mb-3" style="margin-bottom:24px;">
        <div class="card-header">
          <h3>My Enrollments</h3>
          <a href="${pageContext.request.contextPath}/student/enroll" class="btn btn-gold btn-sm">&#43; Enroll in Course</a>
        </div>
        <div class="card-body">
          <table class="table">
            <thead>
              <tr><th>Course</th><th>Enrolled On</th><th>Payment</th><th>Amount Paid</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty enrollments}">
                  <tr><td colspan="6" class="text-center" style="padding:30px;color:#64748B">You haven't enrolled in any course yet. <a href="${pageContext.request.contextPath}/student/enroll" style="color:var(--gold)">Browse courses</a></td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="e" items="${enrollments}">
                    <tr>
                      <td><strong>${e.courseName}</strong></td>
                      <td>${e.enrollmentDate}</td>
                      <td>
                        <c:choose>
                          <c:when test="${e.paymentStatus eq 'paid'}"><span class="badge badge-success">Paid</span></c:when>
                          <c:when test="${e.paymentStatus eq 'partial'}"><span class="badge badge-warning">Partial</span></c:when>
                          <c:otherwise><span class="badge badge-danger">Pending</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>LKR ${e.amountPaid}</td>
                      <td><span class="badge badge-${e.status eq 'active' ? 'success' : 'gray'}">${e.status}</span></td>
                      <td>
                        <a href="${pageContext.request.contextPath}/student/invoice?id=${e.enrollmentId}" target="_blank" class="btn btn-outline btn-sm" style="text-decoration:none;">Invoice</a>
                      </td>
                    </tr>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Upcoming Lessons -->
      <div class="card">
        <div class="card-header" style="display:flex; justify-content:space-between; align-items:center;">
          <h3 style="margin:0;">My Upcoming Lessons</h3>
          <a href="${pageContext.request.contextPath}/student/slots" class="btn btn-gold btn-sm">&#43; Book a Lesson</a>
        </div>
        <div class="card-body">
          <table class="table">
            <thead>
              <tr><th>Date</th><th>Time</th><th>Course</th><th>Instructor</th><th>Vehicle</th><th>Type</th><th>Status</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty schedules}">
                  <tr><td colspan="8" class="text-center" style="padding:30px;color:#64748B">No lessons scheduled yet.</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="s" items="${schedules}">
                    <tr>
                      <td>${s.lessonDate}</td>
                      <td>${s.timeSlot}</td>
                      <td>${s.courseName}</td>
                      <td>${s.instructorName}</td>
                      <td>${s.vehicleInfo}</td>
                      <td><span class="badge badge-info">${s.lessonType}</span></td>
                      <td>
                        <c:choose>
                          <c:when test="${s.status eq 'scheduled' && fn:contains(s.notes, 'PENDING_CONFIRMATION')}">
                              <span class="badge badge-warning">Pending Confirmation</span>
                          </c:when>
                          <c:when test="${s.status eq 'scheduled' && fn:contains(s.notes, 'RESCHEDULE_REQUESTED')}">
                              <span class="badge badge-warning">Reschedule Req.</span>
                          </c:when>
                          <c:when test="${s.status eq 'scheduled'}"><span class="badge badge-navy">Scheduled</span></c:when>
                          <c:when test="${s.status eq 'completed'}"><span class="badge badge-success">Completed</span></c:when>
                          <c:when test="${s.status eq 'cancelled'}"><span class="badge badge-danger">Cancelled</span></c:when>
                          <c:otherwise><span class="badge badge-gray">${s.status}</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td>
                        <c:if test="${s.status eq 'scheduled' && !fn:contains(s.notes, 'RESCHEDULE_REQUESTED') && !fn:contains(s.notes, 'PENDING_CONFIRMATION')}">
                            <form action="${pageContext.request.contextPath}/student/dashboard" method="post" style="display:inline-flex; flex-direction:column; gap:8px;" onsubmit="return confirm('Request to reschedule this lesson to the new date and time?');">
                                <input type="hidden" name="action" value="reschedule"/>
                                <input type="hidden" name="scheduleId" value="${s.scheduleId}"/>
                                <div style="display:flex; gap:6px;">
                                    <input type="date" name="newDate" class="form-control" style="padding:4px 8px; font-size:0.8rem; height:auto; width:120px;" required />
                                    <input type="time" name="newTime" class="form-control" style="padding:4px 8px; font-size:0.8rem; height:auto; width:90px;" required />
                                </div>
                                <button type="submit" class="btn btn-outline btn-sm">Reschedule</button>
                            </form>
                        </c:if>
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
