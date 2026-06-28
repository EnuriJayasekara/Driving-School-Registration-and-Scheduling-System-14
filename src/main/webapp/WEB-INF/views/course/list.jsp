<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Courses — DriveEdu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700&family=DM+Sans:wght@300;400;500;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0"/>
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">
                <svg class="nav-icon-svg" style="margin-right:6px;" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
                Courses
            </span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header d-flex justify-between align-center">
                <div>
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo; Courses
                    </div>
                    <h2>Course Management</h2>
                    <p style="color:var(--text-muted);margin:4px 0 0;">Manage driving course catalogue</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/courses/new" class="btn btn-primary">&#43; Add Course</a>
            </div>

            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <h3>All Courses (${courses.size()})</h3>
                </div>
                <div class="card-body">
                    <table class="table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Course Name</th>
                            <th>Category</th>
                            <th>Duration</th>
                            <th>Fee (LKR)</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty courses}">
                                <tr><td colspan="7" class="empty-state">No courses found. Add your first course.</td></tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="course" items="${courses}" varStatus="s">
                                    <tr>
                                        <td>${s.count}</td>
                                        <td><strong>${course.courseName}</strong></td>
                                        <td>
                                            <span class="badge badge-info">${course.licenseCategory}</span>
                                        </td>
                                        <td>${course.totalHours} hrs</td>
                                        <td><fmt:formatNumber value="${course.price}" type="number" minFractionDigits="2"/></td>
                                        <td>
                                            <span class="badge ${course.active ? 'badge-success' : 'badge-warning'}">
                                                ${course.active ? 'active' : 'inactive'}
                                            </span>
                                        </td>
                                        <td class="action-cell">
                                            <a href="${pageContext.request.contextPath}/admin/courses/edit?id=${course.courseId}" class="btn-icon btn-edit" title="Edit">
                                                <svg class="nav-icon-svg" style="width:14px;height:14px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                            </a>
                                            <form action="${pageContext.request.contextPath}/admin/courses/delete" method="post" style="display:inline"
                                                  onsubmit="return confirm('Delete this course?')">
                                                <input type="hidden" name="action" value="delete"/>
                                                <input type="hidden" name="id" value="${course.courseId}"/>
                                                <button type="submit" class="btn-icon btn-delete" title="Delete">
                                                    <svg class="nav-icon-svg" style="width:14px;height:14px;" viewBox="0 0 24 24"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path><line x1="10" y1="11" x2="10" y2="17"></line><line x1="14" y1="11" x2="14" y2="17"></line></svg>
                                                </button>
                                            </form>
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
