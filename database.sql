-- LifeLink Blood Donation Network - Database Schema
-- Run this in phpMyAdmin or MySQL to set up the database

CREATE DATABASE IF NOT EXISTS lifelink_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lifelink_db;

-- Users table (donors and admins)
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    location VARCHAR(150) NOT NULL,
    last_donation_date DATE DEFAULT NULL,
    availability_status ENUM('available', 'unavailable', 'resting') DEFAULT 'available',
    user_type ENUM('donor', 'admin') DEFAULT 'donor',
    is_verified TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Emergency requests table
CREATE TABLE emergency_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    requester_name VARCHAR(100) NOT NULL,
    requester_phone VARCHAR(20) NOT NULL,
    requester_email VARCHAR(100),
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    location VARCHAR(150) NOT NULL,
    urgency_level ENUM('critical', 'urgent', 'moderate') DEFAULT 'urgent',
    message TEXT,
    status ENUM('active', 'fulfilled', 'cancelled') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fulfilled_at TIMESTAMP NULL
);

-- Donation history table
CREATE TABLE donation_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    donor_id INT NOT NULL,
    request_id INT DEFAULT NULL,
    donation_date DATE NOT NULL,
    blood_type ENUM('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-') NOT NULL,
    units INT DEFAULT 1,
    location VARCHAR(150),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (donor_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (request_id) REFERENCES emergency_requests(id) ON DELETE SET NULL
);

-- Messages table (secure contact system)
CREATE TABLE messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NOT NULL,
    receiver_id INT NOT NULL,
    request_id INT DEFAULT NULL,
    message TEXT NOT NULL,
    is_phone_revealed TINYINT(1) DEFAULT 0,
    sender_phone_revealed TINYINT(1) DEFAULT 0,
    receiver_phone_revealed TINYINT(1) DEFAULT 0,
    is_read TINYINT(1) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (receiver_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (request_id) REFERENCES emergency_requests(id) ON DELETE SET NULL
);

-- Admin account (default: admin@lifelink.lk / admin123)
INSERT INTO users (full_name, email, phone, password_hash, blood_type, location, user_type, is_verified) 
VALUES (
    'System Administrator',
    'admin@lifelink.lk',
    '0770000000',
    '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
    'O+',
    'University of Kelaniya',
    'admin',
    1
);

-- Sample donors
INSERT INTO users (full_name, email, phone, password_hash, blood_type, location, last_donation_date, availability_status, is_verified) VALUES
('Kasun Perera', 'kasun@email.com', '0771234567', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'O+', 'University of Kelaniya', '2025-03-15', 'available', 1),
('Nimali Fernando', 'nimali@email.com', '0772345678', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'A+', 'Kiribathgoda', '2025-01-20', 'available', 1),
('Sajith Silva', 'sajith@email.com', '0773456789', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'B+', 'Kelaniya Town', '2024-12-10', 'resting', 1),
('Dilani Weerasinghe', 'dilani@email.com', '0774567890', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'AB-', 'Wattala', NULL, 'available', 0),
('Ruwan Bandara', 'ruwan@email.com', '0775678901', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'O-', 'University of Kelaniya', '2025-05-01', 'available', 1);

-- Sample emergency request
INSERT INTO emergency_requests (requester_name, requester_phone, requester_email, blood_type, location, urgency_level, message, status) VALUES
('Mrs. Jayawardena', '0761112222', 'family@email.com', 'O+', 'Colombo North Teaching Hospital', 'critical', 'Urgent need for O+ blood for surgery scheduled tomorrow morning. Patient is my husband.', 'active');

-- Sample donation history
INSERT INTO donation_history (donor_id, donation_date, blood_type, units, location, notes) VALUES
(1, '2025-03-15', 'O+', 1, 'Colombo Blood Bank', 'Regular donation'),
(2, '2025-01-20', 'A+', 1, 'Kelaniya Hospital', 'Emergency request fulfilled'),
(3, '2024-12-10', 'B+', 1, 'Colombo Blood Bank', 'Regular donation');
