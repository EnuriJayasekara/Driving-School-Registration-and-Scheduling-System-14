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
    <title>${empty vehicle ? 'Add' : 'Edit'} Vehicle &ndash; DriveEdu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0">
</head>
<body>
<div class="wrapper">
    <jsp:include page="../sidebar.jsp"/>
    <div class="main-content">
        <div class="topbar">
            <span class="topbar-title">${empty vehicle ? 'Add New Vehicle' : 'Edit Vehicle'}</span>
            <div class="topbar-right">
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-body">
            <div class="page-header">
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo;
                    <a href="${pageContext.request.contextPath}/admin/vehicles/list">Vehicles</a> &rsaquo;
                    ${empty vehicle ? 'Add New' : 'Edit'}
                </div>
                <h2>${empty vehicle ? 'Add New Vehicle' : 'Edit Vehicle'}</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">&#9888; ${error}</div>
            </c:if>

            <div class="card">
                <div class="card-header">
                    <h3>${empty vehicle ? 'Vehicle Registration' : 'Update Vehicle Info'}</h3>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/vehicles/${empty vehicle ? 'new' : 'edit'}" method="post">
                        <c:if test="${not empty vehicle}">
                            <input type="hidden" name="vehicleId" value="${vehicle.vehicleId}">
                        </c:if>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Registration No *</label>
                                <input type="text" name="registrationNo" class="form-control"
                                       value="${vehicle.registrationNo}" required placeholder="CAB-1234">
                            </div>
                            <div class="form-group">
                                <label>Year *</label>
                                <input type="number" name="year" class="form-control"
                                       value="${empty vehicle ? '' : vehicle.year}" required min="2000" max="2030" placeholder="2022">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Make *</label>
                                <input type="text" name="make" class="form-control"
                                       value="${vehicle.make}" required placeholder="Toyota">
                            </div>
                            <div class="form-group">
                                <label>Model *</label>
                                <input type="text" name="model" class="form-control"
                                       value="${vehicle.model}" required placeholder="Corolla">
                            </div>
                        </div>

                        <div class="form-row-3">
                            <div class="form-group">
                                <label>Transmission *</label>
                                <c:set var="trans" value="${vehicle.transmissionType}"/>
                                <select name="transmissionType" class="form-control" required>
                                    <option value="manual"    ${trans eq 'manual'    ? 'selected' : ''}>Manual</option>
                                    <option value="automatic" ${trans eq 'automatic' ? 'selected' : ''}>Automatic</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Fuel Type *</label>
                                <c:set var="fuel" value="${vehicle.fuelType}"/>
                                <select name="fuelType" class="form-control" required>
                                    <option value="petrol"   ${fuel eq 'petrol'   ? 'selected' : ''}>Petrol</option>
                                    <option value="diesel"   ${fuel eq 'diesel'   ? 'selected' : ''}>Diesel</option>
                                    <option value="electric" ${fuel eq 'electric' ? 'selected' : ''}>Electric</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Seating Capacity *</label>
                                <input type="number" name="seatingCapacity" id="seatingCapacity" class="form-control"
                                       value="${empty vehicle ? 5 : vehicle.seatingCapacity}"
                                       required min="2" max="60">
                                <small style="color:#888;" id="seatHint">
                                    Includes the instructor seat. Students per lesson = total &minus; 1.
                                </small>
                            </div>
                        </div>

                        <div class="form-row-3">
                            <div class="form-group">
                                <label>Status *</label>
                                <c:set var="vstatus" value="${vehicle.status}"/>
                                <select name="status" class="form-control" required>
                                    <option value="available"   ${vstatus eq 'available'   ? 'selected' : ''}>Available</option>
                                    <option value="in_use"      ${vstatus eq 'in_use'      ? 'selected' : ''}>In Use</option>
                                    <option value="maintenance" ${vstatus eq 'maintenance' ? 'selected' : ''}>Maintenance</option>
                                    <option value="retired"     ${vstatus eq 'retired'     ? 'selected' : ''}>Retired</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Category *</label>
                                <c:set var="vcat" value="${vehicle.category}"/>
                                <select name="category" class="form-control" required>
                                    <option value="Auto-detect"  ${empty vcat or vcat eq 'Auto-detect' ? 'selected' : ''}>Auto-detect (by Seating Capacity)</option>
                                    <option value="Light Vehicle" ${vcat eq 'Light Vehicle' ? 'selected' : ''}>Light Vehicle</option>
                                    <option value="Heavy Vehicle" ${vcat eq 'Heavy Vehicle' ? 'selected' : ''}>Heavy Vehicle</option>
                                    <option value="Motorcycle"    ${vcat eq 'Motorcycle' ? 'selected' : ''}>Motorcycle</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Vehicle Type *</label>
                                <c:set var="vtype" value="${vehicle.vehicleType}"/>
                                <select name="vehicleType" class="form-control" required>
                                    <option value="Car"          ${empty vtype or vtype eq 'Car' ? 'selected' : ''}>Car</option>
                                    <option value="Bike"         ${vtype eq 'Bike' ? 'selected' : ''}>Bike</option>
                                    <option value="Van"          ${vtype eq 'Van' ? 'selected' : ''}>Van</option>
                                    <option value="Three Wheeler" ${vtype eq 'Three Wheeler' ? 'selected' : ''}>Three Wheeler</option>
                                    <option value="Bus"          ${vtype eq 'Bus' ? 'selected' : ''}>Bus</option>
                                    <option value="Lorry"        ${vtype eq 'Lorry' ? 'selected' : ''}>Lorry</option>
                                    <option value="Prime Mover (Long Vehicle)" ${vtype eq 'Prime Mover (Long Vehicle)' ? 'selected' : ''}>Prime Mover (Long Vehicle)</option>
                                </select>
                            </div>
                        </div>

                        <div class="d-flex gap-2" style="gap:12px;margin-top:8px;">
                            <button type="submit" class="btn btn-primary" style="display:inline-flex;align-items:center;gap:6px;">
                                <c:choose>
                                    <c:when test="${empty vehicle}">
                                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg> Create Vehicle
                                    </c:when>
                                    <c:otherwise>
                                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg> Update Vehicle
                                    </c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/vehicles/list" class="btn btn-outline">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    // Live preview of how many students this means
    var capInput = document.getElementById('seatingCapacity');
    var hint = document.getElementById('seatHint');
    function refresh() {
        var n = parseInt(capInput.value, 10);
        if (isNaN(n) || n < 2) { hint.textContent = 'Includes the instructor seat.'; return; }
        var students = n - 1;
        hint.textContent = n + ' total seats - 1 instructor = up to ' + students + ' student' + (students === 1 ? '' : 's') + ' per lesson.';
    }
    capInput.addEventListener('input', refresh);
    refresh();
</script>
</body>
</html>
