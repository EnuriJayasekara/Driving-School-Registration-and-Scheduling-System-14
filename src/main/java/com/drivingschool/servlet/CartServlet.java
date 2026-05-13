package com.drivingschool.servlet;

import com.drivingschool.model.Course;
import com.drivingschool.model.Enrollment;
import com.drivingschool.model.Student;
import com.drivingschool.service.CourseService;
import com.drivingschool.service.EnrollmentService;
import com.drivingschool.service.StudentService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;

/**
 * Shopping cart for students.
 *
 * Cart is stored in the user's HttpSession as a LinkedHashSet<Integer>
 * (set of courseIds, order preserved). No DB table needed.
 *
 * Routes:
 *   GET  /student/cart            -> show cart page
 *   GET  /student/cart/checkout   -> show payment page for cart total
 *   POST /student/cart/add        -> add courseId to cart  (param: courseId)
 *   POST /student/cart/remove     -> remove courseId       (param: courseId)
 *   POST /student/cart/clear      -> empty the cart
 *   POST /student/cart/checkout   -> finalize payment, create enrollments
 */
@WebServlet(urlPatterns = {
        "/student/cart",
        "/student/cart/add",
        "/student/cart/remove",
        "/student/cart/clear",
        "/student/cart/checkout"
})
public class CartServlet extends HttpServlet {

    public static final String CART_KEY = "cart";  // also referenced from JSP

