-- ============================================================
-- Dental Clinic Management System
-- Sample Queries & Analytics
-- ============================================================

USE DentalClinic;
GO

-- ------------------------------------------------------------
-- 1. All scheduled appointments with patient & dentist names
-- ------------------------------------------------------------
SELECT
    a.AppointmentID,
    p.FirstName + ' ' + p.LastName   AS Patient,
    d.FirstName + ' ' + d.LastName   AS Dentist,
    d.Specialization,
    a.AppointmentDateTime,
    a.Status,
    a.Notes
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Dentists d ON a.DentistID = d.DentistID
WHERE a.Status = 'Scheduled'
ORDER BY a.AppointmentDateTime;

-- ------------------------------------------------------------
-- 2. Total revenue by payment method
-- ------------------------------------------------------------
SELECT
    PaymentMethod,
    COUNT(*)            AS Transactions,
    SUM(Amount)         AS TotalRevenue,
    AVG(Amount)         AS AvgPayment
FROM Payments
WHERE Status = 'Completed'
GROUP BY PaymentMethod
ORDER BY TotalRevenue DESC;

-- ------------------------------------------------------------
-- 3. Most performed treatments
-- ------------------------------------------------------------
SELECT
    t.TreatmentName,
    COUNT(pt.PatientTreatmentID) AS TimesPerformed,
    SUM(t.Cost)                  AS TotalRevenue
FROM Patient_Treatments pt
JOIN Treatments t ON pt.TreatmentID = t.TreatmentID
GROUP BY t.TreatmentName
ORDER BY TimesPerformed DESC;

-- ------------------------------------------------------------
-- 4. Dentist workload (appointments per dentist)
-- ------------------------------------------------------------
SELECT
    d.FirstName + ' ' + d.LastName AS Dentist,
    d.Specialization,
    COUNT(a.AppointmentID)         AS TotalAppointments,
    SUM(CASE WHEN a.Status = 'Completed'  THEN 1 ELSE 0 END) AS Completed,
    SUM(CASE WHEN a.Status = 'Cancelled'  THEN 1 ELSE 0 END) AS Cancelled
FROM Dentists d
LEFT JOIN Appointments a ON d.DentistID = a.DentistID
GROUP BY d.DentistID, d.FirstName, d.LastName, d.Specialization
ORDER BY TotalAppointments DESC;

-- ------------------------------------------------------------
-- 5. Patients with pending payments
-- ------------------------------------------------------------
SELECT
    p.FirstName + ' ' + p.LastName AS Patient,
    p.ContactNumber,
    p.Email,
    SUM(pay.Amount)                AS AmountDue
FROM Payments pay
JOIN Patients p ON pay.PatientID = p.PatientID
WHERE pay.Status = 'Pending'
GROUP BY p.PatientID, p.FirstName, p.LastName, p.ContactNumber, p.Email
ORDER BY AmountDue DESC;

-- ------------------------------------------------------------
-- 6. Monthly revenue report
-- ------------------------------------------------------------
SELECT
    YEAR(PaymentDate)  AS Year,
    MONTH(PaymentDate) AS Month,
    COUNT(*)           AS Payments,
    SUM(Amount)        AS Revenue
FROM Payments
WHERE Status = 'Completed'
GROUP BY YEAR(PaymentDate), MONTH(PaymentDate)
ORDER BY Year DESC, Month DESC;