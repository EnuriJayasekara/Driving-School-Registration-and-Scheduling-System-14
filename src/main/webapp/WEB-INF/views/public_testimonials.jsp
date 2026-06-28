<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.model.Testimonial" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Reviews | DriveEdu Driving School</title>
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
            padding: 5rem 2rem;
        }

        .container {
            max-width: 1100px;
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

        /* Two Column Grid */
        .reviews-layout {
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            gap: 3.5rem;
            align-items: flex-start;
        }

        .reviews-list {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .review-card {
            background-color: var(--card-light);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 2rem;
            box-shadow: var(--shadow-sm);
            transition: transform 0.3s ease, border-color 0.3s ease;
        }

        .review-card:hover {
            transform: translateY(-2px);
            border-color: rgba(196, 155, 85, 0.3);
            box-shadow: var(--shadow-md);
        }

        .review-stars {
            color: var(--accent-gold);
            font-size: 1rem;
            margin-bottom: 1rem;
            letter-spacing: 2px;
        }

        .review-msg {
            font-size: 0.95rem;
            line-height: 1.6;
            color: var(--text-main);
            font-style: italic;
            margin-bottom: 1.25rem;
        }

        .review-author {
            display: flex;
            flex-direction: column;
        }

        .author-name {
            font-weight: 700;
            color: var(--accent-navy);
            font-size: 0.95rem;
        }

        .author-meta {
            font-size: 0.78rem;
            color: var(--text-muted);
            margin-top: 2px;
            font-weight: 500;
        }

        /* Form styling */
        .form-panel {
            background-color: var(--card-light);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 2.5rem;
            box-shadow: var(--shadow-md);
            position: sticky;
            top: 100px;
        }

        .form-panel h3 {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--accent-navy);
            margin-bottom: 0.5rem;
        }

        .form-panel p {
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
        .form-group select,
        .form-group textarea {
            background-color: var(--bg-light);
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
        .form-group select:focus,
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

        .empty-state {
            background-color: var(--card-light);
            border: 1px dashed var(--border);
            border-radius: var(--radius-md);
            padding: 3rem;
            text-align: center;
            color: var(--text-muted);
            font-size: 1rem;
        }

        /* Responsive Layout */
        @media (max-width: 900px) {
            .reviews-layout {
                grid-template-columns: 1fr;
                gap: 3rem;
            }
            .form-panel {
                position: static;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Student <span>Reviews</span></h1>
        <p>See what our recent graduates say about their training and experience, or submit your own review below.</p>
    </div>

    <div class="reviews-layout">
        
        <!-- Left Column: Testimonials List -->
        <div class="reviews-list">
            <%
                List<Testimonial> testimonials = (List<Testimonial>) request.getAttribute("testimonials");
                if (testimonials != null && !testimonials.isEmpty()) {
                    for (Testimonial t : testimonials) {
                        int rating = t.getRating();
                        StringBuilder stars = new StringBuilder();
                        for (int i = 0; i < rating; i++) {
                            stars.append("★");
                        }
            %>
            <div class="review-card">
                <div class="review-stars"><%= stars.toString() %></div>
                <p class="review-msg">"<%= t.getMessage() %>"</p>
                <div class="review-author">
                    <span class="author-name"><%= t.getStudentName() %></span>
                    <span class="author-meta"><%= t.getLicenseCategory() %></span>
                </div>
            </div>
            <%
                    }
                } else {
            %>
            <div class="empty-state">
                <p>No reviews posted yet. Be the first to share your training experience!</p>
            </div>
            <%
                }
            %>
        </div>

        <!-- Right Column: Add Testimonial Form -->
        <div class="form-panel">
            <h3>Add Your Testimonial</h3>
            <p>Help other students by writing a short review of your driving lessons.</p>
            
            <% if ("success".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success">
                    ✓ Your review has been posted successfully! Thank you for sharing your experience.
                </div>
            <% } else if ("empty".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger">
                    ⚠ Please fill in both your name and review message fields.
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/testimonials" method="POST" class="testimonial-form">
                <div class="form-group">
                    <label for="studentName">Your Full Name</label>
                    <input type="text" id="studentName" name="studentName" placeholder="e.g. Dilhan Perera" required>
                </div>

                <div class="form-group">
                    <label for="rating">Rating (Stars)</label>
                    <select id="rating" name="rating" required>
                        <option value="5">★★★★★ (5 Stars)</option>
                        <option value="4">★★★★☆ (4 Stars)</option>
                        <option value="3">★★★☆☆ (3 Stars)</option>
                        <option value="2">★★☆☆☆ (2 Stars)</option>
                        <option value="1">★☆☆☆☆ (1 Star)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="licenseCategory">Course / License Category</label>
                    <input type="text" id="licenseCategory" name="licenseCategory" placeholder="e.g. B-Class Car Graduate" required>
                </div>
                
                <div class="form-group">
                    <label for="message">Your Review</label>
                    <textarea id="message" name="message" rows="4" placeholder="Describe your training experience, your instructor patience, and if you passed first-time..." required></textarea>
                </div>
                
                <button type="submit" class="submit-btn">Submit Review</button>
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
