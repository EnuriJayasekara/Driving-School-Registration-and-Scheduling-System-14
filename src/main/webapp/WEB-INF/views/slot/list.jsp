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
    <title>Open Slots &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">Open Lesson Slots</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo; Open Slots
                </div>
                <h2>Lesson Slots</h2>
                <p style="color:#777;margin:4px 0 0;">Create open slots that students can pick from.</p>
            </div>

            <c:if test="${param.msg eq 'created'}">
                <div class="alert alert-success">&#10003; Slot created.</div>
            </c:if>
            <c:if test="${param.msg eq 'deleted'}">
                <div class="alert alert-success">&#10003; Slot deleted.</div>
            </c:if>

            <div class="card">
                <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;">
                    <h3>All Slots (${slots.size()})</h3>
                    <a href="${pageContext.request.contextPath}/admin/slots/new" class="btn btn-primary btn-sm">
                        &#43; Create Slot
                    </a>
                </div>
                <div class="card-body">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>#</th><th>Category</th><th>Type</th>
                            <th>Date</th><th>Time</th><th>Duration</th>
                            <th>Instructor</th><th>Vehicle</th>
                            <th>Status</th><th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty slots}">
                                <tr><td colspan="10" style="text-align:center;padding:24px;color:#888;">No slots yet.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="s" items="${slots}" varStatus="vs">
                                    <tr>
                                        <td>${vs.count}</td>
                                        <td><span class="badge badge-info">${s.licenseCategory}</span></td>
                                        <td>${s.lessonType}</td>
                                        <td>${s.lessonDate}</td>
                                        <td>${s.timeSlot}</td>
                                        <td>${s.durationMinutes} min</td>
                                        <td>${s.instructorName}</td>
                                        <td>${s.vehicleInfo}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${s.status eq 'open'}">     <span class="badge badge-success">Open</span></c:when>
                                                <c:when test="${s.status eq 'booked'}">   <span class="badge badge-warning">Booked</span></c:when>
                                                <c:when test="${s.status eq 'cancelled'}"><span class="badge badge-danger">Cancelled</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${s.status eq 'open'}">
                                                <a href="${pageContext.request.contextPath}/admin/slots/delete?id=${s.slotId}"
                                                   class="btn btn-danger btn-sm" style="display:inline-flex;align-items:center;"
                                                   onclick="return confirm('Delete this slot?');" title="Delete">
                                                    <svg class="nav-icon-svg" style="width:12px;height:12px;stroke:#fff;" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                                </a>
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
