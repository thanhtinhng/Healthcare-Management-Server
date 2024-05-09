/*Ẩn mật khẩu*/
CREATE VIEW patient_VIEW AS
SELECT PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact
FROM Patient;

CREATE VIEW doctor_VIEW AS
SELECT DoctorID, DoctorName, Gender, DoctorBirthdate, DateJoined, Specialization, Department, DoctorPhone, DoctorEmail
FROM Doctor;

CREATE VIEW receptionist_VIEW AS
SELECT ReceptionistID, ReceptionistName, Gender, ReceptionistBirthdate, DateJoined, ReceptionistPhone, ReceptionistEmail
FROM Receptionist;

CREATE VIEW labphysician_VIEW AS
SELECT LabPhysID, LabPhysName, Gender, LabPhysBirthdate, DateJoined, Specialization, LabPhysPhone, LabPhysEmail
FROM LaboratoryPhysician;