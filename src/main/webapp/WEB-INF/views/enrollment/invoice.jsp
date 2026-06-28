<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.model.Enrollment" %>
<%@ page import="com.drivingschool.model.Course" %>
<%@ page import="com.drivingschool.model.Student" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Invoice | DriveEdu Driving School</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-light: #F8F9FA; /* Light Background */
            --card-light: #FFFFFF; /* White */
            --accent: #C49B55; /* Golden Yellow */
            --accent-hover: #061E3B; /* Hover Yellow */
            --text-main: #212529; /* Main Text */
            --text-muted: #606165; /* Secondary Text */
            --border: #E2E8F0;
            --success: #16A34A;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }

        .invoice-card {
            background-color: var(--card-light);
            border: 1px solid var(--border);
            border-radius: 16px;
            width: 100%;
            max-width: 850px;
            box-shadow: 0 10px 40px rgba(15, 23, 42, 0.06);
            overflow: hidden;
            padding: 3rem;
            position: relative;
        }

        .invoice-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--accent), var(--success));
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 1px solid var(--border);
            padding-bottom: 2rem;
            margin-bottom: 2.5rem;
        }

        .logo-section h1 {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.025em;
            color: var(--text-main);
        }

        .logo-section h1 span {
            color: var(--accent);
        }

        .logo-section p {
            color: var(--text-muted);
            font-size: 0.875rem;
            margin-top: 0.25rem;
        }

        .invoice-details {
            text-align: right;
        }

        .invoice-details h2 {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--accent);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .invoice-details p {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-top: 0.35rem;
        }

        .meta-grid {
            display: grid;
            grid-template-columns: 1.2fr 1fr;
            gap: 3rem;
            margin-bottom: 3rem;
        }

        .meta-block h3 {
            font-size: 0.9rem;
            font-weight: 800;
            color: var(--accent);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 1rem;
        }

        .meta-block p {
            font-size: 0.95rem;
            color: var(--text-main);
            line-height: 1.6;
            margin-bottom: 4px;
        }

        .table-container {
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 2.5rem;
            background-color: rgba(255, 255, 255, 0.01);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background-color: rgba(15, 23, 42, 0.02);
            text-align: left;
            padding: 1.25rem 1.5rem;
            font-size: 0.85rem;
            font-weight: 800;
            text-transform: uppercase;
            color: var(--accent);
            letter-spacing: 0.05em;
            border-bottom: 1px solid var(--border);
        }

        td {
            padding: 1.5rem 1.5rem;
            font-size: 0.95rem;
            color: var(--text-main);
            border-bottom: 1px solid var(--border);
            vertical-align: top;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .total-section {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            margin-top: 2rem;
            padding-top: 1rem;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            width: 320px;
            font-size: 0.95rem;
            margin-bottom: 0.65rem;
            color: var(--text-main);
        }

        .total-row.grand-total {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--accent);
            margin-top: 1rem;
            border-top: 1px solid var(--border);
            padding-top: 1.25rem;
        }

        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.65rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            background-color: rgba(22, 163, 74, 0.08);
            color: var(--success);
            border: 1px solid rgba(22, 163, 74, 0.15);
            letter-spacing: 0.05em;
        }

        .actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 3.5rem;
            border-top: 1px solid var(--border);
            padding-top: 2rem;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 700;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
        }

        .btn-primary {
            background-color: var(--accent);
            color: #000;
        }

        .btn-primary:hover {
            background-color: var(--accent-hover);
        }

        .btn-secondary {
            background-color: transparent;
            color: var(--text-muted);
            border: 1px solid var(--border);
        }

        .btn-secondary:hover {
            color: var(--text-main);
            background-color: rgba(255, 255, 255, 0.05);
        }

        /* Print styling rules */
        @media print {
            body {
                background-color: #fff;
                color: #000;
                padding: 0;
                display: block;
            }
            .invoice-card {
                border: none;
                box-shadow: none;
                padding: 0;
                max-width: 100%;
            }
            .invoice-card::before, .actions, .status-badge {
                display: none !important;
            }
            td, th {
                color: #000 !important;
                border-bottom: 1px solid #ddd !important;
            }
            .total-row.grand-total {
                color: #000 !important;
            }
            .logo-section h1 span, .invoice-details h2, .meta-block h3 {
                color: #000 !important;
            }
        }
    </style>
