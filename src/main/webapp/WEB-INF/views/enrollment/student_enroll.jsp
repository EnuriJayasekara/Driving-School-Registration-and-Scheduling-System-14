<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    <title>Browse Courses &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
    <style>
        .course-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.25rem; margin-top: 1rem;
        }
        .course-card {
            background: var(--white); border: 1px solid var(--border); border-radius: 12px;
            padding: 1.25rem; display: flex; flex-direction: column; gap: .65rem;
            transition: box-shadow .2s, border-color .2s, transform 0.2s;
        }
        .course-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(196, 155, 85, 0.08);
            border-color: var(--gold);
        }
        .course-card h3 { margin: 0; font-size: 1.05rem; color: var(--text-main); }
        .course-meta { font-size: .85rem; color: var(--text-muted); margin: 0; }
        .course-price { font-size: 1.2rem; font-weight: 700; color: var(--gold-light); margin-top: 4px; }
        .course-card .actions {
            margin-top: auto; display: grid; grid-template-columns: 1fr 1fr; gap: .5rem;
        }
        .cart-icon-link {
            position: relative;
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 12px;
            background: var(--surface); color: var(--text-main); border: 1px solid var(--border); border-radius: 6px; font-size: .9rem;
            text-decoration: none; margin-right: 8px;
        }
        .cart-icon-link:hover { border-color: var(--gold); background: var(--white); color: var(--text-main); }
        .cart-badge {
            background: var(--gold); color: #fff; font-size: .7rem; font-weight: 700;
            border-radius: 10px; padding: 1px 7px; min-width: 18px; text-align: center;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">Browse Courses</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/student/cart" class="cart-icon-link">
                    Cart
                    <c:if test="${not empty sessionScope.cart and sessionScope.cart.size() > 0}">
                        <span class="cart-badge">${sessionScope.cart.size()}</span>
                    </c:if>
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a> &rsaquo; Browse Courses
                </div>
                <h2>Available Courses</h2>
                <p style="color:var(--text-muted);margin:4px 0 0;">Pick a course, view details, or add to cart for batch checkout.</p>
            </div>

            <c:if test="${param.msg eq 'added'}">
                <div class="alert alert-success">Course successfully added to your cart.
                    <a href="${pageContext.request.contextPath}/student/cart">View Cart &rarr;</a>
                </div>
            </c:if>
            <c:if test="${param.error eq 'notfound'}">
                <div class="alert alert-danger">That course is no longer available.</div>
            </c:if>

            <c:choose>
                <c:when test="${empty courses}">
                    <div class="card">
                        <div class="card-body" style="text-align:center;padding:36px;color:var(--text-muted);">
                            No active courses are available right now.
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="course-grid">
                        <c:forEach var="course" items="${courses}">
                            <c:set var="inCart" value="${not empty sessionScope.cart and sessionScope.cart.contains(course.courseId)}"/>
                            <div class="course-card">
                                <span class="badge badge-info" style="align-self:flex-start">${course.licenseCategory}</span>
                                <h3>${course.courseName}</h3>
                                <p class="course-meta">${course.totalHours} hours of training</p>
                                <p class="course-meta">
                                        ${not empty course.description ? course.description : 'Comprehensive driving instruction by certified instructors.'}
                                </p>
                                <div class="course-price">
                                    LKR <fmt:formatNumber value="${course.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </div>

                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/student/enroll/details?courseId=${course.courseId}"
                                       class="btn btn-outline" style="text-align:center;text-decoration:none;display:block;">
                                        Details
                                    </a>
                                    <c:choose>
                                        <c:when test="${inCart}">
                                            <a href="${pageContext.request.contextPath}/student/cart"
                                               class="btn btn-primary" style="text-align:center;background:#16a34a;border-color:#16a34a;text-decoration:none;display:block;">
                                                In Cart
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/student/cart/add" method="post" style="margin:0;">
                                                <input type="hidden" name="courseId" value="${course.courseId}">
                                                <button type="submit" class="btn btn-gold" style="width:100%;font-weight:600;">
                                                    Add to Cart
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
