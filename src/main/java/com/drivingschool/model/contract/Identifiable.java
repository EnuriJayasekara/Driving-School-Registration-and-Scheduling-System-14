package com.drivingschool.model.contract;

/**
 * Marker contract for any domain model that has a primary-key identity.
 * <p>
 * Lets generic code (e.g. cart deduplication, audit logging, list helpers)
 * treat any entity uniformly without caring whether it is a Course, a
 * Vehicle or a LessonSlot.
 * </p>
 *
 * Demonstrates: <b>interface</b>, <b>polymorphism</b>.
 */
public interface Identifiable {

    /** @return the database primary key for this entity. */
    int getId();
}