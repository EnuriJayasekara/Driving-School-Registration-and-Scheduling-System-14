<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("userId") == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Schedules &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">Schedules</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo; Schedules
                </div>
                <h2>Lesson Schedules</h2>
            </div>

            <c:if test="${param.msg eq 'created'}">
                <div class="alert alert-success">&#10003; Lesson scheduled successfully.</div>
            </c:if>
            <c:if test="${param.msg eq 'updated'}">
                <div class="alert alert-success">&#10003; Schedule updated.</div>
            </c:if>
            <c:if test="${param.msg eq 'rescheduled'}">
                <div class="alert alert-success">&#10003; Lesson reschedule request has been approved successfully.</div>
            </c:if>
            <c:if test="${param.msg eq 'deleted'}">
                <div class="alert alert-success">&#10003; Schedule deleted.</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">&#9888; ${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;">
                    <h3>All Schedules (${schedules.size()})</h3>
                    <a href="${pageContext.request.contextPath}/admin/schedules/new" class="btn btn-primary btn-sm">
                        &#43; Schedule Lesson
                    </a>
                </div>
                <div class="card-body">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Student</th>
                            <th>Course</th>
                            <th>Instructor</th>
                            <th>Vehicle</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Type</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty schedules}">
                                <tr><td colspan="10" style="text-align:center;padding:24px;color:#888;">No lessons scheduled yet.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="sch" items="${schedules}" varStatus="s">
                                    <tr>
                                        <td>${s.count}</td>
                                        <td><strong>${sch.studentName}</strong></td>
                                        <td>${sch.courseName}</td>
                                        <td>${sch.instructorName}</td>
                                        <td>${sch.vehicleInfo}</td>
                                        <td>${sch.lessonDate}</td>
                                        <td>${sch.timeSlot}</td>
                                        <td>
                                            <span class="badge badge-info">${sch.lessonType}</span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${sch.notes != null && sch.notes.contains('PENDING_CONFIRMATION')}">
                                                    <span class="badge badge-warning" style="background:#3B82F6; color:#fff; font-weight:800;">Pending Confirmation</span>
                                                </c:when>
                                                <c:when test="${sch.notes != null && sch.notes.contains('RESCHEDULE_REQUESTED')}">
                                                    <span class="badge badge-warning" style="background:#F59E0B; color:#000; font-weight:800;">Pending Reschedule</span>
                                                </c:when>
                                                <c:when test="${sch.status eq 'scheduled'}"><span class="badge badge-info">Scheduled</span></c:when>
                                                <c:when test="${sch.status eq 'completed'}"><span class="badge badge-success">Completed</span></c:when>
                                                <c:when test="${sch.status eq 'cancelled'}"><span class="badge badge-danger">Cancelled</span></c:when>
                                                <c:when test="${sch.status eq 'no_show'}">  <span class="badge badge-warning">No Show</span></c:when>
                                                <c:otherwise><span class="badge badge-gray">${sch.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="white-space:nowrap; display:flex; align-items:center; gap:4px;">
                                            <c:choose>
                                                <c:when test="${sch.notes != null && sch.notes.contains('PENDING_CONFIRMATION')}">
                                                    <a href="${pageContext.request.contextPath}/admin/schedules/approve-booking?id=${sch.scheduleId}"
                                                       class="btn btn-sm" title="Confirm Booking" 
                                                       style="background:#10B981; color:#fff; border:none; font-weight:800; padding:6px 12px; margin-right:6px; border-radius:6px; display:inline-block; text-decoration:none;">
                                                        &#10003; Confirm
                                                    </a>
                                                </c:when>
                                                <c:when test="${sch.notes != null && sch.notes.contains('RESCHEDULE_REQUESTED')}">
                                                    <a href="${pageContext.request.contextPath}/admin/schedules/approve-reschedule?id=${sch.scheduleId}"
                                                       class="btn btn-sm" title="Approve Reschedule" 
                                                       style="background:#10B981; color:#fff; border:none; font-weight:800; padding:6px 12px; margin-right:6px; border-radius:6px; display:inline-block; text-decoration:none;">
                                                        &#10003; Confirm Reschedule
                                                    </a>
                                                </c:when>
                                            </c:choose>
                                            <a href="${pageContext.request.contextPath}/admin/schedules/edit?id=${sch.scheduleId}"
                                               class="btn btn-outline btn-sm" style="display:inline-flex;align-items:center;" title="Edit">
                                                <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/schedules/delete?id=${sch.scheduleId}"
                                               class="btn btn-danger btn-sm" style="display:inline-flex;align-items:center;" title="Delete"
                                               onclick="return confirm('Delete this lesson?');">
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
