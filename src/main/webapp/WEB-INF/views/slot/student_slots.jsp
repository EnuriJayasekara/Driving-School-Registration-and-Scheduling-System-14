<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("userId") == null || !"student".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Pick a Lesson &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
    <style>
        .cat-section { margin-top: 1.5rem; }
        .cat-header {
            display: flex; align-items: center; gap: .75rem;
            margin: 0 0 .8rem; padding-bottom: .5rem;
            border-bottom: 2px solid var(--border);
        }
        .cat-header h3 { margin: 0; color: var(--text-main); }
        .slot-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1rem;
        }
        .slot-card {
            background: var(--white); border: 1px solid var(--border); border-radius: 10px;
            padding: 1.25rem; display: flex; flex-direction: column; gap: .5rem;
            transition: transform 0.2s ease, border-color 0.2s ease, box-shadow 0.2s ease;
        }
        .slot-card:hover {
            transform: translateY(-2px);
            border-color: var(--gold);
            box-shadow: 0 4px 12px rgba(196, 155, 85, 0.12);
        }
        .slot-date { font-size: 1.05rem; font-weight: 700; color: var(--text-main); }
        .slot-time { color: var(--gold-light); font-weight: 600; }
        .slot-meta { font-size: .85rem; color: var(--text-muted); display: flex; align-items: center; gap: 0.5rem; }
        .slot-card button { margin-top: .5rem; width: 100%; }
        .empty-state {
            background: var(--white); border: 1px dashed var(--border); border-radius: 10px;
            padding: 2rem; text-align: center; color: var(--text-muted);
        }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">Pick a Lesson</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a> &rsaquo; Pick a Lesson
                </div>
                <h2>Available Lesson Slots</h2>
                <p style="color:var(--text-muted);margin:4px 0 0;">Pick a pre-defined lesson slot or propose a custom date and time below.</p>
            </div>

            <c:if test="${param.error eq 'taken'}">
                <div class="alert alert-danger">Sorry, that slot was just booked by someone else.</div>
            </c:if>
            <c:if test="${param.error eq 'notfound'}">
                <div class="alert alert-danger">That slot is no longer available.</div>
            </c:if>
            <c:if test="${param.error eq 'noinstructors'}">
                <div class="alert alert-danger">No active instructors are available to accept proposals at this time.</div>
            </c:if>
            <c:if test="${param.error eq 'novehicles'}">
                <div class="alert alert-danger">No available vehicles are found for custom scheduling.</div>
            </c:if>
            <c:if test="${param.error eq 'badrequest'}">
                <div class="alert alert-danger">Invalid request. Please try again.</div>
            </c:if>

            <c:choose>
                <c:when test="${empty courseViews}">
                    <div class="empty-state">
                        <h3 style="margin:0 0 .5rem; color:var(--text-main);">No active enrollments</h3>
                        <p>Enroll in a course first to see available lessons.</p>
                        <a href="${pageContext.request.contextPath}/student/enroll" class="btn btn-gold" style="margin-top:1rem;">
                            Browse Courses
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <c:forEach var="view" items="${courseViews}">
                        <div class="cat-section">
                            <div class="cat-header">
                                <span class="badge badge-info">${view.licenseCategory}</span>
                                <h3>${view.courseName}</h3>
                            </div>

                            <c:choose>
                                <c:when test="${empty view.slots}">
                                    <div class="empty-state" style="margin-bottom: 1.5rem;">
                                        No pre-defined open slots for this course right now. Propose a custom date & time below!
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="slot-grid" style="margin-bottom: 1.5rem;">
                                        <c:forEach var="s" items="${view.slots}">
                                            <div class="slot-card">
                                                <div class="slot-date">${s.lessonDate}</div>
                                                <div class="slot-time">${s.timeSlot} &middot; ${s.durationMinutes} mins</div>
                                                <div class="slot-meta">
                                                    <strong>Type:</strong>
                                                    <span class="badge badge-info" style="font-size: 0.75rem;">${s.lessonType}</span>
                                                </div>
                                                <div class="slot-meta">
                                                    <span style="color:var(--gold-light);">Instructor:</span> ${s.instructorName}
                                                </div>
                                                <div class="slot-meta">
                                                    <span style="color:var(--gold-light);">Vehicle:</span> ${s.vehicleInfo}
                                                </div>
                                                <c:if test="${not empty s.notes}">
                                                    <div class="slot-meta" style="font-style:italic;">${s.notes}</div>
                                                </c:if>

                                                <form action="${pageContext.request.contextPath}/student/slots/book" method="post">
                                                    <input type="hidden" name="slotId" value="${s.slotId}">
                                                    <input type="hidden" name="enrollmentId" value="${view.enrollmentId}">
                                                    <button type="submit" class="btn btn-gold">Book This Lesson</button>
                                                </form>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>

                    <!-- Custom Lesson Proposer Card -->
                    <div class="card" style="margin-top: 2.5rem; background: var(--white); border: 1px solid var(--border); border-radius: 10px;">
                        <div class="card-header" style="border-bottom: 1px solid var(--border); padding: 1.25rem 1.5rem;">
                            <h3 style="margin: 0;">Request Custom Lesson Date & Time</h3>
                        </div>
                        <div class="card-body" style="padding: 1.5rem;">
                            <p style="color: var(--text-muted); margin-bottom: 1.5rem; font-size: 0.9rem; line-height: 1.5;">
                                Can't find a lesson slot that works for you? Request a custom date and time, and our admin will assign an active instructor and vehicle to confirm it!
                            </p>
                            <form action="${pageContext.request.contextPath}/student/slots/request" method="post" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.25rem; align-items: flex-end;">
                                <div>
                                    <label style="color: var(--text-muted); display: block; margin-bottom: 0.5rem; font-size: 0.85rem; font-weight: 500;">Select Course</label>
                                    <select name="enrollmentId" class="form-control" required style="width: 100%; background: var(--surface); color: var(--text-main); border: 1px solid var(--border); border-radius: 6px; padding: 10px; height: 42px;">
                                        <c:forEach var="view" items="${courseViews}">
                                            <option value="${view.enrollmentId}">${view.courseName} (${view.licenseCategory})</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div>
                                    <label style="color: var(--text-muted); display: block; margin-bottom: 0.5rem; font-size: 0.85rem; font-weight: 500;">Preferred Date</label>
                                    <input type="date" name="lessonDate" class="form-control" required style="width: 100%; background: var(--surface); color: var(--text-main); border: 1px solid var(--border); border-radius: 6px; padding: 10px; height: 42px;" />
                                </div>
                                <div>
                                    <label style="color: var(--text-muted); display: block; margin-bottom: 0.5rem; font-size: 0.85rem; font-weight: 500;">Preferred Time Slot</label>
                                    <select name="timeSlot" class="form-control" required style="width: 100%; background: var(--surface); color: var(--text-main); border: 1px solid var(--border); border-radius: 6px; padding: 10px; height: 42px;">
                                        <option value="08:00 - 09:00">08:00 AM - 09:00 AM</option>
                                        <option value="09:00 - 10:00">09:00 AM - 10:00 AM</option>
                                        <option value="10:00 - 11:00">10:00 AM - 11:00 AM</option>
                                        <option value="11:00 - 12:00">11:00 AM - 12:00 PM</option>
                                        <option value="13:00 - 14:00">01:00 PM - 02:00 PM</option>
                                        <option value="14:00 - 15:00">02:00 PM - 03:00 PM</option>
                                        <option value="15:00 - 16:00">03:00 PM - 04:00 PM</option>
                                        <option value="16:00 - 17:00">04:00 PM - 05:00 PM</option>
                                    </select>
                                </div>
                                <div>
                                    <label style="color: var(--text-muted); display: block; margin-bottom: 0.5rem; font-size: 0.85rem; font-weight: 500;">Lesson Type</label>
                                    <select name="lessonType" class="form-control" required style="width: 100%; background: var(--surface); color: var(--text-main); border: 1px solid var(--border); border-radius: 6px; padding: 10px; height: 42px;">
                                        <option value="practical">Practical Training</option>
                                        <option value="theory">Theory Session</option>
                                    </select>
                                </div>
                                <div>
                                    <button type="submit" class="btn btn-gold" style="width: 100%; padding: 11px; font-weight: 600; border-radius: 6px; height: 42px;">Request Lesson</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
