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
    <title>My Cart &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
    <style>
        .cart-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-top: 1rem; }
        @media (max-width: 800px) { .cart-grid { grid-template-columns: 1fr; } }
        .cart-item {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1rem 1.25rem;
            margin-bottom: .75rem;
            display: grid;
            grid-template-columns: auto 1fr auto auto;
            gap: 1rem;
            align-items: center;
        }
        .cart-item .badge { align-self: start; }
        .cart-item .info h4 { margin: 0; font-size: 1rem; color: var(--text-main); }
        .cart-item .info p { margin: 4px 0 0; font-size: .82rem; color: var(--text-muted); }
        .cart-item .price { font-weight: 700; color: var(--text-main); white-space: nowrap; }
        .cart-item .remove-btn {
            background: none; border: none; color: #ef4444; cursor: pointer;
            font-size: 1.1rem; padding: 4px 8px; border-radius: 4px;
        }
        .cart-item .remove-btn:hover { background: rgba(239, 68, 68, 0.1); }
        .summary-card {
            background: var(--white); border: 1px solid var(--border); border-radius: 12px;
            padding: 1.25rem; position: sticky; top: 1rem;
        }
        .summary-card h3 { margin: 0 0 1rem; color: var(--gold-light); }
        .summary-row {
            display: flex; justify-content: space-between;
            padding: .5rem 0; font-size: .9rem;
        }
        .summary-total {
            display: flex; justify-content: space-between;
            padding-top: 1rem; margin-top: .5rem;
            border-top: 2px solid var(--border);
            font-weight: 800; font-size: 1.15rem;
        }
        .empty-cart {
            text-align: center; padding: 3rem 1rem;
            background: var(--white); border: 1px dashed var(--border); border-radius: 12px;
            color: var(--text-muted);
        }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">My Cart</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a> &rsaquo;
                    <a href="${pageContext.request.contextPath}/student/enroll">Browse Courses</a> &rsaquo;
                    Cart
                </div>
                <h2>Shopping Cart</h2>
            </div>

            <c:if test="${param.msg eq 'cleared'}">
                <div class="alert alert-success">Cart successfully cleared.</div>
            </c:if>

            <c:choose>
                <c:when test="${empty cartItems}">
                    <div class="empty-cart">
                        <h3 style="margin:0 0 .5rem; color:var(--text-main);">Your cart is empty</h3>
                        <p>Browse our courses and add some to get started.</p>
                        <a href="${pageContext.request.contextPath}/student/enroll" class="btn btn-gold" style="margin-top:1rem; text-decoration:none; display:inline-block;">
                            Browse Courses
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="cart-grid">
                        <%-- LEFT: items --%>
                        <div>
                            <c:forEach var="course" items="${cartItems}">
                                <div class="cart-item">
                                    <span class="badge badge-info">${course.licenseCategory}</span>

                                    <div class="info">
                                        <h4>${course.courseName}</h4>
                                        <p>${course.totalHours} hours of training</p>
                                    </div>

                                    <div class="price">
                                        LKR <fmt:formatNumber value="${course.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </div>

                                    <form action="${pageContext.request.contextPath}/student/cart/remove" method="post" style="display:inline;">
                                        <input type="hidden" name="courseId" value="${course.courseId}">
                                        <button type="submit" class="remove-btn" title="Remove">&times;</button>
                                    </form>
                                </div>
                            </c:forEach>

                            <div style="margin-top:1rem; display:flex; gap:.75rem;">
                                <a href="${pageContext.request.contextPath}/student/enroll" class="btn btn-outline" style="text-decoration:none;">
                                    &larr; Continue Shopping
                                </a>
                                <form action="${pageContext.request.contextPath}/student/cart/clear" method="post" style="display:inline;"
                                      onsubmit="return confirm('Empty your cart?');">
                                    <button type="submit" class="btn btn-outline" style="color:#ef4444;border-color:rgba(239,68,68,0.3);">
                                        Clear Cart
                                    </button>
                                </form>
                            </div>
                        </div>

                        <%-- RIGHT: summary --%>
                        <div>
                            <div class="summary-card">
                                <h3>Order Summary</h3>

                                <div class="summary-row">
                                    <span style="color:var(--text-muted);">Items in cart</span>
                                    <span style="font-weight:600; color:var(--text-main);">${cartItems.size()}</span>
                                </div>
                                <div class="summary-row">
                                    <span style="color:var(--text-muted);">Subtotal</span>
                                    <span style="font-weight:600; color:var(--text-main);">
                                        LKR <fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </span>
                                </div>

                                <div class="summary-total">
                                    <span>Total</span>
                                    <span style="color:var(--gold-light);">
                                        LKR <fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                    </span>
                                </div>

                                <a href="${pageContext.request.contextPath}/student/cart/checkout"
                                   class="btn btn-gold"
                                   style="width:100%;text-align:center;margin-top:1rem;font-size:1rem;padding:.7rem;font-weight:600;display:block;box-sizing:border-box;text-decoration:none;">
                                    Proceed to Checkout
                                </a>

                                <p style="text-align:center;font-size:.75rem;color:var(--text-muted);margin:.5rem 0 0;">
                                    Secure transaction - all card credentials are encrypted.
                                </p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</body>
</html>
