-- Hospital Management App - Database Setup Script
-- Run this script to create the database and all required tables

-- Create database
CREATE DATABASE IF NOT EXISTS hospital;
USE hospital;

-- Create authentication table
CREATE TABLE IF NOT EXISTS authentication (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create patient table
CREATE TABLE IF NOT EXISTS patient (
    patientId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT,
    address VARCHAR(500),
    mobile VARCHAR(20),
    gender VARCHAR(10),
    time_Stamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create doctor table
CREATE TABLE IF NOT EXISTS doctor (
    doctorId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT,
    address VARCHAR(500),
    mobile VARCHAR(20),
    gender VARCHAR(10),
    department VARCHAR(100),
    experience VARCHAR(100),
    availability BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create appointment table
CREATE TABLE IF NOT EXISTS appointment (
    appointmentId INT AUTO_INCREMENT PRIMARY KEY,
    dateAndTime DATETIME NOT NULL,
    department VARCHAR(100),
    doctorId INT,
    patientId INT,
    payment DECIMAL(10,2),
    status VARCHAR(50) DEFAULT 'booked',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctorId) REFERENCES doctor(doctorId) ON DELETE SET NULL,
    FOREIGN KEY (patientId) REFERENCES patient(patientId) ON DELETE SET NULL
);

-- Optional: Insert sample data for testing
-- Uncomment the following lines if you want sample data

-- INSERT INTO doctor (name, department, availability) VALUES
-- ('Dr. John Smith', 'Cardiology', TRUE),
-- ('Dr. Jane Doe', 'Pediatrics', TRUE),
-- ('Dr. Bob Johnson', 'Orthopedics', TRUE);

-- INSERT INTO patient (name, age, address, mobile, gender) VALUES
-- ('Alice Brown', 35, '123 Main St', '555-0101', 'Female'),
-- ('Charlie Wilson', 42, '456 Oak Ave', '555-0102', 'Male');

-- Run these if upgrading an older database that is missing columns:
-- ALTER TABLE doctor ADD COLUMN age INT AFTER name;
-- ALTER TABLE doctor ADD COLUMN address VARCHAR(500) AFTER age;
-- ALTER TABLE doctor ADD COLUMN mobile VARCHAR(20) AFTER address;
-- ALTER TABLE doctor ADD COLUMN gender VARCHAR(10) AFTER mobile;
-- ALTER TABLE doctor ADD COLUMN experience VARCHAR(100) AFTER department;

-- Display success message
SELECT 'Database setup completed successfully!' AS Status;


