<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("userId") == null || !"instructor".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Instructor Dashboard â€” DriveEdu</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0"/>
    <style>
        /* Modal Overlay */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(196, 155, 85, 0.6); /* Primary Navy semi-transparent */
            backdrop-filter: blur(5px);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            transition: opacity 0.3s ease;
        }
        /* Modal Content Box */
        .modal-box {
            background: var(--white);
            border-radius: 14px;
            width: 90%;
            max-width: 750px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            border: 1px solid var(--border);
            animation: slideDown 0.3s ease-out;
        }
        /* Modal Header */
        .modal-box-header {
            padding: 18px 24px;
            background: var(--navy);
            color: var(--gold);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border);
        }
        .modal-box-header h4 {
            margin: 0;
            font-weight: 600;
            font-size: 1.15rem;
            color: var(--gold);
            font-family: 'Poppins', sans-serif;
        }
        .modal-box-close {
            color: var(--white);
            font-size: 1.5rem;
            text-decoration: none;
            font-weight: 300;
            line-height: 1;
            opacity: 0.8;
            transition: opacity 0.2s;
        }
        .modal-box-close:hover {
            opacity: 1;
            color: var(--gold);
        }
        /* Modal Body */
        .modal-box-body {
            padding: 24px;
        }
        @keyframes slideDown {
            from { transform: translateY(-30px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        /* Vehicle Specifications Grid */
        .specs-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }
        .spec-item {
            background: var(--surface);
            padding: 14px 18px;
            border-radius: 10px;
            border: 1px solid var(--border);
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .spec-item:hover {
            border-color: var(--gold);
            box-shadow: 0 0 10px rgba(196, 155, 85, 0.08);
        }
        .spec-label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            font-weight: 600;
            display: block;
            margin-bottom: 6px;
            letter-spacing: 0.05em;
        }
        .spec-value {
            font-size: 1.05rem;
            color: var(--text-main);
            font-weight: 600;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <div class="topbar-left">
                <span class="topbar-title">
                    <svg class="nav-icon-svg" style="margin-right:6px;" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
                    Instructor Overview
                </span>
            </div>
            <div class="topbar-right">
                <div class="avatar-chip">
                    <div class="avatar">${instructor.fullName.charAt(0)}</div>
                    <span class="avatar-name">${instructor.fullName}</span>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <c:set var="currentView" value="${empty param.view ? 'profile' : param.view}" />

            <div class="page-header">
                <c:choose>
                    <c:when test="${currentView eq 'lessons'}">
                        <h2>My Lessons Schedule</h2>
                        <p>Manage your lesson slots, schedule new lessons, and track booked sessions.</p>
                    </c:when>
                    <c:when test="${currentView eq 'edit-lesson'}">
                        <h2>Edit Lesson Schedule</h2>
                        <p>Modify the details of the scheduled driving lesson.</p>
                    </c:when>
                    <c:when test="${currentView eq 'progress'}">
                        <h2>Student Progress Tracker</h2>
                        <p>Track skills and log training progress details for your students.</p>
                    </c:when>
                    <c:otherwise>
                        <h2>Instructor Dashboard</h2>
                        <p>Welcome back, ${instructor.fullName}. Here are your profile details and assignments.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <c:choose>
                <%-- ==================== MY PROFILE VIEW ==================== --%>
                <c:when test="${currentView eq 'profile'}">
                    <!-- Instructor Profile details Card -->
                    <div class="card" style="margin-bottom: 24px; background: var(--white); border: 1px solid var(--border); box-shadow: var(--shadow-sm); border-radius: 12px; overflow: hidden;">
                        <div class="card-header">
                            <h3 style="margin: 0; display: flex; align-items: center; gap: 8px; font-weight: 700;">
                                <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                My Instructor Dashboard
                            </h3>
                            <a href="${pageContext.request.contextPath}/account" class="btn btn-gold btn-sm" style="font-weight: 500;">
                                Change Details
                            </a>
                        </div>
                        <div class="card-body" style="padding: 24px;">
                            <!-- Grid Layout for Profile Info -->
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
                                <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border); transition: border-color 0.2s, box-shadow 0.2s;" onmouseover="this.style.borderColor='var(--gold)'; this.style.boxShadow='0 0 10px rgba(196, 155, 85, 0.08)';" onmouseout="this.style.borderColor='var(--border)'; this.style.boxShadow='none';">
                                    <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 6px; letter-spacing: 0.05em;">Full Name</span>
                                    <span style="font-size: 1.05rem; color: var(--text-main); font-weight: 600;">${instructor.fullName}</span>
                                </div>
                                <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border); transition: border-color 0.2s, box-shadow 0.2s;" onmouseover="this.style.borderColor='var(--gold)'; this.style.boxShadow='0 0 10px rgba(196, 155, 85, 0.08)';" onmouseout="this.style.borderColor='var(--border)'; this.style.boxShadow='none';">
                                    <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 6px; letter-spacing: 0.05em;">License No</span>
                                    <span style="font-size: 1.05rem; color: var(--text-main); font-weight: 600;">${instructor.licenseNo}</span>
                                </div>
                                <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border); transition: border-color 0.2s, box-shadow 0.2s;" onmouseover="this.style.borderColor='var(--gold)'; this.style.boxShadow='0 0 10px rgba(196, 155, 85, 0.08)';" onmouseout="this.style.borderColor='var(--border)'; this.style.boxShadow='none';">
                                    <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 6px; letter-spacing: 0.05em;">Phone</span>
                                    <span style="font-size: 1.05rem; color: var(--text-main); font-weight: 600;">${instructor.phone}</span>
                                </div>
                                <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border); transition: border-color 0.2s, box-shadow 0.2s;" onmouseover="this.style.borderColor='var(--gold)'; this.style.boxShadow='0 0 10px rgba(196, 155, 85, 0.08)';" onmouseout="this.style.borderColor='var(--border)'; this.style.boxShadow='none';">
                                    <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 6px; letter-spacing: 0.05em;">Specialization</span>
                                    <span style="font-size: 1.05rem; color: var(--text-main); font-weight: 600;">${instructor.formattedSpecialization}</span>
                                </div>
                                <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border); transition: border-color 0.2s, box-shadow 0.2s;" onmouseover="this.style.borderColor='var(--gold)'; this.style.boxShadow='0 0 10px rgba(196, 155, 85, 0.08)';" onmouseout="this.style.borderColor='var(--border)'; this.style.boxShadow='none';">
                                    <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 6px; letter-spacing: 0.05em;">Experience</span>
                                    <span style="font-size: 1.05rem; color: var(--text-main); font-weight: 600;">${instructor.experienceYears} Years</span>
                                </div>
                            </div>

                            <!-- Assigned Grid for Students & Vehicles side-by-side -->
                            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; margin-top: 24px;">
                                <!-- Assigned Students Card -->
                                <div class="card" style="background: var(--white); border: 1px solid var(--border); border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-sm);">
                                    <div class="card-header" style="padding: 12px 16px;">
                                        <h3 style="margin: 0; font-size: 0.95rem; display: flex; align-items: center; gap: 8px; font-weight: 700;">
                                            <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                                            Assigned Students Schedule Details
                                        </h3>
                                    </div>
                                    <div class="card-body" style="padding: 16px; overflow-x: auto;">
                                        <c:choose>
                                            <c:when test="${not empty instructorSchedules}">
                                                <table class="data-table" style="width: 100%; font-size: 0.82rem;">
                                                    <thead>
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Student Name</th>
                                                            <th>Date</th>
                                                            <th>Time</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="sch" items="${instructorSchedules}">
                                                            <tr>
                                                                <td>STU-${sch.studentId}</td>
                                                                <td>
                                                                    <a href="${pageContext.request.contextPath}/instructor/dashboard?view=progress&studentId=${sch.studentId}" 
                                                                       style="color: var(--navy); font-weight: 600; text-decoration: none;"
                                                                       onmouseover="this.style.color='var(--gold-light)'" onmouseout="this.style.color='var(--navy)'">
                                                                        ${sch.studentName}
                                                                    </a>
                                                                </td>
                                                                <td>${sch.lessonDate}</td>
                                                                <td><span style="white-space: nowrap;">${sch.timeSlot}</span></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </c:when>
                                            <c:otherwise>
                                                <p style="color: var(--text-muted); font-style: italic; margin: 0; text-align: center; padding: 16px;">No student lessons scheduled yet</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Assigned Vehicles Card -->
                                <div class="card" style="background: var(--white); border: 1px solid var(--border); border-radius: 12px; overflow: hidden; box-shadow: var(--shadow-sm);">
                                    <div class="card-header" style="padding: 12px 16px;">
                                        <h3 style="margin: 0; font-size: 0.95rem; display: flex; align-items: center; gap: 8px; font-weight: 700;">
                                            <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                                            Assigned Vehicles Details &amp; Bookings
                                        </h3>
                                    </div>
                                    <div class="card-body" style="padding: 16px; overflow-x: auto;">
                                        <c:choose>
                                            <c:when test="${not empty instructorSchedules}">
                                                <table class="data-table" style="width: 100%; font-size: 0.82rem;">
                                                    <thead>
                                                        <tr>
                                                            <th>Vehicle Spec</th>
                                                            <th>Date</th>
                                                            <th>Time</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="sch" items="${instructorSchedules}">
                                                            <tr>
                                                                <td>
                                                                    <a href="${pageContext.request.contextPath}/instructor/dashboard?view=vehicle&vehicleId=${sch.vehicleId}" 
                                                                       style="color: var(--navy); font-weight: 600; text-decoration: none;"
                                                                       onmouseover="this.style.color='var(--gold-light)'" onmouseout="this.style.color='var(--navy)'">
                                                                        ${sch.vehicleInfo}
                                                                    </a>
                                                                </td>
                                                                <td>${sch.lessonDate}</td>
                                                                <td><span style="white-space: nowrap;">${sch.timeSlot}</span></td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </c:when>
                                            <c:otherwise>
                                                <p style="color: var(--text-muted); font-style: italic; margin: 0; text-align: center; padding: 16px;">No vehicle bookings scheduled yet</p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:when>

                <%-- ==================== MY LESSONS VIEW ==================== --%>
                <c:when test="${currentView eq 'lessons'}">
                    <!-- Stats Grid with Neon Accents -->
                    <div class="stats-grid" style="margin-bottom: 24px;">
                        <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons&filter=all" 
                           class="stat-card" 
                           style="--accent: #C49B55; text-decoration: none; display: block; color: inherit; transition: transform 0.2s, box-shadow 0.2s;"
                           onmouseover="this.style.transform='translateY(-3px)'; this.style.boxShadow='0 8px 16px rgba(0,0,0,0.06)';"
                           onmouseout="this.style.transform='none'; this.style.boxShadow='none';">
                            <span class="stat-icon" style="color: #C49B55">
                                <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            </span>
                            <div class="stat-value">${totalCount}</div>
                            <div class="stat-label">Total Lessons</div>
                        </a>
                        <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons&filter=upcoming" 
                           class="stat-card" 
                           style="--accent:#3B82F6; text-decoration: none; display: block; color: inherit; transition: transform 0.2s, box-shadow 0.2s;"
                           onmouseover="this.style.transform='translateY(-3px)'; this.style.boxShadow='0 8px 16px rgba(0,0,0,0.06)';"
                           onmouseout="this.style.transform='none'; this.style.boxShadow='none';">
                            <span class="stat-icon" style="color:#3B82F6">
                                <svg class="nav-icon-svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                            </span>
                            <div class="stat-value">${upcomingCount}</div>
                            <div class="stat-label">Upcoming Lessons</div>
                        </a>
                        <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons&filter=completed" 
                           class="stat-card" 
                           style="--accent:#22C55E; text-decoration: none; display: block; color: inherit; transition: transform 0.2s, box-shadow 0.2s;"
                           onmouseover="this.style.transform='translateY(-3px)'; this.style.boxShadow='0 8px 16px rgba(0,0,0,0.06)';"
                           onmouseout="this.style.transform='none'; this.style.boxShadow='none';">
                            <span class="stat-icon" style="color:#22C55E">
                                <svg class="nav-icon-svg" viewBox="0 0 24 24"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            </span>
                            <div class="stat-value">${completedCount}</div>
                            <div class="stat-label">Completed Lessons</div>
                        </a>
                    </div>

                    <!-- My Lessons Schedule CRUD Card -->
                    <div class="table-card" style="margin-top:24px; background: var(--white); border: 1px solid var(--border); box-shadow: var(--shadow-sm); border-radius: 12px; overflow: hidden;">
                        <div class="card-header">
                            <h3 style="margin:0; font-weight: 700;">
                                Lesson Slots &amp; Schedules Management
                                <c:choose>
                                    <c:when test="${activeFilter eq 'upcoming'}">
                                        <span style="color: var(--info); font-size: 0.9rem; font-weight: 500; margin-left: 10px;">(Upcoming)</span>
                                    </c:when>
                                    <c:when test="${activeFilter eq 'completed'}">
                                        <span style="color: var(--success); font-size: 0.9rem; font-weight: 500; margin-left: 10px;">(Completed)</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: var(--text-muted); font-size: 0.9rem; font-weight: 500; margin-left: 10px;">(All)</span>
                                    </c:otherwise>
                                </c:choose>
                            </h3>
                        </div>


                        <!-- Schedules List -->
                        <div style="padding: 0 20px 20px;">
                            <table class="data-table" style="width: 100%;">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Student</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Vehicle</th>
                                        <th>Type</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${empty schedules}">
                                            <tr><td colspan="8" class="empty-state" style="text-align: center; padding: 24px; color: var(--text-muted);">No lessons scheduled yet.</td></tr>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="sch" items="${schedules}" varStatus="s">
                                                <tr>
                                                    <td>${s.count}</td>
                                                    <td><a href="${pageContext.request.contextPath}/instructor/dashboard?view=progress&studentId=${sch.studentId}" style="color: var(--navy); font-weight: 600; text-decoration: none;" onmouseover="this.style.color='var(--gold-light)'" onmouseout="this.style.color='var(--navy)'">${sch.studentName}</a></td>
                                                    <td>${sch.lessonDate}</td>
                                                    <td>${sch.timeSlot}</td>
                                                    <td><a href="${pageContext.request.contextPath}/instructor/dashboard?view=vehicle&vehicleId=${sch.vehicleId}" style="color: var(--navy); font-weight: 600; text-decoration: none;" onmouseover="this.style.color='var(--gold-light)'" onmouseout="this.style.color='var(--navy)'">${sch.vehicleInfo}</a></td>
                                                    <td>
                                                        <span class="badge badge-info" style="text-transform: capitalize;">${sch.lessonType}</span>
                                                    </td>
                                                    <td>
                                                        <span class="badge
                                                            ${sch.status == 'scheduled' ? 'badge-info' :
                                                              sch.status == 'completed' ? 'badge-success' : 'badge-danger'}">
                                                            ${sch.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <div style="display:flex; gap:6px;">
                                                            <a href="${pageContext.request.contextPath}/instructor/dashboard?view=edit-lesson&filter=${activeFilter}&editScheduleId=${sch.scheduleId}" class="btn btn-outline btn-sm" style="padding: 2px 6px;" title="Edit">
                                                                <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                                            </a>
                                                            <form action="${pageContext.request.contextPath}/instructor/dashboard" method="post" style="display:inline;" onsubmit="return confirm('Delete this lesson schedule?');">
                                                                <input type="hidden" name="action" value="deleteSchedule"/>
                                                                <input type="hidden" name="scheduleId" value="${sch.scheduleId}"/>
                                                                <button type="submit" class="btn btn-danger btn-sm" style="padding: 2px 6px;" title="Delete">
                                                                    <svg class="nav-icon-svg" style="width:12px;height:12px;stroke:#fff;" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>

                <%-- ==================== EDIT LESSON VIEW ==================== --%>
                <c:when test="${currentView eq 'edit-lesson'}">
                    <div class="card" style="margin-bottom: 24px; background: var(--white); border: 1px solid var(--border); box-shadow: var(--shadow-sm); border-radius: 12px; overflow: hidden;">
                        <div class="card-header" style="background: var(--navy); color: var(--white); padding: 16px 20px; display: flex; justify-content: space-between; align-items: center;">
                            <h3 style="margin: 0; font-weight: 700; color: var(--white); display: flex; align-items: center; gap: 8px;">
                                <svg class="nav-icon-svg" style="stroke: var(--white); width: 20px; height: 20px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                Edit Lesson Schedule Details
                            </h3>
                            <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons&filter=${activeFilter}" class="btn btn-gold btn-sm" style="font-weight: 500;">
                                Back to Lessons
                            </a>
                        </div>
                        <div class="card-body" style="padding: 24px;">
                            <c:choose>
                                <c:when test="${empty editSchedule}">
                                    <div class="empty-state" style="text-align: center; padding: 24px; color: var(--text-muted);">
                                        <p>No lesson schedule found to edit or you do not have permission to edit it.</p>
                                        <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons" class="btn btn-primary">Back to Lessons</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <form action="${pageContext.request.contextPath}/instructor/dashboard" method="post">
                                        <input type="hidden" name="action" value="updateSchedule"/>
                                        <input type="hidden" name="scheduleId" value="${editSchedule.scheduleId}"/>
                                        
                                        <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap:20px; margin-bottom:20px;">
                                            <div class="form-group">
                                                <label style="color:var(--navy); font-size:0.85rem; font-weight:600; display:block; margin-bottom:6px;">Select Student Enrollment *</label>
                                                <select name="enrollmentId" class="form-control" required style="width: 100%; padding: 10px 14px; border-radius: 6px; border: 1px solid var(--border); background-color: var(--white); color: var(--text-main);">
                                                    <c:forEach var="en" items="${allEnrollments}">
                                                        <option value="${en.enrollmentId}" ${editSchedule.enrollmentId == en.enrollmentId ? 'selected' : ''}>
                                                            ${en.studentName} - ${en.courseName}
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label style="color:var(--navy); font-size:0.85rem; font-weight:600; display:block; margin-bottom:6px;">Select Assigned Vehicle *</label>
                                                <select name="vehicleId" class="form-control" required style="width: 100%; padding: 10px 14px; border-radius: 6px; border: 1px solid var(--border); background-color: var(--white); color: var(--text-main);">
                                                    <c:forEach var="v" items="${allVehicles}">
                                                        <option value="${v.vehicleId}" ${editSchedule.vehicleId == v.vehicleId ? 'selected' : ''}>
                                                            ${v.make} ${v.model} (${v.registrationNo})
                                                        </option>
                                                    </c:forEach>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label style="color:var(--navy); font-size:0.85rem; font-weight:600; display:block; margin-bottom:6px;">Lesson Date *</label>
                                                <input type="date" name="lessonDate" class="form-control" required value="${editSchedule.lessonDate}" style="width: 100%; padding: 10px 14px; border-radius: 6px; border: 1px solid var(--border); background-color: var(--white); color: var(--text-main);"/>
                                            </div>

                                            <div class="form-group">
                                                <label style="color:var(--navy); font-size:0.85rem; font-weight:600; display:block; margin-bottom:6px;">Time Slot *</label>
                                                <select name="timeSlot" class="form-control" required style="width: 100%; padding: 10px 14px; border-radius: 6px; border: 1px solid var(--border); background-color: var(--white); color: var(--text-main);">
                                                    <option value="08:00 - 09:00" ${editSchedule.timeSlot eq '08:00 - 09:00' ? 'selected' : ''}>08:00 - 09:00</option>
                                                    <option value="09:00 - 10:00" ${editSchedule.timeSlot eq '09:00 - 10:00' ? 'selected' : ''}>09:00 - 10:00</option>
                                                    <option value="10:00 - 11:00" ${editSchedule.timeSlot eq '10:00 - 11:00' ? 'selected' : ''}>10:00 - 11:00</option>
                                                    <option value="11:00 - 12:00" ${editSchedule.timeSlot eq '11:00 - 12:00' ? 'selected' : ''}>11:00 - 12:00</option>
                                                    <option value="13:00 - 14:00" ${editSchedule.timeSlot eq '13:00 - 14:00' ? 'selected' : ''}>13:00 - 14:00</option>
                                                    <option value="14:00 - 15:00" ${editSchedule.timeSlot eq '14:00 - 15:00' ? 'selected' : ''}>14:00 - 15:00</option>
                                                    <option value="15:00 - 16:00" ${editSchedule.timeSlot eq '15:00 - 16:00' ? 'selected' : ''}>15:00 - 16:00</option>
                                                    <option value="16:00 - 17:00" ${editSchedule.timeSlot eq '16:00 - 17:00' ? 'selected' : ''}>16:00 - 17:00</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div style="display:grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap:20px; margin-bottom:24px;">
                                            <div class="form-group">
                                                <label style="color:var(--navy); font-size:0.85rem; font-weight:600; display:block; margin-bottom:6px;">Lesson Type *</label>
                                                <select name="lessonType" class="form-control" required style="width: 100%; padding: 10px 14px; border-radius: 6px; border: 1px solid var(--border); background-color: var(--white); color: var(--text-main);">
                                                    <option value="practical" ${editSchedule.lessonType eq 'practical' ? 'selected' : ''}>Practical Driving</option>
                                                    <option value="theory" ${editSchedule.lessonType eq 'theory' ? 'selected' : ''}>Theory Class</option>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label style="color:var(--navy); font-size:0.85rem; font-weight:600; display:block; margin-bottom:6px;">Duration (Minutes)</label>
                                                <input type="number" name="durationMinutes" class="form-control" value="${editSchedule.durationMinutes}" min="15" max="240" style="width: 100%; padding: 10px 14px; border-radius: 6px; border: 1px solid var(--border); background-color: var(--white); color: var(--text-main);"/>
                                            </div>

                                            <div class="form-group">
                                                <label style="color:var(--navy); font-size:0.85rem; font-weight:600; display:block; margin-bottom:6px;">Status *</label>
                                                <select name="status" class="form-control" required style="width: 100%; padding: 10px 14px; border-radius: 6px; border: 1px solid var(--border); background-color: var(--white); color: var(--text-main);">
                                                    <option value="scheduled" ${editSchedule.status eq 'scheduled' ? 'selected' : ''}>Scheduled</option>
                                                    <option value="completed" ${editSchedule.status eq 'completed' ? 'selected' : ''}>Completed</option>
                                                    <option value="cancelled" ${editSchedule.status eq 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label style="color:var(--navy); font-size:0.85rem; font-weight:600; display:block; margin-bottom:6px;">Notes / Special Focus</label>
                                                <input type="text" name="notes" class="form-control" value="${editSchedule.notes}" placeholder="e.g. Focus on reverse parking" style="width: 100%; padding: 10px 14px; border-radius: 6px; border: 1px solid var(--border); background-color: var(--white); color: var(--text-main);"/>
                                            </div>
                                        </div>

                                        <div style="display:flex; gap:12px;">
                                            <button type="submit" class="btn btn-primary" style="padding: 10px 20px; font-weight: 600;">
                                                <svg class="nav-icon-svg" style="width:16px;height:16px;margin-right:6px;stroke:currentColor;fill:none;" viewBox="0 0 24 24"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                                                Save Schedule Changes
                                            </button>
                                            <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons&filter=${activeFilter}" class="btn btn-outline" style="padding: 10px 20px; font-weight: 600;">Cancel</a>
                                        </div>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <%-- ==================== STUDENT PROGRESS VIEW ==================== --%>
                <c:when test="${currentView eq 'progress'}">
                    <c:choose>
                        <c:when test="${not empty selectedStudent}">
                            <!-- Student Profile & General Progress Card -->
                            <div class="card" style="margin-bottom: 24px; border: 1px solid var(--border); background: var(--white); box-shadow: var(--shadow-sm); border-radius: 12px; overflow: hidden;">
                                <div class="card-header">
                                    <h3 style="margin:0; font-weight: 700; display: flex; align-items: center; gap: 8px;">
                                        <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                                        Student Profile Details: ${selectedStudent.fullName}
                                    </h3>
                                    <a href="${pageContext.request.contextPath}/instructor/dashboard?view=profile" class="btn btn-outline btn-sm">Close Tracker</a>
                                </div>
                                
                                <div class="card-body" style="padding: 24px;">
                                    <!-- Profile Fields Grid -->
                                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 16px; margin-bottom: 24px;">
                                        <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border);">
                                            <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 4px;">NIC / ID Number</span>
                                            <span style="font-size: 1rem; color: var(--text-main); font-weight: 600;">${selectedStudent.nicNumber}</span>
                                        </div>
                                        <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border);">
                                            <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 4px;">Email Address</span>
                                            <span style="font-size: 1rem; color: var(--text-main); font-weight: 600; word-break: break-all;">${selectedStudent.email}</span>
                                        </div>
                                        <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border);">
                                            <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 4px;">Phone Number</span>
                                            <span style="font-size: 1rem; color: var(--text-main); font-weight: 600;">${selectedStudent.phone}</span>
                                        </div>
                                        <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border);">
                                            <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 4px;">Target License Type</span>
                                            <span style="font-size: 1rem; color: var(--text-main); font-weight: 600; color: var(--navy);">${selectedStudent.licenseType}</span>
                                        </div>
                                        <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border);">
                                            <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 4px;">Date of Birth</span>
                                            <span style="font-size: 1rem; color: var(--text-main); font-weight: 600;">${selectedStudent.dob}</span>
                                        </div>
                                        <div style="background: var(--surface); padding: 14px 18px; border-radius: 10px; border: 1px solid var(--border);">
                                            <span style="font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; font-weight: 600; display: block; margin-bottom: 4px;">Scheduled Trial Date</span>
                                            <span style="font-size: 1rem; color: var(--text-main); font-weight: 600;">${empty selectedStudent.trialDate ? 'Not Scheduled' : selectedStudent.trialDate}</span>
                                        </div>
                                    </div>

                                    <!-- Diagrammatic Charts Section -->
                                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; margin-bottom: 24px;">
                                        <!-- Lesson Completion Circular gauge -->
                                        <c:set var="completedCount" value="${studentCompletedLessons.size()}" />
                                        <c:set var="upcomingCount" value="${studentUpcomingLessons.size()}" />
                                        <c:set var="totalLessons" value="${completedCount + upcomingCount}" />
                                        <c:set var="completionRate" value="${totalLessons gt 0 ? (completedCount * 100 / totalLessons) : 0}" />
                                        
                                        <div style="display: flex; flex-direction: column; align-items: center; justify-content: center; background: var(--surface); padding: 24px; border-radius: 12px; border: 1px solid var(--border); text-align: center; box-shadow: inset 0 0 10px rgba(0,0,0,0.02);">
                                            <h4 style="margin: 0 0 20px; color: var(--navy); font-weight: 600; font-size: 1rem;">Syllabus Lesson Completion</h4>
                                            <div style="position: relative; width: 140px; height: 140px; display: flex; align-items: center; justify-content: center;">
                                                <svg style="transform: rotate(-90deg); width: 140px; height: 140px;">
                                                    <circle cx="70" cy="70" r="55" stroke="var(--border)" stroke-width="12" fill="transparent" />
                                                    <circle cx="70" cy="70" r="55" stroke="var(--gold)" stroke-width="12" fill="transparent" 
                                                            stroke-dasharray="345.5" stroke-dashoffset="${345.5 - (345.5 * completionRate / 100)}" 
                                                            style="transition: stroke-dashoffset 0.8s ease-in-out;" />
                                                </svg>
                                                <div style="position: absolute; font-size: 1.7rem; font-weight: 700; color: var(--navy);">${completionRate}%</div>
                                            </div>
                                            <span style="font-size: 0.88rem; color: var(--text-muted); margin-top: 16px; font-weight: 500;">
                                                Finished <strong style="color: var(--navy);">${completedCount}</strong> of <strong style="color: var(--navy);">${totalLessons}</strong> Booked Lessons
                                            </span>
                                        </div>

                                        <!-- Skills Mastery progress bar chart -->
                                        <div style="background: var(--surface); padding: 24px; border-radius: 12px; border: 1px solid var(--border); box-shadow: inset 0 0 10px rgba(0,0,0,0.02); display: flex; flex-direction: column; justify-content: space-between;">
                                            <h4 style="margin: 0 0 16px; color: var(--navy); font-weight: 600; font-size: 1rem;">Evaluated Skills Level Matrix</h4>
                                            <c:choose>
                                                <c:when test="${not empty studentProgressList}">
                                                    <div style="display: flex; flex-direction: column; gap: 14px; flex-grow: 1; justify-content: center;">
                                                        <c:forEach var="p" items="${studentProgressList}" varStatus="loop">
                                                            <c:if test="${loop.index lt 4}"> <%-- Limit to top 4 skills to prevent overflow --%>
                                                                <c:set var="pct" value="${p.achievement eq 'Excellent' ? 100 : p.achievement eq 'Satisfactory' ? 70 : 35}" />
                                                                <c:set var="barColor" value="${p.achievement eq 'Excellent' ? '#22C55E' : p.achievement eq 'Satisfactory' ? '#3B82F6' : '#EF4444'}" />
                                                                <div>
                                                                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; font-weight: 600; color: var(--text-main); margin-bottom: 4px;">
                                                                        <span>${p.topic}</span>
                                                                        <span style="color: ${barColor}">${p.achievement}</span>
                                                                    </div>
                                                                    <div style="width: 100%; height: 8px; background: rgba(0,0,0,0.05); border-radius: 4px; overflow: hidden;">
                                                                        <div style="width: ${pct}%; height: 100%; background: ${barColor}; border-radius: 4px; transition: width 0.5s;"></div>
                                                                    </div>
                                                                </div>
                                                            </c:if>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <p style="color: var(--text-muted); font-style: italic; text-align: center; margin: auto;">No skills evaluated yet.</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>

                                    <!-- Side-by-Side Completed and Upcoming Lessons Tables -->
                                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 24px; margin-bottom: 24px;">
                                        <!-- Completed Lessons Table -->
                                        <div class="card" style="background: var(--white); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; box-shadow: var(--shadow-sm);">
                                            <div class="card-header" style="padding: 12px 16px; color: var(--charcoal); font-weight: 700; font-size: 0.9rem;">
                                                Lessons Taken (Completed History)
                                            </div>
                                            <div style="padding: 12px; max-height: 250px; overflow-y: auto;">
                                                <c:choose>
                                                    <c:when test="${not empty studentCompletedLessons}">
                                                        <table style="width: 100%; border-collapse: collapse; font-size: 0.82rem;" class="data-table">
                                                            <thead>
                                                                <tr>
                                                                    <th>Date</th>
                                                                    <th>Time</th>
                                                                    <th>Type</th>
                                                                    <th>Notes</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="cl" items="${studentCompletedLessons}">
                                                                    <tr>
                                                                        <td><strong>${cl.lessonDate}</strong></td>
                                                                        <td>${cl.timeSlot}</td>
                                                                        <td><span class="badge badge-success" style="font-size: 0.68rem; padding: 2px 5px;">${cl.lessonType}</span></td>
                                                                        <td style="color: var(--text-muted); font-size:0.78rem;">${cl.notes}</td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p style="color: var(--text-muted); font-style: italic; text-align: center; margin: 20px 0; font-size: 0.85rem;">No completed lessons yet.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>

                                        <!-- Upcoming Lessons Table -->
                                        <div class="card" style="background: var(--white); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; box-shadow: var(--shadow-sm);">
                                            <div class="card-header" style="padding: 12px 16px; color: var(--charcoal); font-weight: 700; font-size: 0.9rem;">
                                                Upcoming Booked Lessons
                                            </div>
                                            <div style="padding: 12px; max-height: 250px; overflow-y: auto;">
                                                <c:choose>
                                                    <c:when test="${not empty studentUpcomingLessons}">
                                                        <table style="width: 100%; border-collapse: collapse; font-size: 0.82rem;" class="data-table">
                                                            <thead>
                                                                <tr>
                                                                    <th>Date</th>
                                                                    <th>Time</th>
                                                                    <th>Type</th>
                                                                    <th>Notes</th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>
                                                                <c:forEach var="ul" items="${studentUpcomingLessons}">
                                                                    <tr>
                                                                        <td><strong>${ul.lessonDate}</strong></td>
                                                                        <td>${ul.timeSlot}</td>
                                                                        <td><span class="badge badge-info" style="font-size: 0.68rem; padding: 2px 5px;">${ul.lessonType}</span></td>
                                                                        <td style="color: var(--text-muted); font-size:0.78rem;">${ul.notes}</td>
                                                                    </tr>
                                                                </c:forEach>
                                                            </tbody>
                                                        </table>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <p style="color: var(--text-muted); font-style: italic; text-align: center; margin: 20px 0; font-size: 0.85rem;">No upcoming lessons booked.</p>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Skills Logger Form and Log History -->
                                    <div style="border-top: 1px solid var(--border); padding-top: 24px; display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 24px;">
                                        <!-- Form Block -->
                                        <div style="background:var(--surface); padding:20px; border-radius:10px; border:1px solid var(--border);">
                                            <h4 style="margin:0 0 16px 0; color:var(--navy); font-family:'Poppins',sans-serif; font-weight: 600;">
                                                ${empty editProgress ? 'Add New Progress Record' : 'Edit Progress Record'}
                                            </h4>
                                            <form action="${pageContext.request.contextPath}/instructor/dashboard" method="post">
                                                <input type="hidden" name="action" value="${empty editProgress ? 'createProgress' : 'updateProgress'}"/>
                                                <input type="hidden" name="studentId" value="${selectedStudent.studentId}"/>
                                                <c:if test="${not empty editProgress}">
                                                    <input type="hidden" name="progressId" value="${editProgress.progressId}"/>
                                                </c:if>
                                                
                                                <div class="form-group" style="margin-bottom:14px;">
                                                    <label style="color:var(--text-muted); font-size:0.85rem; font-weight:500; display:block; margin-bottom:6px;">Training Topic / Skill *</label>
                                                    <input type="text" name="topic" value="${editProgress.topic}" class="form-control" required placeholder="e.g. Reverse parking, Clutch control, Lane changing" style="width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid var(--border);"/>
                                                </div>
                                                
                                                <div class="form-group" style="margin-bottom:14px;">
                                                    <label style="color:var(--text-muted); font-size:0.85rem; font-weight:500; display:block; margin-bottom:6px;">Achievement Level</label>
                                                    <select name="achievement" class="form-control" style="width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid var(--border);">
                                                        <option value="Excellent" ${editProgress.achievement eq 'Excellent' ? 'selected' : ''}>Excellent</option>
                                                        <option value="Satisfactory" ${editProgress.achievement eq 'Satisfactory' ? 'selected' : ''}>Satisfactory</option>
                                                        <option value="Needs Improvement" ${editProgress.achievement eq 'Needs Improvement' ? 'selected' : ''}>Needs Improvement</option>
                                                    </select>
                                                </div>
                                                
                                                <div class="form-group" style="margin-bottom:20px;">
                                                    <label style="color:var(--text-muted); font-size:0.85rem; font-weight:500; display:block; margin-bottom:6px;">Remarks / Comments</label>
                                                    <textarea name="comments" class="form-control" rows="3" placeholder="Describe execution, mistakes, or key strengths..." required style="width: 100%; padding: 8px 12px; border-radius: 6px; border: 1px solid var(--border); resize:vertical; min-height:80px;">${editProgress.comments}</textarea>
                                                </div>
                                                
                                                <div style="display:flex; gap:10px;">
                                                     <button type="submit" class="btn btn-gold btn-sm">
                                                         <c:choose>
                                                             <c:when test="${empty editProgress}">
                                                                 <svg class="nav-icon-svg" style="width:12px;height:12px;margin-right:4px;" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg> Add Record
                                                             </c:when>
                                                             <c:otherwise>
                                                                 <svg class="nav-icon-svg" style="width:12px;height:12px;margin-right:4px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Save Changes
                                                             </c:otherwise>
                                                         </c:choose>
                                                     </button>
                                                    <c:if test="${not empty editProgress}">
                                                        <a href="${pageContext.request.contextPath}/instructor/dashboard?view=progress&studentId=${selectedStudent.studentId}" class="btn btn-outline btn-sm">Cancel Edit</a>
                                                    </c:if>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- Log History -->
                                        <div>
                                            <h4 style="margin:0 0 16px 0; color:var(--navy); font-family:'Poppins',sans-serif; font-weight: 600;">Skill Assessment Log History</h4>
                                            <div class="table-wrapper" style="max-height: 300px; overflow-y: auto; border: 1px solid var(--border); border-radius: 8px;">
                                                <table style="width:100%; border-collapse:collapse;" class="data-table">
                                                    <thead>
                                                        <tr>
                                                            <th>Skill Topic</th>
                                                            <th>Level</th>
                                                            <th>Comments</th>
                                                            <th>Actions</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:choose>
                                                            <c:when test="${empty studentProgressList}">
                                                                <tr>
                                                                    <td colspan="4" style="text-align:center; padding:30px; color:var(--text-muted); font-style:italic;">
                                                                        No progress logs entered yet.
                                                                    </td>
                                                                </tr>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <c:forEach var="p" items="${studentProgressList}">
                                                                    <tr>
                                                                        <td><strong>${p.topic}</strong></td>
                                                                        <td>
                                                                            <span class="badge ${p.achievement eq 'Excellent' ? 'badge-success' : p.achievement eq 'Satisfactory' ? 'badge-info' : 'badge-danger'}">
                                                                                ${p.achievement}
                                                                            </span>
                                                                        </td>
                                                                        <td style="font-size:0.85rem; color:var(--text-muted);">${p.comments}</td>
                                                                        <td>
                                                                            <div style="display:flex; gap:6px;">
                                                                                <a href="${pageContext.request.contextPath}/instructor/dashboard?view=progress&studentId=${selectedStudent.studentId}&editProgressId=${p.progressId}" class="btn btn-outline btn-sm" style="padding: 2px 6px;" title="Edit">
                                                                                    <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                                                                                </a>
                                                                                <form action="${pageContext.request.contextPath}/instructor/dashboard" method="post" style="display:inline;" onsubmit="return confirm('Delete this progress record?');">
                                                                                    <input type="hidden" name="action" value="deleteProgress"/>
                                                                                    <input type="hidden" name="progressId" value="${p.progressId}"/>
                                                                                    <input type="hidden" name="studentId" value="${selectedStudent.studentId}"/>
                                                                                    <button type="submit" class="btn btn-danger btn-sm" style="padding: 2px 6px;" title="Delete">
                                                                                        <svg class="nav-icon-svg" style="width:12px;height:12px;stroke:#fff;" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                                                                                    </button>
                                                                                </form>
                                                                            </div>
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
                        </c:when>
                        <c:otherwise>
                            <div class="card" style="padding: 40px; text-align: center; background: var(--white); border: 1px solid var(--border); border-radius: 12px; box-shadow: var(--shadow-sm);">
                                <h3 style="color: var(--navy); margin-bottom: 12px; font-weight: 600;">No Student Selected</h3>
                                <p style="color: var(--text-muted); margin-bottom: 20px;">Please select one of your assigned students from the profile page to manage their training progress records.</p>
                                <a href="${pageContext.request.contextPath}/instructor/dashboard?view=profile" class="btn btn-gold" style="display: inline-block;">Go to My Profile</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <%-- ==================== VEHICLE DETAILS VIEW ==================== --%>
                <c:when test="${currentView eq 'vehicle'}">
                    <c:choose>
                        <c:when test="${not empty selectedVehicle}">
                            <!-- Vehicle Spec details Card -->
                            <div class="card" style="margin-bottom: 24px; background: var(--white); border: 1px solid var(--border); box-shadow: var(--shadow-sm); border-radius: 12px; overflow: hidden;">
                                <div class="card-header">
                                    <h3 style="margin: 0; display: flex; align-items: center; gap: 8px; font-weight: 700;">
                                        <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                                        Vehicle Specifications: ${selectedVehicle.make} ${selectedVehicle.model}
                                    </h3>
                                    <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons" class="btn btn-gold btn-sm" style="font-weight: 500;">
                                        Back to Lessons
                                    </a>
                                </div>
                                <div class="card-body" style="padding: 24px;">
                                    <!-- Specifications Grid -->
                                    <div class="specs-grid">
                                        <div class="spec-item">
                                            <span class="spec-label">Make &amp; Model</span>
                                            <span class="spec-value">${selectedVehicle.make} ${selectedVehicle.model}</span>
                                        </div>
                                        <div class="spec-item">
                                            <span class="spec-label">Registration No</span>
                                            <span class="spec-value">${selectedVehicle.registrationNo}</span>
                                        </div>
                                        <div class="spec-item">
                                            <span class="spec-label">Year of Manufacture</span>
                                            <span class="spec-value">${selectedVehicle.year}</span>
                                        </div>
                                        <div class="spec-item">
                                            <span class="spec-label">Transmission</span>
                                            <span class="spec-value" style="text-transform: capitalize;">${selectedVehicle.transmissionType}</span>
                                        </div>
                                        <div class="spec-item">
                                            <span class="spec-label">Fuel Type</span>
                                            <span class="spec-value" style="text-transform: capitalize;">${selectedVehicle.fuelType}</span>
                                        </div>
                                        <div class="spec-item">
                                            <span class="spec-label">Seating Capacity</span>
                                            <span class="spec-value">${selectedVehicle.seatingCapacity} Persons</span>
                                        </div>
                                        <div class="spec-item">
                                            <span class="spec-label">Vehicle Class / Category</span>
                                            <span class="spec-value" style="text-transform: uppercase;">${selectedVehicle.category}</span>
                                        </div>
                                        <div class="spec-item">
                                            <span class="spec-label">Status</span>
                                            <span class="spec-value">
                                                <span class="badge ${selectedVehicle.status eq 'available' ? 'badge-success' : 'badge-danger'}" style="text-transform: capitalize;">
                                                    ${selectedVehicle.status}
                                                </span>
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Vehicle Bookings Section -->
                                    <div class="card" style="background: var(--white); border: 1px solid var(--border); border-radius: 10px; overflow: hidden; box-shadow: var(--shadow-sm); margin-top: 24px;">
                                        <div class="card-header" style="padding: 12px 16px; color: var(--charcoal); font-weight: 700; font-size: 0.95rem; display: flex; align-items: center; gap: 8px;">
                                            <svg class="nav-icon-svg" viewBox="0 0 24 24" style="width:16px;height:16px;"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                                            Complete Booking &amp; Lesson Schedule
                                        </div>
                                        <div style="padding: 16px; overflow-x: auto;">
                                            <table class="data-table" style="width: 100%;">
                                                <thead>
                                                    <tr>
                                                        <th>Date</th>
                                                        <th>Time Slot</th>
                                                        <th>Lesson Type</th>
                                                        <th>Student Name</th>
                                                        <th>Instructor Name</th>
                                                        <th>Status</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:choose>
                                                        <c:when test="${empty vehicleSchedules}">
                                                            <tr>
                                                                <td colspan="6" class="empty-state" style="text-align: center; padding: 24px; color: var(--text-muted);">
                                                                    No lessons or bookings scheduled for this vehicle.
                                                                </td>
                                                            </tr>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:forEach var="vsch" items="${vehicleSchedules}">
                                                                <tr>
                                                                    <td><strong>${vsch.lessonDate}</strong></td>
                                                                    <td>${vsch.timeSlot}</td>
                                                                    <td>
                                                                        <span class="badge badge-info" style="text-transform: capitalize;">${vsch.lessonType}</span>
                                                                    </td>
                                                                    <td>
                                                                        <a href="${pageContext.request.contextPath}/instructor/dashboard?view=progress&studentId=${vsch.studentId}" style="color: var(--navy); font-weight: 600; text-decoration: none;" onmouseover="this.style.color='var(--gold-light)'" onmouseout="this.style.color='var(--navy)'">
                                                                            ${vsch.studentName}
                                                                        </a>
                                                                    </td>
                                                                    <td>${vsch.instructorName}</td>
                                                                    <td>
                                                                        <span class="badge ${vsch.status eq 'scheduled' ? 'badge-info' : vsch.status eq 'completed' ? 'badge-success' : 'badge-danger'}">
                                                                            ${vsch.status}
                                                                        </span>
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
                        </c:when>
                        <c:otherwise>
                            <div class="card" style="padding: 40px; text-align: center; background: var(--white); border: 1px solid var(--border); border-radius: 12px; box-shadow: var(--shadow-sm);">
                                <h3 style="color: var(--navy); margin-bottom: 12px; font-weight: 600;">No Vehicle Selected</h3>
                                <p style="color: var(--text-muted); margin-bottom: 20px;">Please select a vehicle from the lessons list to view its details and bookings.</p>
                                <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons" class="btn btn-gold" style="display: inline-block;">Go to Lessons</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:when>
            </c:choose>
        </div>
    </div>
<script>
function toggleScheduleForm() {
    var f = document.getElementById('scheduleFormWrapper');
    if (f.style.display === 'none') {
        f.style.display = 'block';
        f.scrollIntoView({ behavior: 'smooth' });
    } else {
        f.style.display = 'none';
    }
}
</script>
</body>
</html>
