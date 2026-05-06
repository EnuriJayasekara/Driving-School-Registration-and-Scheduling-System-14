<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us | DriveEdu Driving School</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-light: #F0F4F8; 
            --card-light: #FFFFFF;
            --accent-gold: #C49B55;
            --accent-navy: #08274A;
            --text-main: #0F172A;
            --text-muted: #64748B;
            --border: #E2E8F0;
            --success: #10B981;
            --danger: #EF4444;
            --shadow-sm: 0 4px 6px -1px rgba(15, 23, 42, 0.04);
            --shadow-md: 0 10px 15px -3px rgba(15, 23, 42, 0.05);
            --shadow-lg: 0 20px 25px -5px rgba(15, 23, 42, 0.08);
            --radius-lg: 20px;
            --radius-md: 12px;
            --radius-sm: 8px;
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
            padding: 6rem 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            max-width: 1100px;
            width: 100%;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 4rem;
        }

        .header h1 {
            font-size: 2.8rem;
            font-weight: 800;
            color: var(--accent-navy);
            letter-spacing: -0.03em;
            margin-bottom: 0.75rem;
        }

        .header h1 span {
            color: var(--accent-gold);
            background: linear-gradient(135deg, var(--accent-gold), #dfb872);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header p {
            color: var(--text-muted);
            font-size: 1.1rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
        }

        /* Two-Column Grid */
        .contact-grid {
            display: grid;
            grid-template-columns: 1fr 1.1fr;
            gap: 4rem;
            align-items: flex-start;
            background-color: var(--card-light);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 4rem;
            box-shadow: var(--shadow-md);
        }

        .details-col {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .details-col h2 {
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--accent-navy);
            margin-bottom: 1.25rem;
        }

        .details-col p {
            font-size: 1rem;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 2.5rem;
        }

        .details-list {
            display: flex;
            flex-direction: column;
            gap: 1.75rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 1.25rem;
        }

        .icon-box {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background-color: rgba(196, 155, 85, 0.08);
            border: 1px solid rgba(196, 155, 85, 0.15);
            color: var(--accent-gold);
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .item-label {
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 700;
            color: var(--text-muted);
            letter-spacing: 0.05em;
        }

        .item-value {
            font-size: 1rem;
            font-weight: 700;
            color: var(--accent-navy);
            margin-top: 2px;
        }

        /* Form styling */
        .form-col {
            background-color: var(--bg-light);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 2.5rem;
        }

        .form-col h3 {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--accent-navy);
            margin-bottom: 0.5rem;
        }

        .form-col p {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-bottom: 2rem;
        }

        .alert {
            padding: 1rem 1.25rem;
            border-radius: var(--radius-sm);
            font-size: 0.88rem;
            margin-bottom: 1.5rem;
            font-weight: 600;
            line-height: 1.5;
        }

        .alert-success {
            background-color: rgba(16, 185, 129, 0.1);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.2);
        }

        .alert-danger {
            background-color: rgba(239, 68, 68, 0.1);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.2);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-bottom: 1.25rem;
        }

        .form-group label {
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
        }

        .form-group input,
        .form-group textarea {
            background-color: var(--card-light);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            padding: 0.85rem 1rem;
            color: var(--text-main);
            font-family: inherit;
            font-size: 0.95rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
            width: 100%;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            border-color: var(--accent-gold);
            box-shadow: 0 0 0 3px rgba(196, 155, 85, 0.1);
        }

        .form-group textarea {
            resize: vertical;
        }

        .submit-btn {
            background-color: var(--accent-navy);
            color: #FFFFFF;
            border: none;
            border-radius: var(--radius-sm);
            padding: 1rem;
            font-size: 0.95rem;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            width: 100%;
            margin-top: 0.5rem;
        }

        .submit-btn:hover {
            background-color: var(--accent-gold);
            color: var(--accent-navy);
            transform: translateY(-1px);
        }

        .back-nav {
            margin-top: 4rem;
            text-align: center;
        }

        .back-btn {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 0.95rem;
            font-weight: 600;
            transition: color 0.2s, transform 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .back-btn:hover {
            color: var(--accent-navy);
            transform: translateX(-4px);
        }

        /* Responsive Layout */
        @media (max-width: 900px) {
            .contact-grid {
                grid-template-columns: 1fr;
                gap: 3rem;
                padding: 2.5rem;
            }
            body {
                padding: 4rem 1rem;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Get in <span>Touch</span></h1>
        <p>Have questions about courses, class registrations, or schedules? Contact us directly below.</p>
    </div>

    <div class="contact-grid">
        <!-- Details Column -->
        <div class="details-col">
            <h2>Contact Information</h2>
            <p>Our support team and instructors are here to help guide you. Please give us a call or write to us anytime.</p>
            
            <div class="details-list">
                <div class="detail-item">
                    <div class="icon-box">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path></svg>
                    </div>
                    <div>
                        <span class="item-label">Phone Number</span>
                        <p class="item-value">+94 11 234 5678</p>
                    </div>
                </div>
                
                <div class="detail-item">
                    <div class="icon-box">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path><polyline points="22,6 12,13 2,6"></polyline></svg>
                    </div>
                    <div>
                        <span class="item-label">Email Address</span>
                        <p class="item-value">info@drivingschool.lk</p>
                    </div>
                </div>

                <div class="detail-item">
                    <div class="icon-box">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"></circle><polyline points="12,6 12,12 16,14"></polyline></svg>
                    </div>
                    <div>
                        <span class="item-label">Operating Hours</span>
                        <p class="item-value">Mon - Sat: 8:00 AM - 6:00 PM</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Form Column -->
        <div class="form-col">
            <h3>Send a Message</h3>
            <p>Submit your inquiry below and we'll reply shortly.</p>
            
            <% if ("sent".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success">
                    ✓ Your inquiry has been sent successfully. Both instructors and admins have been notified!
                </div>
            <% } else if ("contact_empty".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger">
                    ⚠ Please fill in both the phone number and message fields.
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/contact" method="POST" class="contact-form">
                <div class="form-group">
                    <label for="phone">Contact Phone Number</label>
                    <input type="text" id="phone" name="phone" placeholder="e.g. 0771234567" required>
                </div>
                
                <div class="form-group">
                    <label for="message">Your Message</label>
                    <textarea id="message" name="message" rows="4" placeholder="Describe your inquiry..." required></textarea>
                </div>
                
                <button type="submit" class="submit-btn">Send Inquiry</button>
            </form>
        </div>
    </div>

    <div class="back-nav">
        <a href="${pageContext.request.contextPath}/" class="back-btn">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12,19 5,12 12,5"></polyline></svg>
            Back to Homepage
        </a>
    </div>
</div>

</body>
</html>
