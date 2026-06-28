<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Enrollments &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">Enrollments</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo; Enrollments
                </div>
                <h2>Manage Enrollments</h2>
            </div>

            <c:if test="${param.msg eq 'created'}">
                <div class="alert alert-success">&#10003; Enrollment created successfully.</div>
            </c:if>
            <c:if test="${param.msg eq 'updated'}">
                <div class="alert alert-success">&#10003; Enrollment updated successfully.</div>
            </c:if>
            <c:if test="${param.msg eq 'deleted'}">
                <div class="alert alert-success">&#10003; Enrollment deleted.</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">&#9888; ${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header" style="display:flex;justify-content:space-between;align-items:center;">
                    <h3>All Enrollments (${enrollments.size()})</h3>
                    <a href="${pageContext.request.contextPath}/admin/enrollments/new" class="btn btn-primary btn-sm">
                        &#43; Enroll Student
                    </a>
                </div>
                <div class="card-body">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Student</th>
                            <th>Course</th>
                            <th>Enrolled</th>
                            <th>Payment</th>
                            <th>Amount Paid</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${empty enrollments}">
                                <tr><td colspan="8" style="text-align:center;padding:24px;color:#888;">No enrollments yet.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="en" items="${enrollments}" varStatus="s">
                                    <tr>
                                        <td>${s.count}</td>
                                        <td><strong>${en.studentName}</strong></td>
                                        <td>${en.courseName}</td>
                                        <td>${en.enrollmentDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${en.paymentStatus eq 'paid'}">    <span class="badge badge-success">Paid</span></c:when>
                                                <c:when test="${en.paymentStatus eq 'partial'}"> <span class="badge badge-warning">Partial</span></c:when>
                                                <c:when test="${en.paymentStatus eq 'pending'}"> <span class="badge badge-danger">Pending</span></c:when>
                                                <c:when test="${en.paymentStatus eq 'refunded'}"><span class="badge badge-gray">Refunded</span></c:when>
                                                <c:otherwise><span class="badge badge-gray">${en.paymentStatus}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <fmt:formatNumber value="${en.amountPaid}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${en.status eq 'active'}">    <span class="badge badge-success">Active</span></c:when>
                                                <c:when test="${en.status eq 'completed'}"> <span class="badge badge-info">Completed</span></c:when>
                                                <c:when test="${en.status eq 'cancelled'}"> <span class="badge badge-danger">Cancelled</span></c:when>
                                                <c:when test="${en.status eq 'on_hold'}">   <span class="badge badge-warning">On Hold</span></c:when>
                                                <c:otherwise><span class="badge badge-gray">${en.status}</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="white-space:nowrap; display:flex; align-items:center; gap:4px;">
                                            <a href="${pageContext.request.contextPath}/student/invoice?id=${en.enrollmentId}"
                                               target="_blank" class="btn btn-gold btn-sm" style="text-decoration:none; font-weight:600; font-size:0.75rem; padding:4px 8px;" title="View & Print Invoice">
                                                Invoice
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/enrollments/edit?id=${en.enrollmentId}"
                                               class="btn btn-outline btn-sm" style="display:inline-flex;align-items:center;" title="Edit">
                                                <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                            </a>
                                            <a href="${pageContext.request.contextPath}/admin/enrollments/delete?id=${en.enrollmentId}"
                                               class="btn btn-danger btn-sm" style="display:inline-flex;align-items:center;" title="Delete"
                                               onclick="return confirm('Delete this enrollment?');">
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
