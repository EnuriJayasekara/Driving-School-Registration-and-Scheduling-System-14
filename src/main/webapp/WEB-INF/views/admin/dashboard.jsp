<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title>Admin Dashboard – DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
  <jsp:include page="../sidebar.jsp"/>

  <div class="main-content">
    <div class="topbar">
      <span class="topbar-title">
        <svg class="nav-icon-svg" style="margin-right:6px;" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg>
        Dashboard Overview
      </span>
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
        <h2>Dashboard</h2>
        <p>Welcome back, ${sessionScope.loggedUser.fullName}. Here's what's happening today.</p>
      </div>

      <c:if test="${param.msg eq 'alert_sent'}">
        <div class="alert alert-success" style="margin-bottom:24px;">&#10003; Notification alert sent successfully to recipient!</div>
      </c:if>

      <!-- Stats Grid -->
      <div class="stats-grid">
        <div class="stat-card" style="--accent:#C9A84C">
          <span class="stat-icon" style="color:#C9A84C">
            <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
          </span>
          <div class="stat-value">${totalStudents}</div>
          <div class="stat-label">Total Students</div>
        </div>
        <div class="stat-card" style="--accent:#2DD4BF">
          <span class="stat-icon" style="color:#2DD4BF">
            <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg>
          </span>
          <div class="stat-value">${totalInstructors}</div>
          <div class="stat-label">Instructors</div>
        </div>
        <div class="stat-card" style="--accent:#3B82F6">
          <span class="stat-icon" style="color:#3B82F6">
            <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
          </span>
          <div class="stat-value">${totalVehicles}</div>
          <div class="stat-label">Vehicles</div>
        </div>
        <div class="stat-card" style="--accent:#22C55E">
          <span class="stat-icon" style="color:#22C55E">
            <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg>
          </span>
          <div class="stat-value">${totalCourses}</div>
          <div class="stat-label">Active Courses</div>
        </div>
        <div class="stat-card" style="--accent:#F59E0B">
          <span class="stat-icon" style="color:#F59E0B">
            <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect></svg>
          </span>
          <div class="stat-value">${activeEnrollments}</div>
          <div class="stat-label">Active Enrollments</div>
        </div>
        <div class="stat-card" style="--accent:#EF4444">
          <span class="stat-icon" style="color:#EF4444">
            <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
          </span>
          <div class="stat-value">${upcomingLessons}</div>
          <div class="stat-label">Upcoming Lessons</div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="card">
        <div class="card-header"><h3>Quick Actions</h3></div>
        <div class="card-body">
          <div style="display:flex;flex-wrap:wrap;gap:12px;">
            <a href="${pageContext.request.contextPath}/admin/students/new"    class="btn btn-primary">&#43; Add Student</a>
            <a href="${pageContext.request.contextPath}/admin/instructors/new" class="btn btn-primary">&#43; Add Instructor</a>
            <a href="${pageContext.request.contextPath}/admin/vehicles/new"    class="btn btn-primary">&#43; Add Vehicle</a>
            <a href="${pageContext.request.contextPath}/admin/courses/new"     class="btn btn-primary">&#43; Add Course</a>
            <a href="${pageContext.request.contextPath}/admin/enrollments/new" class="btn btn-gold">&#43; Enroll Student</a>
            <a href="${pageContext.request.contextPath}/admin/schedules/new"   class="btn btn-gold">&#43; Schedule Lesson</a>
          </div>
        </div>
      </div>

      <!-- Manual Notification Form -->
      <div class="card" style="margin-top:24px;">
        <div class="card-header">
          <h3 style="display:flex; align-items:center; gap:8px;">
            <svg class="nav-icon-svg" viewBox="0 0 24 24" style="width:20px; height:20px; fill:none; stroke:var(--gold); stroke-width:2;"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
            Send Custom Notification Alert
          </h3>
        </div>
        <div class="card-body">
          <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" style="display:flex; flex-direction:column; gap:16px;">
            <input type="hidden" name="action" value="sendNotification" />
            
            <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px;">
              <div class="form-group" style="margin:0;">
                <label style="color:var(--text-muted); font-size:0.9rem; margin-bottom:6px; display:block;">Select Recipient *</label>
                <select name="targetUserId" class="form-control" required style="background:var(--surface); color:var(--text-main); border:1px solid var(--border); width:100%; box-sizing:border-box; height:42px;">
                  <option value="">-- Choose User --</option>
                  <c:forEach var="u" items="${usersList}">
                    <c:if test="${u.active}">
                      <option value="${u.userId}">${u.fullName} (${u.role})</option>
                    </c:if>
                  </c:forEach>
                </select>
              </div>
              <div class="form-group" style="margin:0;">
                <label style="color:var(--text-muted); font-size:0.9rem; margin-bottom:6px; display:block;">Alert Level / Style *</label>
                <select name="type" class="form-control" required style="background:var(--surface); color:var(--text-main); border:1px solid var(--border); width:100%; box-sizing:border-box; height:42px;">
                  <option value="info">Info (Blue border)</option>
                  <option value="success">Success (Green border)</option>
                  <option value="warning">Warning (Orange border)</option>
                  <option value="reminder">Reminder (Gold border)</option>
                </select>
              </div>
            </div>
            
            <div class="form-group" style="margin:0;">
              <label style="color:var(--text-muted); font-size:0.9rem; margin-bottom:6px; display:block;">Notification Title *</label>
              <input type="text" name="title" class="form-control" placeholder="Enter alert title (e.g. Schedule Update)" required style="background:var(--surface); color:var(--text-main); border:1px solid var(--border); width:100%; box-sizing:border-box; height:42px;" />
            </div>
            
            <div class="form-group" style="margin:0;">
              <label style="color:var(--text-muted); font-size:0.9rem; margin-bottom:6px; display:block;">Message Content *</label>
              <textarea name="message" class="form-control" rows="3" placeholder="Enter the notification message detail..." required style="background:var(--surface); color:var(--text-main); border:1px solid var(--border); width:100%; box-sizing:border-box; padding:10px; font-family:inherit;"></textarea>
            </div>
            
            <button type="submit" class="btn btn-gold" style="align-self:flex-start; font-weight:600; padding:10px 24px; cursor:pointer;">Send Notification Alert</button>
          </form>
        </div>
      </div>

      <!-- Navigation tiles -->
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:16px;margin-top:24px;">
        <a href="${pageContext.request.contextPath}/admin/students/list"
           style="text-decoration:none;background:var(--white);border:1px solid var(--border);border-radius:12px;
                  padding:20px;display:flex;align-items:center;gap:14px;color:inherit;
                  transition:box-shadow .2s;" onmouseover="this.style.boxShadow='0 4px 16px rgba(0,0,0,.3)'"
           onmouseout="this.style.boxShadow=''">
          <svg class="tile-icon-svg" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
          <div><strong style="color:var(--text-main)">Students</strong><br><small style="color:var(--text-muted)">Manage all students</small></div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/instructors/list"
           style="text-decoration:none;background:var(--white);border:1px solid var(--border);border-radius:12px;
                  padding:20px;display:flex;align-items:center;gap:14px;color:inherit;transition:box-shadow .2s;"
           onmouseover="this.style.boxShadow='0 4px 16px rgba(0,0,0,.3)'"
           onmouseout="this.style.boxShadow=''">
          <svg class="tile-icon-svg" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg>
          <div><strong style="color:var(--text-main)">Instructors</strong><br><small style="color:var(--text-muted)">Manage instructors</small></div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/vehicles/list"
           style="text-decoration:none;background:var(--white);border:1px solid var(--border);border-radius:12px;
                  padding:20px;display:flex;align-items:center;gap:14px;color:inherit;transition:box-shadow .2s;"
           onmouseover="this.style.boxShadow='0 4px 16px rgba(0,0,0,.3)'"
           onmouseout="this.style.boxShadow=''">
          <svg class="tile-icon-svg" viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
          <div><strong style="color:var(--text-main)">Vehicles</strong><br><small style="color:var(--text-muted)">Fleet management</small></div>
        </a>
        <a href="${pageContext.request.contextPath}/admin/schedules/list"
           style="text-decoration:none;background:var(--white);border:1px solid var(--border);border-radius:12px;
                  padding:20px;display:flex;align-items:center;gap:14px;color:inherit;transition:box-shadow .2s;"
           onmouseover="this.style.boxShadow='0 4px 16px rgba(0,0,0,.3)'"
           onmouseout="this.style.boxShadow=''">
          <svg class="tile-icon-svg" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
          <div><strong style="color:var(--text-main)">Schedules</strong><br><small style="color:var(--text-muted)">Lesson scheduling</small></div>
        </a>
      </div>
    </div>
  </div>
</div>
</body>
</html>
