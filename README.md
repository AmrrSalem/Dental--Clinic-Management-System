# 🦷 Dental Clinic Management System

## 📌 Overview

This project is designed as a close representation of a real-world **dental clinic management system**. While it captures essential functionalities, the actual implementation used in production is classified under **NDA (Non-Disclosure Agreement)**, and this version is a structured approximation for learning and demonstration purposes.
This project provides a structured **SQL Server database** to support the operations of a dental clinic. It helps manage **patients, dentists, appointments, treatments, payments, and staff** while maintaining data integrity and efficiency.

## ✨ Features

- 🏥 **Patient Management**: Store patient details, including medical history.
- 👨‍⚕️ **Dentist Management**: Track dentist specializations and availability.
- 📅 **Appointments System**: Schedule, complete, or cancel appointments.
- 💉 **Treatment Records**: Maintain details of treatments and their costs.
- 💳 **Payments System**: Track payments with various methods.
- 🏢 **Staff Management**: Store details of receptionists, assistants, and other team members.
- 🔐 **Data Integrity**: Enforced through **Primary and Foreign Keys**.
- ⚙️ **Automation**: Implement stored procedures and triggers.

## 🗂 Database Schema

The database consists of the following tables:

- 📋 `Patients`
- 👨‍⚕️ `Dentists`
- 📅 `Appointments`
- 💉 `Treatments`
- 🔗 `Patient_Treatments`
- 💳 `Payments`
- 🏢 `Staff`

### 📊 ER Diagram
![image](https://github.com/user-attachments/assets/e0071da5-7f8d-4f5e-bd16-45de7785e258)

### 🛠 Database Schema (SQL Code)
```sql
-- Create Database
CREATE DATABASE DentalClinic;
GO
USE DentalClinic;
GO

-- Patients Table
CREATE TABLE Patients (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F', 'O')),
    ContactNumber VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Address TEXT NOT NULL,
    MedicalHistory TEXT
);

-- Dentists Table
CREATE TABLE Dentists (
    DentistID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Availability VARCHAR(50) NOT NULL
);

-- Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    DentistID INT NOT NULL,
    AppointmentDateTime DATETIME NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')) NOT NULL,
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DentistID) REFERENCES Dentists(DentistID)
);

-- Treatments Table
CREATE TABLE Treatments (
    TreatmentID INT IDENTITY(1,1) PRIMARY KEY,
    TreatmentName VARCHAR(100) NOT NULL,
    Description TEXT,
    Cost DECIMAL(10,2) NOT NULL
);

-- Patient_Treatments Table (Many-to-Many Relationship)
CREATE TABLE Patient_Treatments (
    PatientTreatmentID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    TreatmentID INT NOT NULL,
    AppointmentID INT NOT NULL,
    DatePerformed DATE NOT NULL,
    Notes TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (TreatmentID) REFERENCES Treatments(TreatmentID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Payments Table
CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID INT NOT NULL,
    AppointmentID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentMethod VARCHAR(20) CHECK (PaymentMethod IN ('Cash', 'Credit Card', 'Insurance')) NOT NULL,
    PaymentDate DATE NOT NULL,
    Status VARCHAR(20) CHECK (Status IN ('Pending', 'Completed', 'Failed')) NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Staff Table
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL
);
```

(Include an ER diagram image here if available)

## 🚀 Getting Started

### 🔧 Prerequisites

Ensure you have the following installed:

- 🖥 **SQL Server**
- 🛠 **SQL Server Management Studio (SSMS)**

### 📥 Installation Steps

1. Clone this repository:
   ```sh
   git clone https://github.com/your-username/dental-clinic-db.git
   ```
2. Open SSMS and execute `dental_clinic_schema.sql` to create the database.
3. Load sample data using the provided SQL scripts.

## 📝 Sample Queries

Retrieve all scheduled appointments:

Retrieve all scheduled appointments:

```sql
SELECT * FROM Appointments WHERE Status = 'Scheduled';
```

Get all payments made by a patient:

Retrieve details of appointments, including patient and dentist names:
```sql
SELECT a.AppointmentID, p.FirstName AS PatientName, d.FirstName AS DentistName, a.AppointmentDateTime, a.Status
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Dentists d ON a.DentistID = d.DentistID
WHERE a.Status = 'Scheduled';
```

List all treatments performed along with patient details:
```sql
SELECT pt.PatientTreatmentID, p.FirstName AS PatientName, t.TreatmentName, pt.DatePerformed
FROM Patient_Treatments pt
JOIN Patients p ON pt.PatientID = p.PatientID
JOIN Treatments t ON pt.TreatmentID = t.TreatmentID;
```

Calculate total revenue generated from treatments:
```sql
SELECT SUM(Amount) AS TotalRevenue FROM Payments WHERE Status = 'Completed';
```

```sql
SELECT * FROM Payments WHERE PatientID = 1;
```

## 🤝 Contributing

Contributions are welcome. If you have suggestions or improvements, submit a pull request.

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## 📧 Contact

For questions, contact [your-email@example.com](amrr.salem@gmail.com).

