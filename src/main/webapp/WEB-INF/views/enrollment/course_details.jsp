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
    <title>${course.courseName} &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
    <style>
        .details-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-top: 1rem; }
        @media (max-width: 800px) { .details-grid { grid-template-columns: 1fr; } }
        .info-box { background: var(--white); border: 1px solid var(--border); border-radius: 12px; padding: 1.5rem; }
        .info-box h3 { margin: 0 0 .8rem; color: var(--gold-light); font-size: 1.1rem; }
        .info-row {
            display: flex; justify-content: space-between;
            padding: .6rem 0; border-bottom: 1px dashed var(--border);
        }
        .info-row:last-child { border-bottom: 0; }
        .info-row .label { color: var(--text-muted); font-size: .9rem; }
        .info-row .value { font-weight: 600; color: var(--text-main); }
        .price-box {
            background: linear-gradient(135deg, #c9a84c 0%, #b8902f 100%);
            color: #fff; padding: 1.5rem; border-radius: 12px; text-align: center;
        }
        .price-box .amount { font-size: 2rem; font-weight: 800; margin: .3rem 0; }
        .price-box .label { font-size: .8rem; letter-spacing: 1px; text-transform: uppercase; opacity: .85; }
        .desc { color: var(--text-muted); line-height: 1.6; margin: .8rem 0 0; }
        .cart-icon-link {
            position: relative; display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 12px; background: var(--surface); color: var(--text-main);
            border: 1px solid var(--border); border-radius: 6px; font-size: .9rem; text-decoration: none; margin-right: 8px;
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
            <span class="topbar-title">Course Details</span>
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
                    <a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a> &rsaquo;
                    <a href="${pageContext.request.contextPath}/student/enroll">Browse Courses</a> &rsaquo;
                    ${course.courseName}
                </div>
                <h2 style="color:var(--text-main);">${course.courseName}</h2>
                <span class="badge badge-info">${course.licenseCategory} License Category</span>
            </div>

            <c:if test="${param.msg eq 'added'}">
                <div class="alert alert-success">Course successfully added to cart.
                    <a href="${pageContext.request.contextPath}/student/cart">View Cart &rarr;</a>
                </div>
            </c:if>
            <c:if test="${alreadyEnrolled}">
                <div class="alert alert-success">
                    You are already enrolled in this course.
                    <a href="${pageContext.request.contextPath}/student/dashboard">View on Dashboard &rarr;</a>
                </div>
            </c:if>
            <c:if test="${param.error eq 'alreadyenrolled'}">
                <div class="alert alert-danger">You are already enrolled in this course.</div>
            </c:if>

            <c:set var="inCart" value="${not empty sessionScope.cart and sessionScope.cart.contains(course.courseId)}"/>

            <div class="details-grid">
                <%-- LEFT --%>
                <div>
                    <div class="info-box">
                        <h3>About This Course</h3>
                        <p class="desc">
                            ${not empty course.description
                                    ? course.description
                                    : 'A comprehensive driving course covering all essentials for the selected license category, taught by certified instructors using modern, well-maintained vehicles.'}
                        </p>
                    </div>

                    <div class="info-box" style="margin-top:1rem;">
                        <h3>Course Information</h3>
                        <div class="info-row"><span class="label">License Category</span><span class="value">${course.licenseCategory}</span></div>
                        <div class="info-row"><span class="label">Total Training Hours</span><span class="value">${course.totalHours} hours</span></div>
                        <div class="info-row"><span class="label">Includes</span><span class="value">Theory + Practical</span></div>
                        <div class="info-row"><span class="label">Vehicle</span><span class="value">Provided by school</span></div>
                        <div class="info-row"><span class="label">Certificate</span><span class="value">On completion</span></div>
                    </div>
                </div>

                <%-- RIGHT --%>
                <div>
                    <div class="price-box">
                        <div class="label">Course Fee</div>
                        <div class="amount">
                            LKR <fmt:formatNumber value="${course.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                        </div>
                        <div class="label" style="font-size:.7rem;">One-time payment</div>
                    </div>

                    <div class="info-box" style="margin-top:1rem;">
                        <h3>Ready to start?</h3>
                        <p style="color:var(--text-muted);font-size:.9rem;margin:0 0 1rem;">
                            Pay now to enroll instantly, or add to cart to combine with other courses.
                        </p>

                        <c:choose>
                            <c:when test="${alreadyEnrolled}">
                                <a href="${pageContext.request.contextPath}/student/dashboard"
                                   class="btn btn-outline" style="width:100%;text-align:center;">
                                    Go to Dashboard
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/student/enroll/payment?courseId=${course.courseId}"
                                   class="btn btn-gold" style="width:100%;text-align:center;font-weight:600;display:block;box-sizing:border-box;margin-bottom:0.5rem;text-decoration:none;">
                                    Pay Now
                                </a>

                                <c:choose>
                                    <c:when test="${inCart}">
                                        <a href="${pageContext.request.contextPath}/student/cart"
                                           class="btn btn-outline" style="width:100%;text-align:center;margin-top:.5rem;color:#16a34a;border-color:#86efac;text-decoration:none;display:block;box-sizing:border-box;">
                                            In Cart - View
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/student/cart/add" method="post" style="margin:.5rem 0 0;">
                                            <input type="hidden" name="courseId" value="${course.courseId}">
                                            <input type="hidden" name="redirect" value="details">
                                            <button type="submit" class="btn btn-outline" style="width:100%;">
                                                Add to Cart
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>

                        <a href="${pageContext.request.contextPath}/student/enroll"
                           class="btn btn-outline" style="width:100%;text-align:center;margin-top:.5rem;text-decoration:none;display:block;box-sizing:border-box;">
                            Back to Courses
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
