-- ============================================================
-- Dental Clinic Management System
-- Schema: Tables, Constraints, Indexes
-- ============================================================

CREATE DATABASE DentalClinic;
GO
USE DentalClinic;
GO

-- ------------------------------------------------------------
-- Patients
-- ------------------------------------------------------------
CREATE TABLE Patients (
    PatientID       INT IDENTITY(1,1) PRIMARY KEY,
    FirstName       VARCHAR(50)  NOT NULL,
    LastName        VARCHAR(50)  NOT NULL,
    DOB             DATE         NOT NULL,
    Gender          CHAR(1)      CHECK (Gender IN ('M', 'F', 'O')),
    ContactNumber   VARCHAR(15)  UNIQUE NOT NULL,
    Email           VARCHAR(100) UNIQUE NOT NULL,
    Address         TEXT         NOT NULL,
    MedicalHistory  TEXT,
    CreatedAt       DATETIME     DEFAULT GETDATE()
);

-- ------------------------------------------------------------
-- Dentists
-- ------------------------------------------------------------
CREATE TABLE Dentists (
    DentistID       INT IDENTITY(1,1) PRIMARY KEY,
    FirstName       VARCHAR(50)  NOT NULL,
    LastName        VARCHAR(50)  NOT NULL,
    Specialization  VARCHAR(100) NOT NULL,
    ContactNumber   VARCHAR(15)  NOT NULL,
    Email           VARCHAR(100) NOT NULL,
    Availability    VARCHAR(50)  NOT NULL
);

-- ------------------------------------------------------------
-- Appointments
-- ------------------------------------------------------------
CREATE TABLE Appointments (
    AppointmentID       INT IDENTITY(1,1) PRIMARY KEY,
    PatientID           INT      NOT NULL,
    DentistID           INT      NOT NULL,
    AppointmentDateTime DATETIME NOT NULL,
    Status              VARCHAR(20) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')) NOT NULL,
    Notes               TEXT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DentistID) REFERENCES Dentists(DentistID)
);

CREATE INDEX IX_Appointments_Patient ON Appointments(PatientID);
CREATE INDEX IX_Appointments_Dentist ON Appointments(DentistID);
CREATE INDEX IX_Appointments_DateTime ON Appointments(AppointmentDateTime);

-- ------------------------------------------------------------
-- Treatments
-- ------------------------------------------------------------
CREATE TABLE Treatments (
    TreatmentID   INT IDENTITY(1,1) PRIMARY KEY,
    TreatmentName VARCHAR(100)   NOT NULL,
    Description   TEXT,
    Cost          DECIMAL(10,2) NOT NULL CHECK (Cost >= 0)
);

-- ------------------------------------------------------------
-- Patient_Treatments (Many-to-Many)
-- ------------------------------------------------------------
CREATE TABLE Patient_Treatments (
    PatientTreatmentID INT IDENTITY(1,1) PRIMARY KEY,
    PatientID          INT  NOT NULL,
    TreatmentID        INT  NOT NULL,
    AppointmentID      INT  NOT NULL,
    DatePerformed      DATE NOT NULL,
    Notes              TEXT,
    FOREIGN KEY (PatientID)     REFERENCES Patients(PatientID),
    FOREIGN KEY (TreatmentID)   REFERENCES Treatments(TreatmentID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- ------------------------------------------------------------
-- Payments
-- ------------------------------------------------------------
CREATE TABLE Payments (
    PaymentID     INT IDENTITY(1,1) PRIMARY KEY,
    PatientID     INT           NOT NULL,
    AppointmentID INT           NOT NULL,
    Amount        DECIMAL(10,2) NOT NULL CHECK (Amount > 0),
    PaymentMethod VARCHAR(20)   CHECK (PaymentMethod IN ('Cash', 'Credit Card', 'Insurance')) NOT NULL,
    PaymentDate   DATE          NOT NULL,
    Status        VARCHAR(20)   CHECK (Status IN ('Pending', 'Completed', 'Failed')) NOT NULL,
    FOREIGN KEY (PatientID)     REFERENCES Patients(PatientID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- ------------------------------------------------------------
-- Staff
-- ------------------------------------------------------------
CREATE TABLE Staff (
    StaffID       INT IDENTITY(1,1) PRIMARY KEY,
    FirstName     VARCHAR(50)   NOT NULL,
    LastName      VARCHAR(50)   NOT NULL,
    Role          VARCHAR(50)   NOT NULL,
    ContactNumber VARCHAR(15)   NOT NULL,
    Email         VARCHAR(100)  NOT NULL,
    Salary        DECIMAL(10,2) NOT NULL CHECK (Salary >= 0),
    HireDate      DATE          DEFAULT GETDATE()
);