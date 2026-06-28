<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head><meta charset="UTF-8"><title>Vehicles &ndash; DriveEdu</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=22.0"></head>
<body>
<div class="wrapper">
  <jsp:include page="../sidebar.jsp"/>
  <div class="main-content">
    <div class="topbar">
      <span class="topbar-title">
        <svg class="nav-icon-svg" style="margin-right:6px;" viewBox="0 0 24 24"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
        Vehicles
      </span>
      <div class="topbar-right"><a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-sm">Logout</a></div>
    </div>
    <div class="page-body">
      <div class="page-header d-flex justify-between align-center">
        <div>
          <div class="breadcrumb"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a> &rsaquo; Vehicles</div>
          <h2>Fleet Management</h2>
        </div>
        <a href="${pageContext.request.contextPath}/admin/vehicles/new" class="btn btn-primary">&#43; Add Vehicle</a>
      </div>
      <c:if test="${param.msg eq 'created'}"><div class="alert alert-success">&#10003; Vehicle added.</div></c:if>
      <c:if test="${param.msg eq 'updated'}"><div class="alert alert-success">&#10003; Vehicle updated.</div></c:if>
      <c:if test="${param.msg eq 'deleted'}"><div class="alert alert-warning">&#9888; Vehicle removed.</div></c:if>
      <div class="card">
        <div class="card-header"><h3>All Vehicles (${vehicles.size()})</h3></div>
        <div class="card-body">
          <table class="table">
            <thead>
            <tr>
              <th>#</th><th>Reg No</th><th>Type</th><th>Make</th><th>Model</th><th>Year</th>
              <th>Transmission</th><th>Fuel</th><th>Seats</th><th>Status</th><th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
              <c:when test="${empty vehicles}">
                <tr><td colspan="11" class="text-center" style="padding:40px;color:#64748B">No vehicles found.</td></tr>
              </c:when>
              <c:otherwise>
                <c:forEach var="v" items="${vehicles}" varStatus="vs">
                  <tr>
                    <td>${vs.index+1}</td>
                    <td><strong>${v.registrationNo}</strong></td>
                    <td>
                      <c:set var="vdisp" value="" />
                      <c:choose>
                        <c:when test="${v.vehicleType eq 'Car'}">
                          <c:set var="vdisp" value="car(${v.transmissionType eq 'automatic' ? 'auto' : 'manual'})" />
                        </c:when>
                        <c:when test="${v.vehicleType eq 'Bike'}">
                          <c:set var="vdisp" value="bike(${v.fuelType eq 'electric' ? 'electric' : (v.transmissionType eq 'automatic' ? 'auto' : 'manual')})" />
                        </c:when>
                        <c:when test="${v.vehicleType eq 'Van'}">
                          <c:set var="vdisp" value="van(${v.transmissionType eq 'automatic' ? 'auto' : 'manual'})" />
                        </c:when>
                        <c:when test="${v.vehicleType eq 'Three Wheeler'}">
                          <c:set var="vdisp" value="three wheeler(${v.fuelType eq 'electric' ? 'electric' : (v.transmissionType eq 'automatic' ? 'auto' : 'manual')})" />
                        </c:when>
                        <c:when test="${v.vehicleType eq 'Bus'}">
                          <c:set var="vdisp" value="bus" />
                        </c:when>
                        <c:when test="${v.vehicleType eq 'Lorry'}">
                          <c:set var="vdisp" value="lorry" />
                        </c:when>
                        <c:when test="${v.vehicleType eq 'Prime Mover (Long Vehicle)'}">
                          <c:set var="vdisp" value="Prime Mover (Long Vehicle)" />
                        </c:when>
                        <c:otherwise>
                          <c:choose>
                            <c:when test="${v.category eq 'Car' or v.category eq 'Light Vehicle'}">
                              <c:set var="vdisp" value="car(${v.transmissionType eq 'automatic' ? 'auto' : 'manual'})" />
                            </c:when>
                            <c:when test="${v.category eq 'Bike' or v.category eq 'Motorcycle'}">
                              <c:set var="vdisp" value="bike(${v.fuelType eq 'electric' ? 'electric' : (v.transmissionType eq 'automatic' ? 'auto' : 'manual')})" />
                            </c:when>
                            <c:when test="${v.category eq 'Van'}">
                              <c:set var="vdisp" value="van(${v.transmissionType eq 'automatic' ? 'auto' : 'manual'})" />
                            </c:when>
                            <c:when test="${v.category eq 'Bus'}">
                              <c:set var="vdisp" value="bus" />
                            </c:when>
                            <c:when test="${v.category eq 'Lorry'}">
                              <c:set var="vdisp" value="lorry" />
                            </c:when>
                            <c:when test="${v.category eq 'Prime Mover (Long Vehicle)'}">
                              <c:set var="vdisp" value="Prime Mover (Long Vehicle)" />
                            </c:when>
                            <c:otherwise>
                              <c:set var="vdisp" value="${not empty v.vehicleType ? v.vehicleType : v.category}" />
                            </c:otherwise>
                          </c:choose>
                        </c:otherwise>
                      </c:choose>
                      <span class="badge badge-info" style="text-transform: none; font-weight: 600;">${vdisp}</span>
                    </td>
                    <td>${v.make}</td><td>${v.model}</td><td>${v.year}</td>
                    <td><span class="badge badge-info">${v.transmissionType}</span></td>
                    <td>${v.fuelType}</td>
                    <td style="text-align:center;">
                      <strong>${v.seatingCapacity}</strong>
                      <br><small style="color:#888;">${v.studentCapacity} stu.</small>
                    </td>
                    <td>
                      <c:choose>
                        <c:when test="${v.status eq 'available'}">  <span class="badge badge-success">Available</span></c:when>
                        <c:when test="${v.status eq 'in_use'}">     <span class="badge badge-warning">In Use</span></c:when>
                        <c:when test="${v.status eq 'maintenance'}"><span class="badge badge-danger">Maintenance</span></c:when>
                        <c:otherwise><span class="badge badge-gray">${v.status}</span></c:otherwise>
                      </c:choose>
                    </td>
                    <td>
                      <a href="${pageContext.request.contextPath}/admin/vehicles/edit?id=${v.vehicleId}" class="btn btn-outline btn-sm" style="display:inline-flex;align-items:center;" title="Edit">
                        <svg class="nav-icon-svg" style="width:12px;height:12px;" viewBox="0 0 24 24"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path><path d="M18.5 2.5a2.121 2.121 0 1 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path></svg>
                      </a>
                      <a href="${pageContext.request.contextPath}/admin/vehicles/delete?id=${v.vehicleId}" class="btn btn-danger btn-sm" style="display:inline-flex;align-items:center;" onclick="return confirm('Delete vehicle?')" title="Delete">
                        <svg class="nav-icon-svg" style="width:12px;height:12px;stroke:#fff;" viewBox="0 0 24 24"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                      </a>
                    </td>
                  </tr>
                </c:forEach>
              </c:otherwise>
            </c:choose>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</div>
</body>
</html>
