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
    <title>${empty enrollment ? 'Enroll Student' : 'Edit Enrollment'} &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">${empty enrollment ? 'Enroll Student' : 'Edit Enrollment'}</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo;
                    <a href="${pageContext.request.contextPath}/admin/enrollments/list">Enrollments</a> &rsaquo;
                    ${empty enrollment ? 'New' : 'Edit'}
                </div>
                <h2>${empty enrollment ? 'Enroll a Student' : 'Edit Enrollment'}</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">&#9888; ${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <h3>${empty enrollment ? 'New Enrollment' : 'Update Enrollment'}</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/enrollments/${empty enrollment ? 'new' : 'edit'}" method="post">
                        <c:if test="${not empty enrollment}">
                            <input type="hidden" name="enrollmentId" value="${enrollment.enrollmentId}">
                        </c:if>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Student *</label>
                                <c:choose>
                                    <c:when test="${empty enrollment}">
                                        <select name="studentId" class="form-control" required>
                                            <option value="">-- Select student --</option>
                                            <c:forEach var="st" items="${students}">
                                                <option value="${st.studentId}">${st.fullName} (NIC: ${st.nicNumber})</option>
                                            </c:forEach>
                                        </select>
                                    </c:when>
                                    <c:otherwise>
                                        <%-- When editing, student cannot be changed --%>
                                        <input type="text" class="form-control" value="${enrollment.studentName}" disabled>
                                        <input type="hidden" name="studentId" value="${enrollment.studentId}">
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="form-group">
                                <label>Course *</label>
                                <select name="courseId" class="form-control" required>
                                    <option value="">-- Select course --</option>
                                    <c:forEach var="co" items="${courses}">
                                        <option value="${co.courseId}"
                                            ${enrollment.courseId eq co.courseId ? 'selected' : ''}>
                                                ${co.courseName} (${co.licenseCategory}) &ndash; LKR ${co.price}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-row-3">
                            <div class="form-group">
                                <label>Status</label>
                                <c:set var="estatus" value="${enrollment.status}"/>
                                <select name="status" class="form-control">
                                    <option value="active"    ${empty enrollment or estatus eq 'active'    ? 'selected' : ''}>Active</option>
                                    <option value="completed" ${estatus eq 'completed' ? 'selected' : ''}>Completed</option>
                                    <option value="cancelled" ${estatus eq 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                    <option value="on_hold"   ${estatus eq 'on_hold'   ? 'selected' : ''}>On Hold</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Payment Status</label>
                                <c:set var="pstatus" value="${enrollment.paymentStatus}"/>
                                <select name="paymentStatus" class="form-control">
                                    <option value="pending"  ${empty enrollment or pstatus eq 'pending'  ? 'selected' : ''}>Pending</option>
                                    <option value="partial"  ${pstatus eq 'partial'  ? 'selected' : ''}>Partial</option>
                                    <option value="paid"     ${pstatus eq 'paid'     ? 'selected' : ''}>Paid</option>
                                    <option value="refunded" ${pstatus eq 'refunded' ? 'selected' : ''}>Refunded</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Amount Paid (LKR)</label>
                                <input type="number" name="amountPaid" class="form-control" step="0.01" min="0"
                                       value="${empty enrollment ? '0.00' : enrollment.amountPaid}" placeholder="0.00">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Notes</label>
                            <textarea name="notes" class="form-control" rows="3"
                                      placeholder="Optional notes about this enrollment">${enrollment.notes}</textarea>
                        </div>

                        <div class="d-flex gap-2" style="gap:12px;margin-top:8px;">
                            <button type="submit" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;">
                                <c:choose>
                                    <c:when test="${empty enrollment}">
                                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg> Enroll Student
                                    </c:when>
                                    <c:otherwise>
                                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Update Enrollment
                                    </c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/enrollments/list" class="btn btn-outline">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
