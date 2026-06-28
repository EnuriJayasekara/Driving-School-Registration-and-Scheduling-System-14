<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.drivingschool.service.VehicleService" %>
<%@ page import="com.drivingschool.model.Vehicle" %>
<%@ page import="com.drivingschool.service.TestimonialService" %>
<%@ page import="com.drivingschool.model.Testimonial" %>
<%@ page import="java.util.List" %>
<%
    VehicleService indexVehService = new VehicleService();
    List<Vehicle> allIndexVehicles = null;
    int lightCount = 0;
    int heavyCount = 0;
    int motorcycleCount = 0;
    try {
        allIndexVehicles = indexVehService.listAll();
        if (allIndexVehicles != null) {
            for (Vehicle v : allIndexVehicles) {
                int capacity = v.getSeatingCapacity();
                String category = v.getCategory() != null ? v.getCategory().toLowerCase() : "";
                if (capacity == 1 || category.contains("motorcycle") || category.contains("bike")) {
                    motorcycleCount++;
                } else if (capacity > 1 && capacity < 10) {
                    lightCount++;
                } else if (capacity >= 10 || category.contains("heavy") || category.contains("truck")) {
                    heavyCount++;
                }
            }
        }
    } catch (Exception ex) {
        // Fallback to 0 if database is offline or not configured yet
    }

    TestimonialService indexTestimonialService = new TestimonialService();
    Testimonial latestTestimonial = null;
    try {
        List<Testimonial> testimonials = indexTestimonialService.listApproved();
        if (testimonials != null && !testimonials.isEmpty()) {
            latestTestimonial = testimonials.get(0);
        }
    } catch (Exception ex) {
        // Fallback
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>DriveEdu – Driving School Management System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=21.4">
  <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <style>
      /* Modern Variables & Global Style Overrides */
      :root {
          --ds-navy: #08274A;
          --ds-navy-dark: #041528;
          --ds-navy-light: #1A3C63;
          --ds-gold: #C49B55;
          --ds-gold-hover: #DAB26E;
          --ds-gold-pale: rgba(196, 155, 85, 0.08);
          --ds-blue: #2563EB;
          --ds-blue-hover: #1D4ED8;
          --ds-blue-light: rgba(37, 99, 235, 0.08);
          --ds-white: #FFFFFF;
          --ds-text-bright: #F3F4F6;
          --ds-text-muted-light: #D1D5DB;
          --ds-radius-lg: 20px;
          --ds-radius-md: 12px;
          --ds-radius-sm: 8px;
          --ds-shadow-sm: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
          --ds-shadow-md: 0 10px 15px -3px rgba(0, 0, 0, 0.2);
          --ds-shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.3);
          --ds-font-primary: 'Plus Jakarta Sans', sans-serif;
          --ds-font-secondary: 'Poppins', sans-serif;
      }

      /* Single-Screen Layout Reset */
      html, body {
          margin: 0;
          padding: 0;
          height: 100%;
          font-family: var(--ds-font-secondary);
          background-color: #F0F4F8; /* premium soft slate-blue/white background compatible across all pages */
          color: #0F172A; /* dark text */
          overflow: hidden;
          -webkit-font-smoothing: antialiased;
      }

      body {
          display: flex;
          flex-direction: column;
          justify-content: space-between;
      }

      .ds-container {
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 24px;
          width: 100%;
          box-sizing: border-box;
      }

      /* Buttons - Ultra High Contrast */
      .ds-btn {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 12px 28px;
          font-family: var(--ds-font-primary);
          font-size: 0.95rem;
          font-weight: 700;
          border-radius: var(--ds-radius-sm);
          text-decoration: none;
          transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
          cursor: pointer;
          border: none;
      }
      .ds-btn-gold {
          background-color: var(--ds-gold);
          color: var(--ds-navy) !important;
          box-shadow: 0 4px 12px rgba(196, 155, 85, 0.3);
      }
      .ds-btn-gold:hover {
          background-color: var(--ds-gold-hover);
          transform: translateY(-2px);
          box-shadow: 0 6px 16px rgba(196, 155, 85, 0.5);
      }
      .ds-btn-primary-gold {
          background: var(--ds-navy); /* matching dashboard primary buttons */
          color: #FFFFFF !important;
          box-shadow: 0 4px 15px rgba(8, 39, 74, 0.2);
      }
      .ds-btn-primary-gold:hover {
          background: var(--ds-gold);
          color: var(--ds-navy) !important;
          transform: translateY(-2px);
          box-shadow: 0 6px 20px rgba(196, 155, 85, 0.4);
      }
      .ds-btn-outline-gold {
          background-color: transparent;
          color: var(--ds-navy) !important;
          border: 2px solid var(--ds-gold);
      }
      .ds-btn-outline-gold:hover {
          background-color: var(--ds-gold-pale);
          transform: translateY(-2px);
          box-shadow: 0 4px 12px rgba(196, 155, 85, 0.15);
      }

      /* Header Navbar Style */
      .ds-navbar {
          background: #061220; /* distinct dark navy slate */
          backdrop-filter: blur(20px);
          -webkit-backdrop-filter: blur(20px);
          border-bottom: 2px solid var(--ds-gold); /* gold accent line for high contrast */
          height: 80px;
          flex-shrink: 0;
          box-shadow: 0 4px 30px rgba(0, 0, 0, 0.4);
          z-index: 100;
          position: relative;
      }
      .ds-nav-container {
          display: flex;
          justify-content: space-between;
          align-items: center;
          height: 80px;
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 24px;
      }
      .ds-brand {
          font-family: var(--ds-font-primary);
          font-size: 1.5rem;
          font-weight: 800;
          color: var(--ds-white);
          text-decoration: none;
          display: flex;
          align-items: center;
          gap: 10px;
      }
      .ds-brand-icon {
          color: var(--ds-gold);
          filter: drop-shadow(0 0 6px rgba(196, 155, 85, 0.5));
          flex-shrink: 0;
      }
      .ds-nav-links {
          display: flex;
          align-items: center;
          gap: 32px;
      }
      .ds-nav-link {
          font-family: var(--ds-font-primary);
          color: var(--ds-text-muted-light);
          text-decoration: none;
          font-weight: 600;
          font-size: 0.95rem;
          transition: color 0.25s ease;
          position: relative;
          padding: 6px 0;
      }
      .ds-nav-link::after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 0;
          width: 0;
          height: 2px;
          background-color: var(--ds-gold);
          transition: width 0.25s ease;
      }
      .ds-nav-link:hover {
          color: var(--ds-white);
      }
      .ds-nav-link:hover::after {
          width: 100%;
      }
      .ds-nav-link.active {
          color: var(--ds-white);
      }
      .ds-nav-link.active::after {
          width: 100%;
      }      /* Compact Main Hero Container */
      .ds-hero-section {
          flex-grow: 1;
          display: flex;
          position: relative;
          box-sizing: border-box;
          padding: 0;
          overflow: hidden;
      }
 
      .ds-hero-glow-1 {
          position: absolute;
          top: -10%;
          right: -10%;
          width: 50%;
          height: 50%;
          background: radial-gradient(circle, rgba(196, 155, 85, 0.15) 0%, rgba(4, 21, 40, 0) 70%);
          z-index: 1;
          pointer-events: none;
      }
      .ds-hero-glow-2 {
          position: absolute;
          bottom: -20%;
          left: -10%;
          width: 60%;
          height: 60%;
          background: radial-gradient(circle, rgba(26, 60, 99, 0.3) 0%, rgba(4, 21, 40, 0) 75%);
          z-index: 1;
          pointer-events: none;
      }
 
      /* Stacking Carousel Slider Layout */
      .ds-carousel {
          position: relative;
          width: 100%;
          height: 100%;
          z-index: 5;
      }
      .ds-carousel-inner {
          display: grid;
          grid-template-columns: 1fr;
          align-items: center;
          width: 100%;
          height: 100%;
      }
 
      /* Slide cross-fade configuration */
      .ds-slide {
          grid-area: 1 / 1 / 2 / 2;
          display: none;
          align-items: center;
          width: 100%;
          height: calc(100vh - 140px);
          position: relative;
          overflow: hidden;
      }
      .ds-slide.active {
          display: flex;
          animation: dsFadeIn 0.8s cubic-bezier(0.16, 1, 0.3, 1) forwards;
      }
      .ds-slide-bg {
          position: absolute;
          top: 0;
          left: 0;
          width: 100%;
          height: 100%;
          background-size: cover;
          background-position: center;
          background-repeat: no-repeat;
          filter: blur(1.5px); /* Extremely subtle blur to soften details */
          transform: scale(1.03); /* scale up slightly to hide blurred edges */
          z-index: 1;
      }
      .ds-container {
          position: relative;
          z-index: 2;
          width: 100%;
          max-width: 1200px;
          margin: 0 auto;
          padding: 0 24px;
      }
      @keyframes dsFadeIn {
          from {
              opacity: 0;
              transform: translateY(12px);
          }
          to {
              opacity: 1;
              transform: translateY(0);
          }
      }
      .ds-slide-grid {
          display: grid;
          grid-template-columns: 1.15fr 0.85fr;
          gap: 60px;
          align-items: center;
          width: 100%;
          z-index: 5;
          position: relative;
      }
 
      /* Content Column Styling - High Readability Fonts */
      .ds-hero-content {
          max-width: 580px;
          z-index: 5;
      }
      .ds-badge {
          background: var(--ds-gold-pale);
          color: var(--ds-gold);
          border: 1px solid rgba(196, 155, 85, 0.3);
          font-family: var(--ds-font-primary);
          font-weight: 800;
          font-size: 0.8rem;
          letter-spacing: 0.08em;
          padding: 8px 18px;
          border-radius: 50px;
          display: inline-flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 24px;
      }
      .ds-badge-dot {
          width: 6px;
          height: 6px;
          border-radius: 50%;
          background-color: var(--ds-gold);
          box-shadow: 0 0 8px var(--ds-gold);
          animation: ds-pulse 2s infinite;
      }
      @keyframes ds-pulse {
          0% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(196, 155, 85, 0.5); }
          70% { transform: scale(1); box-shadow: 0 0 0 6px rgba(196, 155, 85, 0); }
          100% { transform: scale(0.95); box-shadow: 0 0 0 0 rgba(196, 155, 85, 0); }
      }
      .ds-hero-title {
          font-family: var(--ds-font-primary);
          font-size: 3.4rem;
          font-weight: 800;
          line-height: 1.15;
          letter-spacing: -0.02em;
          margin: 0 0 20px 0;
          color: var(--ds-navy) !important; /* Theme navy title text */
      }
      .ds-text-gradient {
          background: linear-gradient(135deg, var(--ds-gold) 0%, #DAB26E 100%);
          -webkit-background-clip: text;
          -webkit-text-fill-color: transparent;
      }
      .ds-hero-text {
          font-size: 1.05rem;
          color: #334155; /* slate grey readable description text */
          line-height: 1.65;
          margin: 0 0 32px 0;
          font-weight: 400;
      }
      .ds-hero-cta {
          display: flex;
          gap: 16px;
          flex-wrap: wrap;
      }

      /* Visual Column elements */
      .ds-hero-visual {
          position: relative;
          display: flex;
          justify-content: center;
          align-items: center;
      }
      .ds-image-wrapper {
          position: relative;
          width: 100%;
          max-width: 440px;
      }
      .ds-hero-img {
          width: 100%;
          height: auto;
          border-radius: var(--ds-radius-lg);
          filter: drop-shadow(0 20px 40px rgba(0, 0, 0, 0.4));
      }
      .ds-glass-stat {
          background: rgba(255, 255, 255, 0.08);
          backdrop-filter: blur(20px);
          -webkit-backdrop-filter: blur(20px);
          border: 1px solid rgba(255, 255, 255, 0.15);
          padding: 14px 20px;
          border-radius: var(--ds-radius-md);
          position: absolute;
          box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
          display: flex;
          flex-direction: column;
          gap: 2px;
          animation: float 6s ease-in-out infinite;
      }
      .ds-stat-1 {
          top: 10%;
          left: -10%;
      }
      .ds-stat-2 {
          bottom: 12%;
          right: -5%;
          animation-delay: 3s;
      }
      .ds-glass-stat-static {
          background: rgba(255, 255, 255, 0.65); /* More transparent card background */
          backdrop-filter: blur(12px);
          -webkit-backdrop-filter: blur(12px);
          border: 1px solid rgba(255, 255, 255, 0.4);
          padding: 16px 24px;
          border-radius: var(--ds-radius-md);
          box-shadow: 0 12px 30px rgba(8, 39, 74, 0.05);
          display: flex;
          flex-direction: column;
          gap: 4px;
          width: 200px;
          animation: float 6s ease-in-out infinite;
          text-align: left;
          transition: all 0.3s ease;
      }
      .ds-glass-stat-static:hover {
          background: rgba(255, 255, 255, 0.85);
          border-color: var(--ds-gold);
          transform: translateY(-4px);
          box-shadow: 0 16px 36px rgba(196, 155, 85, 0.14);
      }
      .ds-glass-stat-static:nth-child(2) {
          animation-delay: 3s;
      }
      .ds-glass-stats-container {
          display: flex;
          gap: 20px;
          flex-direction: column;
          align-items: flex-end;
          width: 100%;
      }
      @keyframes float {
          0% { transform: translateY(0px); }
          50% { transform: translateY(-8px); }
          100% { transform: translateY(0px); }
      }
      .ds-stat-number {
          font-family: var(--ds-font-primary);
          font-weight: 800;
          font-size: 1.25rem;
          color: var(--ds-gold);
      }
      .ds-stat-label {
          font-size: 0.7rem;
          color: #64748B; /* readable slate grey label */
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.05em;
      }

      /* Slide 2: Key Advantages Stack List */
      .ds-advantages-stack {
          display: flex;
          flex-direction: column;
          gap: 16px;
          width: 100%;
          max-width: 440px;
      }
      .ds-advantage-glass-card {
          background: rgba(255, 255, 255, 0.65); /* More transparent card background */
          backdrop-filter: blur(12px);
          -webkit-backdrop-filter: blur(12px);
          border: 1px solid rgba(255, 255, 255, 0.4);
          padding: 16px 20px;
          border-radius: var(--ds-radius-md);
          display: flex;
          align-items: center;
          gap: 16px;
          transition: all 0.3s ease;
          box-shadow: 0 10px 24px rgba(8, 39, 74, 0.04);
      }
      .ds-advantage-glass-card:hover {
          background: rgba(255, 255, 255, 0.85);
          border-color: var(--ds-gold);
          transform: translateX(6px);
          box-shadow: 0 14px 30px rgba(196, 155, 85, 0.12);
      }
      .ds-adv-icon {
          width: 44px;
          height: 44px;
          border-radius: 50%;
          background: var(--ds-gold-pale);
          color: var(--ds-gold);
          border: 1px solid rgba(196, 155, 85, 0.2);
          display: flex;
          align-items: center;
          justify-content: center;
          flex-shrink: 0;
      }
      .ds-advantage-glass-card h4 {
          font-family: var(--ds-font-primary);
          font-size: 0.95rem;
          font-weight: 700;
          margin: 0 0 2px 0;
          color: var(--ds-navy);
      }
      .ds-advantage-glass-card p {
          font-size: 0.8rem;
          color: #475569;
          margin: 0;
          line-height: 1.4;
      }

      /* Slide 3: Statistics 2x2 grid */
      .ds-stats-2x2 {
          display: grid;
          grid-template-columns: 1fr 1fr;
          gap: 20px;
          width: 100%;
          max-width: 440px;
      }
      .ds-stat-glass-card {
          background: rgba(255, 255, 255, 0.65); /* More transparent card background */
          backdrop-filter: blur(12px);
          -webkit-backdrop-filter: blur(12px);
          border: 1px solid rgba(255, 255, 255, 0.4);
          padding: 24px;
          border-radius: var(--ds-radius-md);
          text-align: center;
          box-shadow: 0 12px 28px rgba(8, 39, 74, 0.05);
          transition: all 0.3s ease;
      }
      .ds-stat-glass-card:hover {
          background: rgba(255, 255, 255, 0.85);
          transform: translateY(-4px);
          border-color: var(--ds-gold);
          box-shadow: 0 16px 36px rgba(196, 155, 85, 0.12);
      }
      .ds-stats-2x2 h3 {
          font-family: var(--ds-font-primary);
          font-size: 2.2rem;
          font-weight: 800;
          color: var(--ds-gold);
          margin: 0 0 6px 0;
      }
      .ds-stats-2x2 p {
          font-size: 0.85rem;
          color: #64748B; /* readable slate grey label */
          margin: 0;
          font-weight: 600;
          text-transform: uppercase;
          letter-spacing: 0.03em;
      }

      /* Slide 4: Student testimonials card */
      .ds-testimonial-hero-card {
          background: rgba(255, 255, 255, 0.65); /* More transparent card background */
          backdrop-filter: blur(12px);
          -webkit-backdrop-filter: blur(12px);
          border: 1px solid rgba(255, 255, 255, 0.4);
          padding: 32px;
          border-radius: var(--ds-radius-lg);
          width: 100%;
          max-width: 440px;
          box-shadow: 0 16px 36px rgba(8, 39, 74, 0.05);
          transition: all 0.3s ease;
      }
      .ds-testimonial-hero-card:hover {
          background: rgba(255, 255, 255, 0.85);
          border-color: var(--ds-gold);
          box-shadow: 0 20px 40px rgba(196, 155, 85, 0.15);
      }
      .ds-stars {
          color: var(--ds-gold);
          font-size: 0.95rem;
          margin-bottom: 16px;
          letter-spacing: 2px;
      }
      .ds-quote-text {
          font-size: 0.95rem;
          line-height: 1.6;
          color: #334155; /* readable slate-grey quote text */
          font-style: italic;
          margin: 0 0 24px 0;
      }
      .ds-author-name {
          font-family: var(--ds-font-primary);
          font-weight: 700;
          font-size: 0.95rem;
          color: var(--ds-navy); /* Theme navy author name */
      }
      .ds-author-meta {
          font-size: 0.75rem;
          color: #64748B; /* readable slate-grey subtext */
          margin-top: 2px;
          font-weight: 500;
      }

      /* Carousel dot indicators */
      .ds-carousel-dots {
          display: flex;
          justify-content: center;
          gap: 12px;
          margin-top: 36px;
      }
      .ds-dot {
          width: 10px;
          height: 10px;
          border-radius: 50%;
          background-color: rgba(8, 39, 74, 0.2); /* dark navy dot */
          cursor: pointer;
          transition: all 0.3s ease;
      }
      .ds-dot.active {
          background-color: var(--ds-gold);
          transform: scale(1.3);
          box-shadow: 0 0 8px rgba(196, 155, 85, 0.6);
      }

      /* Compact Footer */
      .ds-footer {
          height: 60px;
          border-top: 1px solid rgba(196, 155, 85, 0.25); /* Gold top border */
          display: flex;
          align-items: center;
          justify-content: center;
          font-size: 0.85rem;
          color: #94A3B8; /* soft light slate-grey text for contrast */
          flex-shrink: 0;
          background-color: #061220; /* Matches top navigation bar color perfectly */
      }

      /* Responsive Adjustments */
      @media (max-width: 1024px) {
          .ds-slide {
              height: auto;
              min-height: calc(100vh - 140px);
              padding: 60px 0;
          }
          .ds-slide-grid {
              grid-template-columns: 1fr;
              text-align: center;
              gap: 40px;
          }
          .ds-hero-content {
              max-width: 100%;
          }
          .ds-hero-cta {
              justify-content: center;
          }
          .ds-advantages-stack,
          .ds-stats-2x2,
          .ds-testimonial-hero-card {
              margin: 0 auto;
          }
          .ds-glass-stats-container {
              align-items: center !important;
              justify-content: center;
              flex-direction: row !important;
              flex-wrap: wrap;
          }
          html, body {
              overflow-y: auto; /* Fallback for small devices */
              height: auto;
          }
          body {
              min-height: 100vh;
          }
      }
  </style>
</head>
<body>

<!-- Glassmorphic Navbar -->
<nav class="ds-navbar">
  <div class="ds-nav-container">
    <a href="${pageContext.request.contextPath}/" class="ds-brand">
      <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="ds-brand-icon">
        <circle cx="12" cy="12" r="10"></circle>
        <circle cx="12" cy="12" r="3"></circle>
        <line x1="12" y1="2" x2="12" y2="9"></line>
        <line x1="3.5" y1="17" x2="9.5" y2="13.5"></line>
        <line x1="20.5" y1="17" x2="14.5" y2="13.5"></line>
      </svg>
      DriveEdu
    </a>
    <div class="ds-nav-links">
      <a href="${pageContext.request.contextPath}/" class="ds-nav-link active">Home</a>
      <a href="${pageContext.request.contextPath}/vehicles" class="ds-nav-link">Our Fleet</a>
      <a href="${pageContext.request.contextPath}/contact" class="ds-nav-link">Contact Us</a>
      <a href="${pageContext.request.contextPath}/login" class="ds-nav-link">Login</a>
      <a href="${pageContext.request.contextPath}/register" class="ds-btn ds-btn-gold">Sign Up</a>
    </div>
  </div>
</nav>

<!-- Hero Section with Slideshow Carousel -->
<section class="ds-hero-section">
  <div class="ds-hero-glow-1"></div>
  <div class="ds-hero-glow-2"></div>
  
  <div class="ds-carousel">
    <div class="ds-carousel-inner">
      
      <!-- Slide 1: Welcome / Call to Action -->
      <div class="ds-slide active">
        <div class="ds-slide-bg" style="background-image: linear-gradient(to right, rgba(255, 255, 255, 0.82) 15%, rgba(255, 255, 255, 0.9) 50%, rgba(255, 255, 255, 0.1) 90%), url('${pageContext.request.contextPath}/images/driving_lesson_one.png');"></div>
        <div class="ds-container">
          <div class="ds-slide-grid">
            <div class="ds-hero-content">
              <h1 class="ds-hero-title">
                Drive Your <span class="ds-text-gradient">Future</span><br>With Confidence
              </h1>
              <p class="ds-hero-text">
                A complete digital management platform for driving schools — register students, schedule lessons, manage instructors and vehicles, all in one elegant system.
              </p>
              <div class="ds-hero-cta">
                <a href="${pageContext.request.contextPath}/login" class="ds-btn ds-btn-primary-gold">Login Portal</a>
                <a href="${pageContext.request.contextPath}/register" class="ds-btn ds-btn-outline-gold">Register as Student</a>
              </div>
            </div>
            <div class="ds-hero-visual">
              <div class="ds-glass-stats-container">
                <div class="ds-glass-stat-static">
                  <span class="ds-stat-number">★ 4.9</span>
                  <span class="ds-stat-label">Student Rating</span>
                </div>
                <div class="ds-glass-stat-static">
                  <span class="ds-stat-number">50+</span>
                  <span class="ds-stat-label">Certified Fleet</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 2: Designed for Success (Advantages) -->
      <div class="ds-slide">
        <div class="ds-slide-bg" style="background-image: linear-gradient(to right, rgba(255, 255, 255, 0.82) 15%, rgba(255, 255, 255, 0.9) 50%, rgba(255, 255, 255, 0.1) 90%), url('${pageContext.request.contextPath}/images/driving_lesson_two.png');"></div>
        <div class="ds-container">
          <div class="ds-slide-grid">
            <div class="ds-hero-content">
              <h1 class="ds-hero-title">
                Designed for Your<br><span class="ds-text-gradient">Success & Safety</span>
              </h1>
              <p class="ds-hero-text">
                We combine industry-leading instructors with modern tools and scheduling convenience to deliver the ultimate learning experience.
              </p>
              <div class="ds-hero-cta">
                <a href="${pageContext.request.contextPath}/vehicles" class="ds-btn ds-btn-primary-gold">View Our Fleet</a>
                <a href="${pageContext.request.contextPath}/contact" class="ds-btn ds-btn-outline-gold">Send Inquiry</a>
              </div>
            </div>
            <div class="ds-hero-visual">
              <div class="ds-advantages-stack">
                <div class="ds-advantage-glass-card">
                  <div class="ds-adv-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle></svg>
                  </div>
                  <div>
                    <h4>Expert Instructors</h4>
                    <p>Certified and experienced driving mentors for all categories.</p>
                  </div>
                </div>
                <div class="ds-advantage-glass-card">
                  <div class="ds-adv-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line></svg>
                  </div>
                  <div>
                    <h4>Easy Scheduling</h4>
                    <p>Book and manage your driving lessons with a few clicks.</p>
                  </div>
                </div>
                <div class="ds-advantage-glass-card">
                  <div class="ds-adv-icon">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect></svg>
                  </div>
                  <div>
                    <h4>All Categories</h4>
                    <p>From light vehicles to motorbikes and heavy commercial trucks.</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 3: Real-Time Statistics -->
      <div class="ds-slide">
        <div class="ds-slide-bg" style="background-image: linear-gradient(to right, rgba(255, 255, 255, 0.82) 15%, rgba(255, 255, 255, 0.9) 50%, rgba(255, 255, 255, 0.1) 90%), url('${pageContext.request.contextPath}/images/driving_lesson_three.png');"></div>
        <div class="ds-container">
          <div class="ds-slide-grid">
            <div class="ds-hero-content">
              <h1 class="ds-hero-title">
                Milestones of<br><span class="ds-text-gradient">Excellence</span>
              </h1>
              <p class="ds-hero-text">
                Empowering drivers with confidence and safety since 2001. We are proud of our history and the achievements of our graduates.
              </p>
              <div class="ds-hero-cta">
                <a href="${pageContext.request.contextPath}/register" class="ds-btn ds-btn-primary-gold">Register Online</a>
                <a href="${pageContext.request.contextPath}/vehicles" class="ds-btn ds-btn-outline-gold">Explore Fleet</a>
              </div>
            </div>
            <div class="ds-hero-visual">
              <div class="ds-stats-2x2">
                <div class="ds-stat-glass-card">
                  <h3>15k+</h3>
                  <p>Students</p>
                </div>
                <div class="ds-stat-glass-card">
                  <h3>99%</h3>
                  <p>Pass Rate</p>
                </div>
                <div class="ds-stat-glass-card">
                  <h3>25+</h3>
                  <p>Years</p>
                </div>
                <div class="ds-stat-glass-card">
                  <h3><%= lightCount + heavyCount + motorcycleCount %></h3>
                  <p>Active Fleet</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Slide 4: Student Success Stories -->
      <div class="ds-slide">
        <div class="ds-slide-bg" style="background-image: linear-gradient(to right, rgba(255, 255, 255, 0.82) 15%, rgba(255, 255, 255, 0.9) 50%, rgba(255, 255, 255, 0.1) 90%), url('${pageContext.request.contextPath}/images/driving_lesson_four.png');"></div>
        <div class="ds-container">
          <div class="ds-slide-grid">
            <div class="ds-hero-content">
              <h1 class="ds-hero-title">
                What Our<br><span class="ds-text-gradient">Graduates Say</span>
              </h1>
              <p class="ds-hero-text">
                Read reviews from our recent graduates who successfully obtained their driver's licenses on their first attempts.
              </p>
              <div class="ds-hero-cta">
                <a href="${pageContext.request.contextPath}/testimonials" class="ds-btn ds-btn-primary-gold">See More Reviews &rarr;</a>
                <a href="${pageContext.request.contextPath}/login" class="ds-btn ds-btn-outline-gold">Get Started Today</a>
              </div>
            </div>
            <div class="ds-hero-visual">
              <div class="ds-testimonial-hero-card">
                <% if (latestTestimonial != null) { 
                    int rating = latestTestimonial.getRating();
                    StringBuilder stars = new StringBuilder();
                    for (int i = 0; i < rating; i++) {
                        stars.append("★");
                    }
                %>
                  <div class="ds-stars"><%= stars.toString() %></div>
                  <p class="ds-quote-text">
                    "<%= latestTestimonial.getMessage() %>"
                  </p>
                  <div class="ds-t-author">
                    <span class="ds-author-name"><%= latestTestimonial.getStudentName() %></span>
                    <span class="ds-author-meta"><%= latestTestimonial.getLicenseCategory() %></span>
                  </div>
                <% } else { %>
                  <div class="ds-stars">★★★★★</div>
                  <p class="ds-quote-text">
                    "Passed my driving exam on the very first try! My instructor was incredibly patient and structured the lessons to cover exactly what I needed to know."
                  </p>
                  <div class="ds-t-author">
                    <span class="ds-author-name">Dilhan Perera</span>
                    <span class="ds-author-meta">B-Class Graduate</span>
                  </div>
                <% } %>
                <div style="margin-top: 20px; text-align: right;">
                  <a href="${pageContext.request.contextPath}/testimonials" style="color: var(--ds-gold); text-decoration: none; font-size: 0.85rem; font-weight: 700; display: inline-flex; align-items: center; gap: 4px;">
                    See More Reviews &rarr;
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div>

    <!-- Carousel Navigation Dots -->
    <div class="ds-carousel-dots" style="position: absolute; bottom: 25px; left: 50%; transform: translateX(-50%); z-index: 10;">
      <span class="ds-dot active" onclick="goToSlide(0)"></span>
      <span class="ds-dot" onclick="goToSlide(1)"></span>
      <span class="ds-dot" onclick="goToSlide(2)"></span>
      <span class="ds-dot" onclick="goToSlide(3)"></span>
    </div>
  </div>
</section>

<!-- Compact Footer -->
<footer class="ds-footer">
  <div>&copy; 2026 DriveEdu Driving School Management System. All rights reserved.</div>
</footer>

<!-- Carousel Slider Logic -->
<script>
  let currentSlide = 0;
  const slides = document.querySelectorAll('.ds-slide');
  const dots = document.querySelectorAll('.ds-dot');
  const totalSlides = slides.length;

  function showSlide(index) {
      slides.forEach((slide, i) => {
          if (i === index) {
              slide.classList.add('active');
          } else {
              slide.classList.remove('active');
          }
      });
      dots.forEach((dot, i) => {
          if (i === index) {
              dot.classList.add('active');
          } else {
              dot.classList.remove('active');
          }
      });
      currentSlide = index;
  }

  function nextSlide() {
      let next = (currentSlide + 1) % totalSlides;
      showSlide(next);
  }

  function goToSlide(index) {
      showSlide(index);
      resetTimer();
  }

  let timer = setInterval(nextSlide, 5000);
  function resetTimer() {
      clearInterval(timer);
      timer = setInterval(nextSlide, 5000);
  }
</script>

</body>
</html>
