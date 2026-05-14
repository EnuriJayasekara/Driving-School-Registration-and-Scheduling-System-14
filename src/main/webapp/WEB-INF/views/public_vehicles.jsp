<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.drivingschool.model.Vehicle" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Our Vehicles | DriveEdu Driving School</title>
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
            --card-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.03), 0 8px 10px -6px rgba(0, 0, 0, 0.03);
            --card-shadow-hover: 0 20px 30px -5px rgba(8, 39, 74, 0.08), 0 10px 15px -6px rgba(196, 155, 85, 0.08);
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
            padding: 4rem 2rem;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }

        .header {
            text-align: center;
            margin-bottom: 3.5rem;
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

        /* Category Filters */
        .filters {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 3.5rem;
            flex-wrap: wrap;
        }

        .filter-btn {
            background-color: var(--card-light);
            color: var(--text-muted);
            border: 1px solid var(--border);
            padding: 0.8rem 1.8rem;
            border-radius: 9999px;
            font-weight: 600;
            font-size: 0.9rem;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
        }

        .filter-btn:hover {
            color: var(--accent-navy);
            border-color: var(--accent-gold);
            transform: translateY(-2px);
        }

        .filter-btn.active {
            color: #FFFFFF;
            background: linear-gradient(135deg, var(--accent-navy), #123e70);
            border-color: var(--accent-navy);
            box-shadow: 0 4px 12px rgba(8, 39, 74, 0.15);
        }

        /* Vehicles Grid */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 2.5rem;
        }

        .vehicle-card {
            background-color: var(--card-light);
            border: 1px solid var(--border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            display: flex;
            flex-direction: column;
            position: relative;
        }

        .vehicle-card:hover {
            transform: translateY(-6px);
            border-color: rgba(196, 155, 85, 0.3);
            box-shadow: var(--card-shadow-hover);
        }

        /* Card Top Header (Numbering + Reg No) */
        .card-top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.1rem 1.5rem;
            background-color: #FFFFFF;
            border-bottom: 1px solid var(--border);
        }

        .card-number {
            font-size: 1.1rem;
            font-weight: 800;
            color: var(--accent-gold);
        }

        .card-reg-no {
            font-size: 1rem;
            font-weight: 700;
            color: var(--accent-navy);
            letter-spacing: 0.03em;
        }

        .image-container {
            height: 200px;
            position: relative;
            overflow: hidden;
            background: linear-gradient(135deg, #F8FAFC, #E2E8F0);
        }

        .image-container img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .vehicle-card:hover .image-container img {
            transform: scale(1.06);
        }

        .category-tag {
            position: absolute;
            top: 1rem;
            left: 1rem;
            background-color: rgba(8, 39, 74, 0.85);
            backdrop-filter: blur(4px);
            color: #FFFFFF;
            padding: 0.35rem 0.85rem;
            border-radius: 8px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border: 1px solid rgba(255, 255, 255, 0.1);
            z-index: 10;
        }

        .status-tag {
            position: absolute;
            top: 1rem;
            right: 1rem;
            padding: 0.35rem 0.85rem;
            border-radius: 8px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            backdrop-filter: blur(4px);
            z-index: 10;
        }

        .status-tag.available {
            background-color: rgba(16, 185, 129, 0.15);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.25);
        }

        .status-tag.unavailable {
            background-color: rgba(239, 68, 68, 0.15);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.25);
        }

        .info {
            padding: 1.5rem;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            justify-content: flex-start;
        }

        .title-block {
            margin-bottom: 1.25rem;
        }

        .title-block h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--accent-navy);
            margin-bottom: 0.2rem;
            line-height: 1.3;
        }

        .vehicle-type {
            font-size: 0.85rem;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* Specs Line (Dot Separated) */
        .specs-line {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.88rem;
            color: var(--text-muted);
            margin-top: auto;
            padding-top: 1.1rem;
            border-top: 1px dashed var(--border);
            line-height: 1;
        }

        .specs-line span {
            display: inline-flex;
            align-items: center;
        }

        .specs-line span:not(:last-child)::after {
            content: "•";
            margin-left: 0.5rem;
            color: var(--accent-gold);
            font-weight: bold;
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
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h1>Our Training <span>Fleet</span></h1>
        <p>Explore our premium range of modern, well-maintained vehicles categorized for all training requirements.</p>
    </div>

    <%
        List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
        String currentFilter = (String) request.getAttribute("categoryFilter");
        if (currentFilter == null) currentFilter = "All";
    %>

    <div class="filters">
        <a href="?category=All" class="filter-btn <%= "All".equals(currentFilter) ? "active" : "" %>">Show All</a>
        <a href="?category=Light" class="filter-btn <%= "Light".equals(currentFilter) ? "active" : "" %>">Light Vehicles</a>
        <a href="?category=Heavy" class="filter-btn <%= "Heavy".equals(currentFilter) ? "active" : "" %>">Heavy Vehicles</a>
        <a href="?category=Motorcycle" class="filter-btn <%= "Motorcycle".equals(currentFilter) ? "active" : "" %>">Motorcycles</a>
    </div>

    <div class="grid">
        <%
            if (vehicles != null) {
                boolean found = false;
                int index = 0;
                for (Vehicle v : vehicles) {
                    // Filter match logic
                    String category = v.getCategory();
                    if (category == null) category = "Light Vehicle";
                    
                    if ("Light".equalsIgnoreCase(currentFilter) && !category.toLowerCase().contains("light")) continue;
                    if ("Heavy".equalsIgnoreCase(currentFilter) && !category.toLowerCase().contains("heavy")) continue;
                    if ("Motorcycle".equalsIgnoreCase(currentFilter) && !category.toLowerCase().contains("motorcycle")) continue;

                    found = true;
                    index++;
                    boolean isAvail = "available".equalsIgnoreCase(v.getStatus());
                    
                    String displayType = v.getVehicleType();
                    if (displayType == null || displayType.trim().isEmpty()) {
                        displayType = category;
                    }
        %>
        <div class="vehicle-card">
            <div class="card-top-bar">
                <span class="card-number"><%= index %>.</span>
                <span class="card-reg-no"><%= v.getRegistrationNo() %></span>
            </div>
            <%
                String regClean = "";
                if (v.getRegistrationNo() != null) {
                    String raw = v.getRegistrationNo().toLowerCase().trim();
                    String[] parts = raw.split("[\\s-]+");
                    if (parts.length > 1) {
                        String first = parts[0];
                        boolean isProvince = first.equals("wp") || first.equals("cp") || first.equals("sp") || 
                                             first.equals("np") || first.equals("ep") || first.equals("nw") || 
                                             first.equals("nc") || first.equals("uva") || first.equals("sg") || 
                                             first.equals("sab");
                        int startIdx = isProvince ? 1 : 0;
                        StringBuilder sb = new StringBuilder();
                        for (int k = startIdx; k < parts.length; k++) {
                            sb.append(parts[k].replaceAll("[^a-z0-9]", ""));
                        }
                        regClean = sb.toString();
                    } else {
                        regClean = raw.replaceAll("[^a-z0-9]", "");
                    }
                }
                
                boolean hasLocalImage = regClean.equals("lt4186") || regClean.equals("nd4521") || 
                                        regClean.equals("cab14765") || regClean.equals("caw7469") || 
                                        regClean.equals("cab5687") || regClean.equals("cab4769") || 
                                        regClean.equals("bfo4587") || regClean.equals("caa7625") || 
                                        regClean.equals("ka4528") || regClean.equals("la5147");
                                        
                String imageUrl;
                if (hasLocalImage) {
                    imageUrl = request.getContextPath() + "/images/vehicles/vehicle_" + regClean + ".jpg";
                } else {
                    imageUrl = "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=600&q=80"; // default car
                    String vtype = v.getVehicleType();
                    if (vtype == null) vtype = "";
                    vtype = vtype.toLowerCase().trim();
                    
                    String make = v.getMake() != null ? v.getMake().toLowerCase() : "";
                    String model = v.getModel() != null ? v.getModel().toLowerCase() : "";
                    String trans = v.getTransmissionType() != null ? v.getTransmissionType().toLowerCase() : "";
                    String fuel = v.getFuelType() != null ? v.getFuelType().toLowerCase() : "";

                    if (vtype.contains("prime mover") || vtype.contains("long vehicle") || model.contains("mover")) {
                        imageUrl = "https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?auto=format&fit=crop&w=600&q=80";
                    } else if (vtype.contains("bus") || model.contains("viking")) {
                        imageUrl = "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=600&q=80";
                    } else if (vtype.contains("lorry") || model.contains("lpt")) {
                        imageUrl = "https://images.unsplash.com/photo-1580674684081-7617fbf3d745?auto=format&fit=crop&w=600&q=80";
                    } else if (vtype.contains("three wheeler") || vtype.contains("3 wheeler") || vtype.contains("tuk tuk") || model.contains("re 4s") || model.contains("bajaj")) {
                        imageUrl = "https://images.unsplash.com/photo-1561361058-c24cecae35ca?auto=format&fit=crop&w=600&q=80";
                    } else if (vtype.contains("van") || model.contains("magic express")) {
                        imageUrl = "https://images.unsplash.com/photo-1610647752706-3bb12232b3cd?auto=format&fit=crop&w=600&q=80";
                    } else if (vtype.contains("bike") || vtype.contains("motorcycle") || category.toLowerCase().contains("motorcycle") || category.toLowerCase().contains("bike")) {
                        if (trans.contains("automatic") || model.contains("dio")) {
                            imageUrl = "https://images.unsplash.com/photo-1599819811279-d5ad9cccf838?auto=format&fit=crop&w=600&q=80"; // scooter
                        } else {
                            imageUrl = "https://images.unsplash.com/photo-1622185135505-2d79500d793a?auto=format&fit=crop&w=600&q=80"; // commuter bike
                        }
                    } else {
                        // Car matching
                        if (trans.contains("automatic") || model.contains("ignis")) {
                            imageUrl = "https://images.unsplash.com/photo-1616788494707-ec28f08d05a1?auto=format&fit=crop&w=600&q=80"; // blue hatchback auto
                        } else {
                            imageUrl = "https://images.unsplash.com/photo-1494976388531-d1058494cdd8?auto=format&fit=crop&w=600&q=80"; // gray hatchback manual
                        }
                    }
                }
            %>
            <div class="image-container">
                <span class="category-tag"><%= category %></span>
                <span class="status-tag <%= isAvail ? "available" : "unavailable" %>"><%= v.getStatus() %></span>
                <img src="<%= imageUrl %>" alt="<%= v.getMake() %> <%= v.getModel() %>">
            </div>
            <div class="info">
                <div class="title-block">
                    <h3><%= v.getMake() %> <%= v.getModel() %></h3>
                    <span class="vehicle-type"><%= displayType %></span>
                </div>
                <div class="specs-line">
                    <span><%= v.getYear() %></span>
                    <span style="text-transform: capitalize;"><%= v.getFuelType() %></span>
                    <span style="text-transform: capitalize;"><%= v.getTransmissionType() %></span>
                    <span><%= v.getSeatingCapacity() %> Seats</span>
                </div>
            </div>
        </div>
        <%
                }
                if (!found) {
        %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 3rem; color: var(--text-muted);">
                <p>No vehicles found matching the selected category.</p>
            </div>
        <%
                }
            }
        %>
    </div>

    <div class="back-nav">
        <a href="<%= request.getContextPath() %>/" class="back-btn">&larr; Return to Home Page</a>
    </div>
</div>

</body>
</html>
