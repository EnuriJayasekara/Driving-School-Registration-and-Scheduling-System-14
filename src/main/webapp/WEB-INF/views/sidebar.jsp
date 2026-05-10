<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.drivingschool.service.NotificationService" %>
<%
  String role = (String) session.getAttribute("role");
  String currentURI = request.getRequestURI();

  // Fetch unread notification count for badge (cheap query)
  int unread = 0;
  Integer uid = (Integer) session.getAttribute("userId");
  if (uid != null) {
    try { unread = new NotificationService().countUnread(uid); }
    catch (Exception ex) { /* swallow */ }
  }
  request.setAttribute("unreadCount", unread);
%>
<nav class="sidebar">
  <div class="sidebar-logo">
    <div class="brand">DriveEdu</div>
    <div class="brand-sub">Management System</div>
  </div>

  <div class="sidebar-nav">
    <style>
      .nav-icon-svg {
        width: 18px;
        height: 18px;
        fill: none;
        stroke: currentColor;
        stroke-width: 2;
        stroke-linecap: round;
        stroke-linejoin: round;
        display: inline-block;
        vertical-align: middle;
        margin-right: 8px;
      }
    </style>

    <%-- ============= ADMIN ============= --%>
    <% if ("admin".equals(role)) { %>
    <div class="nav-section-label">Main</div>
    <a href="${pageContext.request.contextPath}/admin/dashboard"
       class="<%= currentURI.endsWith("/admin/dashboard") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/notifications"
       class="<%= currentURI.contains("/notifications") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg> Notifications
      <c:if test="${unreadCount > 0}">
          <span style="background:#ef4444;color:#fff;font-size:.7rem;font-weight:700;
                       border-radius:10px;padding:1px 7px;margin-left:6px;">
              ${unreadCount}
          </span>
      </c:if>
    </a>

    <div class="nav-section-label">Management</div>
    <a href="${pageContext.request.contextPath}/admin/students/list"
       class="<%= currentURI.contains("/students") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg> Students
    </a>
    <a href="${pageContext.request.contextPath}/admin/instructors/list"
       class="<%= currentURI.contains("/instructors") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><polyline points="16 11 18 13 22 9"></polyline></svg> Instructors
    </a>
    <a href="${pageContext.request.contextPath}/admin/vehicles/list"
       class="<%= currentURI.contains("/vehicles") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg> Vehicles
    </a>
    <a href="${pageContext.request.contextPath}/admin/courses/list"
       class="<%= currentURI.contains("/courses") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg> Courses
    </a>

    <div class="nav-section-label">Operations</div>
    <a href="${pageContext.request.contextPath}/admin/enrollments/list"
       class="<%= currentURI.contains("/enrollments") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"></path><rect x="8" y="2" width="8" height="4" rx="1" ry="1"></rect></svg> Enrollments
    </a>
    <a href="${pageContext.request.contextPath}/admin/slots/list"
       class="<%= currentURI.contains("/admin/slots") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line><line x1="12" y1="14" x2="12" y2="20"></line><line x1="9" y1="17" x2="15" y2="17"></line></svg> Open Slots
    </a>
    <a href="${pageContext.request.contextPath}/admin/schedules/list"
       class="<%= currentURI.contains("/admin/schedules") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg> Booked Lessons
    </a>

    <div class="nav-section-label">My Account</div>
    <a href="${pageContext.request.contextPath}/account"
       class="<%= currentURI.endsWith("/account") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg> Account Settings
    </a>

    <%-- ============= STUDENT ============= --%>
    <% } else if ("student".equals(role)) { %>
    <div class="nav-section-label">My Account</div>
    <a href="${pageContext.request.contextPath}/student/dashboard"
       class="<%= currentURI.contains("/student/dashboard") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg> Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/notifications"
       class="<%= currentURI.contains("/notifications") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg> Notifications
      <c:if test="${unreadCount > 0}">
          <span style="background:#ef4444;color:#fff;font-size:.7rem;font-weight:700;
                       border-radius:10px;padding:1px 7px;margin-left:6px;">
              ${unreadCount}
          </span>
      </c:if>
    </a>
    <a href="${pageContext.request.contextPath}/student/enroll"
       class="<%= currentURI.endsWith("/student/enroll") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"></path><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"></path></svg> Browse Courses
    </a>
    <a href="${pageContext.request.contextPath}/student/slots"
       class="<%= currentURI.contains("/student/slots") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg> Pick a Lesson
    </a>
    <a href="${pageContext.request.contextPath}/student/cart"
       class="<%= currentURI.contains("/student/cart") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><circle cx="9" cy="21" r="1"></circle><circle cx="20" cy="21" r="1"></circle><path d="M1 1h4l2.68 13.39a2 2 0 0 0 2 1.61h9.72a2 2 0 0 0 2-1.61L23 6H6"></path></svg> My Cart
      <c:if test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
          <span style="background:#c9a84c;color:#fff;font-size:.7rem;font-weight:700;
                       border-radius:10px;padding:1px 7px;margin-left:6px;">
              ${sessionScope.cart.size()}
          </span>
      </c:if>
    </a>
    <a href="${pageContext.request.contextPath}/account"
       class="<%= currentURI.endsWith("/account") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg> Account Settings
    </a>

    <%-- ============= INSTRUCTOR ============= --%>
    <% } else if ("instructor".equals(role)) { %>
    <div class="nav-section-label">Main</div>
    <a href="${pageContext.request.contextPath}/instructor/dashboard?view=profile"
       class="<%= (currentURI.contains("/instructor/dashboard") && (request.getParameter("view") == null || "profile".equals(request.getParameter("view")) || "progress".equals(request.getParameter("view")))) ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="9"></rect><rect x="14" y="3" width="7" height="5"></rect><rect x="14" y="12" width="7" height="9"></rect><rect x="3" y="16" width="7" height="5"></rect></svg> Dashboard
    </a>

    <div class="nav-section-label">My Schedule</div>
    <a href="${pageContext.request.contextPath}/notifications"
       class="<%= currentURI.contains("/notifications") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg> Notifications
      <c:if test="${unreadCount > 0}">
          <span style="background:#ef4444;color:#fff;font-size:.7rem;font-weight:700;
                       border-radius:10px;padding:1px 7px;margin-left:6px;">
              ${unreadCount}
          </span>
      </c:if>
    </a>
    <a href="${pageContext.request.contextPath}/instructor/dashboard?view=lessons"
       class="<%= (currentURI.contains("/instructor/dashboard") && "lessons".equals(request.getParameter("view"))) ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg> My Lessons
    </a>

    <div class="nav-section-label">My Account</div>
    <a href="${pageContext.request.contextPath}/account"
       class="<%= currentURI.endsWith("/account") ? "active" : "" %>">
      <svg class="nav-icon-svg" viewBox="0 0 24 24"><circle cx="12" cy="12" r="3"></circle><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"></path></svg> Account Settings
    </a>
    <% } %>

  </div>

  <div class="sidebar-footer">
    Logged in as <strong style="color:var(--gold-light)">
    ${sessionScope.loggedUser.fullName}
  </strong><br>
    <small>${sessionScope.role}</small>
  </div>
</nav>

<script>
  document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll(".alert").forEach(function(alert) {
      if (!alert.querySelector(".alert-close")) {
        var closeBtn = document.createElement("span");
        closeBtn.className = "alert-close";
        closeBtn.innerHTML = "&times;";
        closeBtn.style.marginLeft = "auto";
        closeBtn.style.cursor = "pointer";
        closeBtn.style.fontSize = "1.2rem";
        closeBtn.style.fontWeight = "bold";
        closeBtn.style.lineHeight = "1";
        closeBtn.style.opacity = "0.7";
        closeBtn.style.transition = "opacity 0.2s";
        
        closeBtn.addEventListener("mouseover", function() {
          closeBtn.style.opacity = "1";
        });
        closeBtn.addEventListener("mouseout", function() {
          closeBtn.style.opacity = "0.7";
        });
        closeBtn.addEventListener("click", function() {
          alert.style.display = "none";
        });
        alert.appendChild(closeBtn);
      }
    });
  });
</script>
