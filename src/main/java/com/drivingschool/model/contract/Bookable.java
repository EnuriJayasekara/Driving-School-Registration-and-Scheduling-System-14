package com.drivingschool.model.contract;

/**
 * Contract for anything a student can book a seat on.
 * <p>
 * Today this is only {@code LessonSlot}, but in future you could add
 * group classes, workshops or theory exams and the same booking servlet
 * code would still work as long as they implement this interface.
 * </p>
 *
 * Demonstrates: <b>interface</b>, <b>polymorphism</b>, and an example of
 * a <b>default method</b> (interface with concrete behavior, Java 8+).
 */
public interface Bookable {

    /** Total seats available on this bookable item. */
    int getCapacity();

    /** How many seats are already taken. */
    int getBookingsCount();

    /** Lifecycle status string (e.g. "open", "full", "cancelled"). */
    String getStatus();

    // ---- default methods (concrete behavior shared by every implementer) ----

    /** Seats still available. Never negative. */
    default int getSeatsLeft() {
        return Math.max(0, getCapacity() - getBookingsCount());
    }

    /** True when no seats remain. */
    default boolean isFull() {
        return getBookingsCount() >= getCapacity();
    }

    /** True when the item is open AND not full. */
    default boolean isBookable() {
        return "open".equalsIgnoreCase(getStatus()) && !isFull();
    }
}