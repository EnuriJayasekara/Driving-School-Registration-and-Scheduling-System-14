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
    <title>Checkout &ndash; DriveEdu</title>
    <link class="styles" rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
    <style>
        .pay-grid { display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; margin-top: 1rem; }
        @media (max-width: 800px) { .pay-grid { grid-template-columns: 1fr; } }
        .pay-card { background: var(--white); border: 1px solid var(--border); border-radius: 12px; padding: 1.5rem; }
        .pay-card h3 { margin: 0 0 1rem; color: var(--gold-light); }
        .summary-row {
            display: flex; justify-content: space-between;
            padding: .55rem 0; border-bottom: 1px dashed var(--border); font-size: .88rem;
        }
        .summary-row:last-of-type { border-bottom: 0; }
        .summary-total {
            display: flex; justify-content: space-between;
            padding: 1rem 0 0; margin-top: .5rem;
            border-top: 2px solid var(--border);
            font-weight: 800; font-size: 1.1rem;
        }
        .test-hint {
            background: rgba(196, 155, 85, 0.08); border-left: 4px solid var(--gold);
            padding: .75rem 1rem; border-radius: 6px; font-size: .85rem;
            color: var(--gold-light); margin-bottom: 1.5rem; line-height: 1.5;
        }
        .test-hint code { background: var(--surface); padding: 2px 6px; border-radius: 3px; font-family: monospace; border: 1px solid var(--border); color: var(--text-main); }
        .card-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }
        .secure-note {
            display: flex; align-items: center; gap: 6px;
            font-size: .8rem; color: var(--text-muted); margin-top: 1.5rem; justify-content: center;
        }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">Checkout</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a> &rsaquo;
                    <a href="${pageContext.request.contextPath}/student/cart">Cart</a> &rsaquo;
                    Checkout
                </div>
                <h2>Complete Your Payment</h2>
            </div>

            <div class="pay-grid">
                <%-- LEFT: card form --%>
                <div class="pay-card">
                    <h3>Card Details</h3>


                    <form action="${pageContext.request.contextPath}/student/cart/checkout" method="post" id="payForm">
                        <div class="form-group">
                            <label style="color:var(--text-muted);">Cardholder Name *</label>
                            <input type="text" name="cardholderName" class="form-control"
                                   required placeholder="Name on card"
                                   value="${sessionScope.loggedUser.fullName}"
                                   style="background:var(--surface); color:var(--text-main); border:1px solid var(--border);">
                        </div>

                        <div class="form-group">
                            <label style="color:var(--text-muted);">Card Number *</label>
                            <input type="text" name="cardNumber" id="cardNumber" class="form-control"
                                   required inputmode="numeric" maxlength="23"
                                   placeholder="1234 5678 9012 3456" autocomplete="cc-number"
                                   style="background:var(--surface); color:var(--text-main); border:1px solid var(--border);">
                        </div>

                        <div class="card-row">
                            <div class="form-group">
                                <label style="color:var(--text-muted);">Expiry (MM/YY) *</label>
                                <input type="text" name="expiry" id="expiry" class="form-control"
                                       required maxlength="5" placeholder="12/28" autocomplete="cc-exp"
                                       style="background:var(--surface); color:var(--text-main); border:1px solid var(--border);">
                            </div>
                            <div class="form-group">
                                <label style="color:var(--text-muted);">CVV *</label>
                                <input type="text" name="cvv" class="form-control"
                                       required inputmode="numeric" minlength="3" maxlength="4"
                                       placeholder="123" autocomplete="cc-csc"
                                       style="background:var(--surface); color:var(--text-main); border:1px solid var(--border);">
                            </div>
                        </div>

                        <button type="submit" class="btn btn-gold"
                                style="width:100%;margin-top:1rem;font-size:1.05rem;padding:.75rem;font-weight:600;">
                            Pay LKR <fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                        </button>

                        <div class="secure-note">Your payment is processed securely via encrypted tunnel.</div>
                    </form>
                </div>

                <%-- RIGHT: order summary --%>
                <div>
                    <div class="pay-card">
                        <h3>Order Summary</h3>

                        <c:forEach var="course" items="${cartItems}">
                            <div class="summary-row">
                                <span style="color:var(--text-main);">
                                  ${course.courseName}
                                  <span style="color:var(--text-muted);font-size:.78rem;">(${course.licenseCategory})</span>
                                </span>
                                <span style="font-weight:600;white-space:nowrap;color:var(--text-main);">
                                  LKR <fmt:formatNumber value="${course.price}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                            </div>
                        </c:forEach>

                        <div class="summary-total">
                            <span>Total (${cartItems.size()} item${cartItems.size() == 1 ? '' : 's'})</span>
                            <span style="color:var(--gold-light);">
                                LKR <fmt:formatNumber value="${cartTotal}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                            </span>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/student/cart"
                       class="btn btn-outline" style="width:100%;text-align:center;margin-top:1rem;text-decoration:none;display:block;box-sizing:border-box;">
                        Back to Cart
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('cardNumber').addEventListener('input', function(e) {
        var v = e.target.value.replace(/\D/g, '').substring(0, 19);
        e.target.value = v.replace(/(.{4})/g, '$1 ').trim();
    });
    document.getElementById('expiry').addEventListener('input', function(e) {
        var v = e.target.value.replace(/\D/g, '').substring(0, 4);
        if (v.length >= 3) v = v.substring(0,2) + '/' + v.substring(2);
        e.target.value = v;
    });
</script>
</body>
</html>