</head>
<body>

<%
    Enrollment enrollment = (Enrollment) request.getAttribute("enrollment");
    Course course = (Course) request.getAttribute("course");
    Student student = (Student) request.getAttribute("student");
%>

<div class="invoice-card">
    <div class="header">
        <div class="logo-section">
            <h1>Drive<span>Edu</span></h1>
            <p>Professional Driving School &amp; Training</p>
        </div>
        <div class="invoice-details">
            <h2>Invoice</h2>
            <p>Invoice #: INV-2026-<%= enrollment != null ? enrollment.getEnrollmentId() : "0000" %></p>
            <p>Date: <%= enrollment != null && enrollment.getEnrollmentDate() != null ? enrollment.getEnrollmentDate() : java.time.LocalDate.now() %></p>
        </div>
    </div>

    <div class="meta-grid">
        <div class="meta-block">
            <h3>Billed To:</h3>
            <p><strong><%= student != null && student.getFullName() != null ? student.getFullName() : "Valued Student" %></strong></p>
            <p><span style="color: var(--text-muted);">NIC:</span> <%= student != null ? student.getNicNumber() : "N/A" %></p>
            <p><span style="color: var(--text-muted);">Phone:</span> <%= student != null ? student.getPhone() : "N/A" %></p>
            <p><span style="color: var(--text-muted);">Address:</span> <%= student != null ? student.getAddress() : "N/A" %></p>
        </div>
        <div class="meta-block">
            <h3>Payment Details:</h3>
            <p><span style="color: var(--text-muted);">Method:</span> Online Card Payment</p>
            <p><span style="color: var(--text-muted);">Card:</span> <%= enrollment != null ? enrollment.getNotes() : "N/A" %></p>
            <p><span style="color: var(--text-muted);">Status:</span> <span class="status-badge"><%= enrollment != null ? enrollment.getPaymentStatus() : "PAID" %></span></p>
        </div>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Course Category / Name</th>
                    <th style="text-align: right; width: 140px;">Unit Price</th>
                    <th style="text-align: right; width: 140px;">Total</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <strong style="font-size: 1.05rem; display: block; margin-bottom: 6px;"><%= course != null ? course.getCourseName() : "Standard Driving Package" %></strong>
                        <span style="font-size: 0.825rem; color: var(--text-muted); line-height: 1.4; display: block;">Includes Theory Classes, Practical sessions &amp; License exams scheduling. License Type: <%= course != null ? course.getLicenseCategory() : "B" %></span>
                    </td>
                    <td style="text-align: right;">
                        <span style="color: var(--text-muted); font-size: 0.8rem; display: block; margin-bottom: 6px; font-weight: 500;">LKR</span>
                        <strong><%= course != null ? course.getPrice() : "0.00" %></strong>
                    </td>
                    <td style="text-align: right;">
                        <span style="color: var(--text-muted); font-size: 0.8rem; display: block; margin-bottom: 6px; font-weight: 500;">LKR</span>
                        <strong><%= course != null ? course.getPrice() : "0.00" %></strong>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="total-section">
        <div class="total-row">
            <span style="color: var(--text-muted);">Subtotal:</span>
            <span>LKR <%= course != null ? course.getPrice() : "0.00" %></span>
        </div>
        <div class="total-row">
            <span style="color: var(--text-muted);">Tax (0%):</span>
            <span>LKR 0.00</span>
        </div>
        <div class="total-row grand-total">
            <span>Amount Paid:</span>
            <span>LKR <%= enrollment != null ? enrollment.getAmountPaid() : "0.00" %></span>
        </div>
    </div>

    <div class="actions">
        <a href="<%= request.getContextPath() %>/student/dashboard" class="btn btn-secondary">&larr; Back to Dashboard</a>
        <button onclick="window.print();" class="btn btn-primary">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="feather feather-printer"><polyline points="6 9 6 2 18 2 18 9"></polyline><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path><rect x="6" y="14" width="12" height="8"></rect></svg>
            Print Invoice
        </button>
    </div>
</div>

</body>
</html>
