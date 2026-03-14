-- ============================================================
-- Dental Clinic Management System
-- Stored Procedures & Triggers
-- ============================================================

USE DentalClinic;
GO

-- ------------------------------------------------------------
-- SP: Book a new appointment
-- ------------------------------------------------------------
CREATE PROCEDURE sp_BookAppointment
    @PatientID  INT,
    @DentistID  INT,
    @DateTime   DATETIME,
    @Notes      TEXT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for dentist conflicts
    IF EXISTS (
        SELECT 1 FROM Appointments
        WHERE DentistID = @DentistID
          AND AppointmentDateTime = @DateTime
          AND Status = 'Scheduled'
    )
    BEGIN
        RAISERROR('Dentist is not available at the requested time.', 16, 1);
        RETURN;
    END

    INSERT INTO Appointments (PatientID, DentistID, AppointmentDateTime, Status, Notes)
    VALUES (@PatientID, @DentistID, @DateTime, 'Scheduled', @Notes);

    SELECT SCOPE_IDENTITY() AS NewAppointmentID;
END;
GO

-- ------------------------------------------------------------
-- SP: Process payment for an appointment
-- ------------------------------------------------------------
CREATE PROCEDURE sp_ProcessPayment
    @PatientID     INT,
    @AppointmentID INT,
    @Amount        DECIMAL(10,2),
    @Method        VARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Payments (PatientID, AppointmentID, Amount, PaymentMethod, PaymentDate, Status)
    VALUES (@PatientID, @AppointmentID, @Amount, @Method, CAST(GETDATE() AS DATE), 'Completed');

    -- Mark appointment as completed
    UPDATE Appointments
    SET Status = 'Completed'
    WHERE AppointmentID = @AppointmentID;
END;
GO

-- ------------------------------------------------------------
-- SP: Get full patient history
-- ------------------------------------------------------------
CREATE PROCEDURE sp_GetPatientHistory
    @PatientID INT
AS
BEGIN
    SELECT
        a.AppointmentDateTime,
        d.FirstName + ' ' + d.LastName AS Dentist,
        d.Specialization,
        t.TreatmentName,
        t.Cost,
        p.PaymentMethod,
        p.Status AS PaymentStatus
    FROM Appointments a
    JOIN Dentists d           ON a.DentistID = d.DentistID
    LEFT JOIN Patient_Treatments pt ON pt.AppointmentID = a.AppointmentID
    LEFT JOIN Treatments t    ON t.TreatmentID = pt.TreatmentID
    LEFT JOIN Payments p      ON p.AppointmentID = a.AppointmentID
    WHERE a.PatientID = @PatientID
    ORDER BY a.AppointmentDateTime DESC;
END;
GO

-- ------------------------------------------------------------
-- Trigger: Prevent double-booking a patient
-- ------------------------------------------------------------
CREATE TRIGGER trg_PreventDoubleBooking
ON Appointments
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Appointments a
        JOIN inserted i ON a.PatientID = i.PatientID
            AND a.AppointmentDateTime = i.AppointmentDateTime
            AND a.AppointmentID <> i.AppointmentID
            AND a.Status = 'Scheduled'
    )
    BEGIN
        RAISERROR('Patient already has an appointment at this time.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- ------------------------------------------------------------
-- Trigger: Log cancelled appointments
-- ------------------------------------------------------------
CREATE TABLE Appointment_Audit (
    AuditID       INT IDENTITY(1,1) PRIMARY KEY,
    AppointmentID INT,
    PatientID     INT,
    CancelledAt   DATETIME DEFAULT GETDATE(),
    OldStatus     VARCHAR(20),
    NewStatus     VARCHAR(20)
);
GO

CREATE TRIGGER trg_AuditAppointmentStatus
ON Appointments
AFTER UPDATE
AS
BEGIN
    IF UPDATE(Status)
    INSERT INTO Appointment_Audit (AppointmentID, PatientID, OldStatus, NewStatus)
    SELECT i.AppointmentID, i.PatientID, d.Status, i.Status
    FROM inserted i
    JOIN deleted d ON i.AppointmentID = d.AppointmentID
    WHERE i.Status <> d.Status;
END;
GO