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
    <title>${empty schedule ? 'Schedule Lesson' : 'Edit Schedule'} &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">${empty schedule ? 'Schedule Lesson' : 'Edit Schedule'}</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo;
                    <a href="${pageContext.request.contextPath}/admin/schedules/list">Schedules</a> &rsaquo;
                    ${empty schedule ? 'New' : 'Edit'}
                </div>
                <h2>${empty schedule ? 'Schedule a New Lesson' : 'Edit Lesson Schedule'}</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">&#9888; ${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <h3>${empty schedule ? 'Lesson Details' : 'Update Lesson'}</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/schedules/${empty schedule ? 'new' : 'edit'}" method="post">
                        <c:if test="${not empty schedule}">
                            <input type="hidden" name="scheduleId" value="${schedule.scheduleId}">
                        </c:if>

                        <div class="form-group">
                            <label>Enrollment (Student &amp; Course) *</label>
                            <select name="enrollmentId" class="form-control" required>
                                <option value="">-- Select enrollment --</option>
                                <c:forEach var="en" items="${enrollments}">
                                    <option value="${en.enrollmentId}"
                                        ${schedule.enrollmentId eq en.enrollmentId ? 'selected' : ''}>
                                            ${en.studentName} &mdash; ${en.courseName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Instructor *</label>
                                <select name="instructorId" class="form-control" required>
                                    <option value="">-- Select instructor --</option>
                                    <c:forEach var="ins" items="${instructors}">
                                        <option value="${ins.instructorId}"
                                            ${schedule.instructorId eq ins.instructorId ? 'selected' : ''}>
                                                ${ins.fullName} &ndash; ${ins.formattedSpecialization}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Vehicle *</label>
                                <select name="vehicleId" class="form-control" required>
                                    <option value="">-- Select vehicle --</option>
                                    <c:forEach var="v" items="${vehicles}">
                                        <option value="${v.vehicleId}"
                                            ${schedule.vehicleId eq v.vehicleId ? 'selected' : ''}>
                                                ${v.registrationNo} &ndash; ${v.make} ${v.model} (${v.transmissionType})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-row-3">
                            <div class="form-group">
                                <label>Lesson Date *</label>
                                <input type="date" name="lessonDate" class="form-control"
                                       value="${schedule.lessonDate}" required>
                            </div>
                            <div class="form-group">
                                <label>Time Slot *</label>
                                <input type="time" name="timeSlot" class="form-control"
                                       value="${schedule.timeSlot}" required>
                            </div>
                            <div class="form-group">
                                <label>Duration (minutes) *</label>
                                <input type="number" name="durationMinutes" class="form-control"
                                       value="${empty schedule ? 60 : schedule.durationMinutes}"
                                       required min="30" max="240" step="15" placeholder="60">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Lesson Type *</label>
                                <c:set var="ltype" value="${schedule.lessonType}"/>
                                <select name="lessonType" class="form-control" required>
                                    <option value="practical" ${empty schedule or ltype eq 'practical' ? 'selected' : ''}>Practical</option>
                                    <option value="theory"    ${ltype eq 'theory'    ? 'selected' : ''}>Theory</option>
                                    <option value="test_prep" ${ltype eq 'test_prep' ? 'selected' : ''}>Test Prep</option>
                                    <option value="road_test" ${ltype eq 'road_test' ? 'selected' : ''}>Road Test</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Status</label>
                                <c:set var="sstatus" value="${schedule.status}"/>
                                <select name="status" class="form-control">
                                    <option value="scheduled" ${empty schedule or sstatus eq 'scheduled' ? 'selected' : ''}>Scheduled</option>
                                    <option value="completed" ${sstatus eq 'completed' ? 'selected' : ''}>Completed</option>
                                    <option value="cancelled" ${sstatus eq 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                    <option value="no_show"   ${sstatus eq 'no_show'   ? 'selected' : ''}>No Show</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Notes</label>
                            <textarea name="notes" class="form-control" rows="3"
                                      placeholder="Any special instructions or notes...">${schedule.notes}</textarea>
                        </div>

                        <div class="d-flex gap-2" style="gap:12px;margin-top:8px;">
                            <button type="submit" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;">
                                <c:choose>
                                    <c:when test="${empty schedule}">
                                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg> Schedule Lesson
                                    </c:when>
                                    <c:otherwise>
                                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Update Schedule
                                    </c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/schedules/list" class="btn btn-outline">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
