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
    <title>Create Slot &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
    <style>
        .cap-preview {
            background: rgba(196, 155, 85, 0.08);
            border: 1px solid rgba(196, 155, 85, 0.2);
            border-radius: 8px;
            padding: .9rem 1rem;
            margin-top: 1rem;
            font-size: .95rem;
            color: var(--gold-light);
        }
        .cap-preview strong { color: var(--text-main); }
        .cap-preview .num { font-size: 1.4rem; font-weight: 800; color: var(--gold); }
    </style>
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">Create Lesson Slot</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo;
                    <a href="${pageContext.request.contextPath}/admin/slots/list">Slots</a> &rsaquo;
                    New
                </div>
                <h2>Create Open Slot</h2>
                <p style="color:#777;margin:4px 0 0;">
                    Slot capacity is determined by the selected vehicle &mdash; 1 seat for the instructor, the rest for students.
                </p>
            </div>

            <div class="card">
                <div class="card-header"><h3>Slot Details</h3></div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/slots/new" method="post">

                        <div class="form-row">
                            <div class="form-group">
                                <label>Course *</label>
                                <select name="courseId" class="form-control" required>
                                    <option value="">-- Select course --</option>
                                    <c:forEach var="co" items="${courses}">
                                        <option value="${co.courseId}">
                                                ${co.courseName} (${co.licenseCategory})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Lesson Type *</label>
                                <select name="lessonType" class="form-control" required>
                                    <option value="practical" selected>Practical</option>
                                    <option value="theory">Theory</option>
                                    <option value="test_prep">Test Prep</option>
                                    <option value="road_test">Road Test</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Instructor *</label>
                                <select name="instructorId" class="form-control" required>
                                    <option value="">-- Select instructor --</option>
                                    <c:forEach var="ins" items="${instructors}">
                                        <option value="${ins.instructorId}">
                                                ${ins.fullName} &ndash; ${ins.formattedSpecialization}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Vehicle *</label>
                                <select name="vehicleId" id="vehicleSelect" class="form-control" required>
                                    <option value="" data-seats="0">-- Select vehicle --</option>
                                    <c:forEach var="v" items="${vehicles}">
                                        <option value="${v.vehicleId}" data-seats="${v.seatingCapacity}">
                                                ${v.registrationNo} &ndash; ${v.make} ${v.model}
                                            (${v.transmissionType}, ${v.seatingCapacity} seats)
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>

                        <%-- Capacity preview - filled in via JS based on vehicle pick --%>
                        <div class="cap-preview" id="capPreview" style="display:none;">
                            Selected vehicle has <strong><span id="totalSeats">0</span> seats</strong>
                            (1 for instructor) &rarr; up to
                            <span class="num" id="studentSeats">0</span> students can book this slot.
                        </div>

                        <div class="form-row-3" style="margin-top:1rem;">
                            <div class="form-group">
                                <label>Date *</label>
                                <input type="date" name="lessonDate" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Time Slot *</label>
                                <input type="time" name="timeSlot" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label>Duration (min) *</label>
                                <input type="number" name="durationMinutes" class="form-control"
                                       value="60" required min="30" max="240" step="15">
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Notes</label>
                            <input type="text" name="notes" class="form-control"
                                   maxlength="200" placeholder="Optional - location, special requirements">
                        </div>

                        <div class="d-flex gap-2" style="gap:12px;margin-top:8px;">
                            <button type="submit" class="btn btn-primary">&#43; Create Slot</button>
                            <a href="${pageContext.request.contextPath}/admin/slots/list" class="btn btn-outline">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    var vehicleSelect = document.getElementById('vehicleSelect');
    var preview       = document.getElementById('capPreview');
    var totalSpan     = document.getElementById('totalSeats');
    var studentSpan   = document.getElementById('studentSeats');

    vehicleSelect.addEventListener('change', function() {
        var opt = vehicleSelect.options[vehicleSelect.selectedIndex];
        var seats = parseInt(opt.getAttribute('data-seats') || '0', 10);
        if (seats >= 2) {
            totalSpan.textContent   = seats;
            studentSpan.textContent = seats - 1;
            preview.style.display   = 'block';
        } else {
            preview.style.display = 'none';
        }
    });
</script>
</body>
</html>