    private final CourseService     courseService     = new CourseService();
    private final StudentService    studentService    = new StudentService();
    private final EnrollmentService enrollmentService = new EnrollmentService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isStudent(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        String path = req.getServletPath();
        try {
            if ("/student/cart/checkout".equals(path)) {
                showCheckout(req, resp);
            } else {
                showCart(req, resp);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (!isStudent(req)) { resp.sendRedirect(req.getContextPath() + "/login"); return; }

        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        try {
            switch (path) {
                case "/student/cart/add":      handleAdd(req, resp);      break;
                case "/student/cart/remove":   handleRemove(req, resp);   break;
                case "/student/cart/clear":    handleClear(req, resp);    break;
                case "/student/cart/checkout": handleCheckout(req, resp); break;
                default: resp.sendRedirect(req.getContextPath() + "/student/cart");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    // ---- show cart page ----
    private void showCart(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {
        List<Course> items = loadCartCourses(req);
        BigDecimal total = items.stream()
                .map(Course::getPrice)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        req.setAttribute("cartItems", items);
        req.setAttribute("cartTotal", total);
        req.getRequestDispatcher("/WEB-INF/views/enrollment/cart.jsp").forward(req, resp);
    }

    // ---- show checkout page ----
    private void showCheckout(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException, SQLException {
        List<Course> items = loadCartCourses(req);
        if (items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/cart");
            return;
        }
        BigDecimal total = items.stream()
                .map(Course::getPrice)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        req.setAttribute("cartItems", items);
        req.setAttribute("cartTotal", total);
        req.getRequestDispatcher("/WEB-INF/views/enrollment/cart_checkout.jsp").forward(req, resp);
    }

    // ---- add courseId to cart ----
    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {

        Integer courseId = parseInt(req.getParameter("courseId"));
        if (courseId == null) {
            resp.sendRedirect(req.getContextPath() + "/student/enroll");
            return;
        }

        // Validate course exists and is active
        Course c = courseService.findById(courseId);
        if (c == null || !c.isActive()) {
            resp.sendRedirect(req.getContextPath() + "/student/enroll?error=notfound");
            return;
        }

        // Already-enrolled check — don't let them re-buy
        int userId = (Integer) req.getSession().getAttribute("userId");
        Student student = studentService.findByUserId(userId);
        if (student != null) {
            boolean already = enrollmentService.listByStudent(student.getStudentId())
                    .stream().anyMatch(e -> e.getCourseId() == courseId);
            if (already) {
                resp.sendRedirect(req.getContextPath()
                        + "/student/enroll/details?courseId=" + courseId + "&error=alreadyenrolled");
                return;
            }
        }

        getCart(req).add(courseId);

        // After adding, send them somewhere useful
        String redirect = req.getParameter("redirect");
        if ("details".equals(redirect)) {
            resp.sendRedirect(req.getContextPath()
                    + "/student/enroll/details?courseId=" + courseId + "&msg=added");
        } else {
            resp.sendRedirect(req.getContextPath() + "/student/enroll?msg=added");
        }
    }

    // ---- remove courseId from cart ----
    private void handleRemove(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        Integer courseId = parseInt(req.getParameter("courseId"));
        if (courseId != null) getCart(req).remove(courseId);
        resp.sendRedirect(req.getContextPath() + "/student/cart");
    }

    // ---- empty cart ----
    private void handleClear(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        getCart(req).clear();
        resp.sendRedirect(req.getContextPath() + "/student/cart?msg=cleared");
    }

    // ---- finalize: create one enrollment per cart item ----
    private void handleCheckout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, SQLException {

        Set<Integer> cart = getCart(req);
        if (cart.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/student/cart");
            return;
        }

        int userId = (Integer) req.getSession().getAttribute("userId");
        Student student = studentService.findByUserId(userId);
        if (student == null) {
            resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=nostudent");
            return;
        }

        // Build a snapshot of already-enrolled courseIds so we skip duplicates safely
        Set<Integer> already = new HashSet<>();
        for (Enrollment en : enrollmentService.listByStudent(student.getStudentId())) {
            already.add(en.getCourseId());
        }

        String last4 = safeLast4(req.getParameter("cardNumber"));
        int created = 0, skipped = 0;

        for (Integer courseId : new ArrayList<>(cart)) {
            if (already.contains(courseId)) { skipped++; continue; }
            Course c = courseService.findById(courseId);
            if (c == null || !c.isActive()) { skipped++; continue; }

            Enrollment e = new Enrollment();
            e.setStudentId(student.getStudentId());
            e.setCourseId(courseId);
            e.setPaymentStatus("paid");
            e.setAmountPaid(c.getPrice() != null ? c.getPrice() : BigDecimal.ZERO);
            e.setStatus("active");
            e.setNotes("Cart checkout - Card ending " + last4);
            enrollmentService.create(e);
            
            // Notify Admin
            com.drivingschool.service.NotificationService notificationService = new com.drivingschool.service.NotificationService();
            notificationService.notifyAllAdmins(
                "New Course Enrollment",
                "Student " + student.getFullName() + " enrolled in " + c.getCourseName(),
                "/admin/enrollments/list",
                "success"
            );

            // Notify Student
            notificationService.notify(
                userId,
                "Course Booked",
                "you booked a course.",
                "/student/dashboard",
                "success"
            );

            created++;
        }

        cart.clear();   // empty cart on success
        resp.sendRedirect(req.getContextPath()
                + "/student/dashboard?msg=enrolled&count=" + created
                + (skipped > 0 ? "&skipped=" + skipped : ""));
    }

    // ---- helpers ----

    @SuppressWarnings("unchecked")
    private Set<Integer> getCart(HttpServletRequest req) {
        HttpSession s = req.getSession();
        Set<Integer> cart = (Set<Integer>) s.getAttribute(CART_KEY);
        if (cart == null) {
            cart = new LinkedHashSet<>();
            s.setAttribute(CART_KEY, cart);
        }
        return cart;
    }

    private List<Course> loadCartCourses(HttpServletRequest req) throws SQLException {
        Set<Integer> cart = getCart(req);
        List<Course> list = new ArrayList<>();
        if (cart.isEmpty()) return list;

        // Drop any IDs that no longer exist or were deactivated
        Iterator<Integer> it = cart.iterator();
        while (it.hasNext()) {
            int id = it.next();
            Course c = courseService.findById(id);
            if (c == null || !c.isActive()) {
                it.remove();
            } else {
                list.add(c);
            }
        }
        return list;
    }

    private boolean isStudent(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && "student".equals(s.getAttribute("role"));
    }

    private Integer parseInt(String s) {
        if (s == null) return null;
        try { return Integer.parseInt(s.trim()); }
        catch (NumberFormatException e) { return null; }
    }

    private String safeLast4(String cardNumber) {
        if (cardNumber == null) return "----";
        String digits = cardNumber.replaceAll("\\D", "");
        if (digits.length() < 4) return "----";
        return digits.substring(digits.length() - 4);
    }
}