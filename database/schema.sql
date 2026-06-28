-- ============================================================
--  Driving School Registration & Scheduling System
--  Database Schema - MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS driving_school_db_v3
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE driving_school_db_v3;

-- -------------------------------------------------------
-- TABLE: users
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
                                     user_id INT NOT NULL AUTO_INCREMENT,
                                     full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),

    role ENUM(
                 'admin',
                 'student',
                 'instructor'
             ) NOT NULL DEFAULT 'student',

    is_active TINYINT(1) NOT NULL DEFAULT 1,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id)
    ) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: students
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS students (
                                        student_id INT NOT NULL AUTO_INCREMENT,
                                        user_id INT NOT NULL UNIQUE,
                                        nic_number VARCHAR(12) NOT NULL UNIQUE,
    dob DATE,
    address TEXT,

    license_type ENUM(
                         'A1','A','B1','B','C','CE','D'
                     ) DEFAULT 'B',

    status ENUM(
                   'active',
                   'suspended',
                   'completed',
                   'pending'
               ) DEFAULT 'pending',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (student_id),

    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: instructors
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS instructors (
                                           instructor_id INT NOT NULL AUTO_INCREMENT,
                                           user_id INT NOT NULL UNIQUE,
                                           license_no VARCHAR(50) NOT NULL UNIQUE,
    specialization VARCHAR(100),
    experience_years INT DEFAULT 0,

    status ENUM(
                   'active',
                   'inactive',
                   'on_leave'
               ) DEFAULT 'active',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (instructor_id),

    FOREIGN KEY (user_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
    ) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: vehicles
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS vehicles (
                                        vehicle_id INT NOT NULL AUTO_INCREMENT,
                                        registration_no VARCHAR(20) NOT NULL UNIQUE,
    make VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    year YEAR,

    transmission_type ENUM(
                              'manual',
                              'automatic'
                          ) DEFAULT 'manual',

    fuel_type ENUM(
                      'petrol',
                      'diesel',
                      'electric'
                  ) DEFAULT 'petrol',

    status ENUM(
                   'available',
                   'in_use',
                   'maintenance',
                   'retired'
               ) DEFAULT 'available',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (vehicle_id)
    ) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: courses
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS courses (
                                       course_id INT NOT NULL AUTO_INCREMENT,
                                       course_name VARCHAR(150) NOT NULL,

    license_category ENUM(
                             'A1','A','B1','B','C','CE','D'
                         ) NOT NULL,

    total_hours INT NOT NULL DEFAULT 20,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,

    is_active TINYINT(1) NOT NULL DEFAULT 1,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (course_id)
    ) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: enrollments
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS enrollments (
                                           enrollment_id INT NOT NULL AUTO_INCREMENT,
                                           student_id INT NOT NULL,
                                           course_id INT NOT NULL,

                                           enrollment_date DATE NOT NULL DEFAULT (CURRENT_DATE),

    payment_status ENUM(
                           'pending',
                           'partial',
                           'paid',
                           'refunded'
                       ) DEFAULT 'pending',

    amount_paid DECIMAL(10,2) DEFAULT 0.00,

    status ENUM(
                   'active',
                   'completed',
                   'cancelled',
                   'on_hold'
               ) DEFAULT 'active',

    notes TEXT,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (enrollment_id),

    FOREIGN KEY (student_id)
    REFERENCES students(student_id)
    ON DELETE CASCADE,

    FOREIGN KEY (course_id)
    REFERENCES courses(course_id)
    ON DELETE RESTRICT
    ) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: schedules
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS schedules (
                                         schedule_id INT NOT NULL AUTO_INCREMENT,
                                         enrollment_id INT NOT NULL,
                                         instructor_id INT NOT NULL,
                                         vehicle_id INT NOT NULL,

                                         lesson_date DATE NOT NULL,
                                         time_slot VARCHAR(20) NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 60,

    lesson_type ENUM(
                        'theory',
                        'practical',
                        'test_prep',
                        'road_test'
                    ) DEFAULT 'practical',

    status ENUM(
                   'scheduled',
                   'completed',
                   'cancelled',
                   'no_show'
               ) DEFAULT 'scheduled',

    notes TEXT,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (schedule_id),

    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE RESTRICT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: lesson_slots
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS lesson_slots (
    slot_id INT NOT NULL AUTO_INCREMENT,
    course_id INT NOT NULL,
    instructor_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    lesson_date DATE NOT NULL,
    time_slot VARCHAR(50) NOT NULL,
    duration_minutes INT NOT NULL DEFAULT 60,
    lesson_type VARCHAR(50) DEFAULT 'practical',
    capacity INT NOT NULL DEFAULT 1,
    bookings_count INT NOT NULL DEFAULT 0,
    status VARCHAR(50) DEFAULT 'open',
    notes TEXT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (slot_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: slot_bookings
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS slot_bookings (
    booking_id INT NOT NULL AUTO_INCREMENT,
    slot_id INT NOT NULL,
    student_id INT NOT NULL,
    enrollment_id INT NOT NULL,
    schedule_id INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id),
    UNIQUE KEY (slot_id, student_id),
    FOREIGN KEY (slot_id) REFERENCES lesson_slots(slot_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- TABLE: notifications
-- -------------------------------------------------------
CREATE TABLE IF NOT EXISTS notifications (
    notification_id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    link VARCHAR(255),
    type VARCHAR(50) DEFAULT 'info',
    is_read TINYINT(1) DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (notification_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- -------------------------------------------------------
-- ADMIN ACCOUNT
-- EMAIL: admin@gmail.com
-- PASSWORD: 12345678
-- -------------------------------------------------------
INSERT INTO users (
    full_name,
    email,
    password_hash,
    phone,
    role
)
VALUES (
           'System Administrator',
           'admin@gmail.com',
           '$2a$10$7EqJtq98hPqEX7fNZaFWoOHi6M6sJjKCk4YfKx63HzlOAAb2Yt7Ce',
           '0771234567',
           'admin'
       );

-- -------------------------------------------------------
-- SAMPLE COURSES
-- -------------------------------------------------------
INSERT INTO courses (
    course_name,
    license_category,
    total_hours,
    price,
    description
)
VALUES
    (
        'Motor Cycle (A1) Basic Course',
        'A1',
        15,
        15000.00,
        'Basic motor cycle training'
    ),
    (
        'Motor Cycle (A) Advanced Course',
        'A',
        20,
        20000.00,
        'Advanced bike training'
    ),
    (
        'Car Driving (B) Complete Course',
        'B',
        25,
        30000.00,
        'Complete car driving course'
    ),
    (
        'Heavy Vehicle (C) Course',
        'C',
        30,
        40000.00,
        'Heavy vehicle training'
    );

-- -------------------------------------------------------
-- SAMPLE VEHICLES
-- -------------------------------------------------------
INSERT INTO vehicles (
    registration_no,
    make,
    model,
    year,
    transmission_type,
    fuel_type
)
VALUES
    (
        'CAA-1234',
        'Toyota',
        'Corolla',
        2020,
        'manual',
        'petrol'
    ),
    (
        'CAB-5678',
        'Honda',
        'Civic',
        2021,
        'automatic',
        'petrol'
    ),
    (
        'CAC-9012',
        'Nissan',
        'Leaf',
        2023,
        'automatic',
        'electric'
    );