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
    <title>${empty course ? 'Add' : 'Edit'} Course &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">${empty course ? 'Add New Course' : 'Edit Course'}</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo;
                    <a href="${pageContext.request.contextPath}/admin/courses/list">Courses</a> &rsaquo;
                    ${empty course ? 'Add New' : 'Edit'}
                </div>
                <h2>${empty course ? 'Add New Course' : 'Edit Course'}</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">&#9888; ${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <h3>${empty course ? 'Course Details' : 'Update Course Info'}</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/courses/${empty course ? 'new' : 'edit'}" method="post">
                        <c:if test="${not empty course}">
                            <input type="hidden" name="courseId" value="${course.courseId}">
                        </c:if>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Course Name *</label>
                                <input type="text" name="courseName" class="form-control"
                                       value="${course.courseName}" required placeholder="Car Driving (B) Complete Course">
                            </div>
                            <div class="form-group">
                                <label>License Category *</label>
                                <c:set var="cat" value="${course.licenseCategory}"/>
                                <select name="licenseCategory" class="form-control" required>
                                    <option value="">-- Select --</option>
                                    <option value="A1" ${cat eq 'A1' ? 'selected' : ''}>A1 &ndash; Motor Cycle (Small)</option>
                                    <option value="A"  ${cat eq 'A'  ? 'selected' : ''}>A &ndash; Motor Cycle</option>
                                    <option value="B1" ${cat eq 'B1' ? 'selected' : ''}>B1 &ndash; Light Vehicle</option>
                                    <option value="B"  ${cat eq 'B'  ? 'selected' : ''}>B &ndash; Car</option>
                                    <option value="C"  ${cat eq 'C'  ? 'selected' : ''}>C &ndash; Heavy Vehicle</option>
                                    <option value="CE" ${cat eq 'CE' ? 'selected' : ''}>CE &ndash; Articulated</option>
                                    <option value="D"  ${cat eq 'D'  ? 'selected' : ''}>D &ndash; Passenger</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Total Hours *</label>
                                <input type="number" name="totalHours" class="form-control"
                                       value="${empty course ? 20 : course.totalHours}" required min="1" max="200" placeholder="20">
                            </div>
                            <div class="form-group">
                                <label>Price (LKR) *</label>
                                <input type="number" name="price" class="form-control" step="0.01"
                                       value="${course.price}" required min="0" placeholder="25000.00">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Description</label>
                            <textarea name="description" class="form-control" rows="4"
                                      placeholder="Brief description of the course">${course.description}</textarea>
                        </div>

                        <div class="form-group">
                            <label style="display:flex;align-items:center;gap:8px;cursor:pointer;">
                                <input type="checkbox" name="isActive" value="on"
                                ${empty course or course.active ? 'checked' : ''}>
                                <span>Active (visible to students)</span>
                            </label>
                        </div>

                        <div class="d-flex gap-2" style="gap:12px;margin-top:8px;">
                            <button type="submit" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;">
                                <c:choose>
                                    <c:when test="${empty course}">
                                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg> Create Course
                                    </c:when>
                                    <c:otherwise>
                                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Update Course
                                    </c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/courses/list" class="btn btn-outline">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
