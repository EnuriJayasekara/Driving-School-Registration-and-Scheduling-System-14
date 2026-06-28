<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Notifications &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
    <style>
        .notif-card {
            background: var(--white); border-left: 4px solid var(--gold); border-radius: 12px;
            border-top: 1px solid rgba(255,255,255,0.03);
            border-right: 1px solid rgba(255,255,255,0.03);
            border-bottom: 1px solid rgba(255,255,255,0.03);
            padding: 1.2rem 1.5rem; margin-bottom: 1rem;
            display: grid; grid-template-columns: 1fr auto; gap: 1.5rem;
            transition: all 0.2s ease;
        }
        .notif-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.25);
        }
        .notif-card.unread { background: rgba(196, 155, 85, 0.06); border-left-color: var(--gold); }
        .notif-card.success { border-left-color: var(--success); }
        .notif-card.warning { border-left-color: var(--warning); }
        .notif-card.reminder { border-left-color: var(--info); background: rgba(59, 130, 246, 0.05); }
        .notif-card .title { font-weight: 700; color: var(--text-main); margin: 0 0 6px; font-size: 1.05rem; }
        .notif-card .msg { font-size: .95rem; color: var(--text-muted); margin: 0; line-height: 1.45; }
        .notif-card .time { font-size: .8rem; color: #8a909a; margin-top: 8px; }
        .notif-card .dot {
            width: 10px; height: 10px; border-radius: 50%;
            background: var(--gold); align-self: center;
        }
        .notif-card a {
            color: var(--gold);
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            margin-top: 8px;
            transition: color 0.15s;
        }
        .notif-card a:hover {
            color: var(--gold-light);
        }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">Notifications</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header" style="display:flex;justify-content:space-between;align-items:flex-end;">
                <div>
                    <div class="breadcrumb">
                        <a href="${pageContext.request.contextPath}/${sessionScope.role}/dashboard">Dashboard</a> &rsaquo; Notifications
                    </div>
                    <h2>Your Notifications</h2>
                </div>
                <form action="${pageContext.request.contextPath}/notifications/read-all" method="post">
                    <button type="submit" class="btn btn-outline btn-sm">Mark all as read</button>
                </form>
            </div>

            <c:choose>
                <c:when test="${empty notifications}">
                    <div class="card">
                        <div class="card-body" style="text-align:center;padding:36px;color:#888;">
                            You're all caught up! No notifications yet.
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="n" items="${notifications}">
                        <div class="notif-card ${n.type} ${not n.read ? 'unread' : ''}">
                            <div>
                                <p class="title">${n.title}</p>
                                <p class="msg">${n.message}</p>
                                <div class="time">${n.createdAt}</div>
                                <c:if test="${not empty n.link}">
                                    <a href="${pageContext.request.contextPath}${n.link}" style="font-size:.85rem;">
                                        View &rarr;
                                    </a>
                                </c:if>
                            </div>
                            <div style="display:flex; flex-direction:column; gap:8px; align-items:flex-end; justify-content:center;">
                                <c:if test="${not n.read}">
                                    <form action="${pageContext.request.contextPath}/notifications/read" method="post" style="margin:0;">
                                        <input type="hidden" name="id" value="${n.notificationId}">
                                        <button type="submit" class="btn btn-outline btn-sm" style="width:100px;">Mark read</button>
                                    </form>
                                </c:if>
                                <form action="${pageContext.request.contextPath}/notifications/delete" method="post" style="margin:0;">
                                    <input type="hidden" name="id" value="${n.notificationId}">
                                    <button type="submit" class="btn btn-outline btn-sm" style="width:100px; border-color:#ef4444; color:#ef4444; background:transparent;">Delete</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
