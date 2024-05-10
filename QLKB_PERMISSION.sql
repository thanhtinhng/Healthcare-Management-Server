/*Tạo role*/
CREATE ROLE 'admin_role';
CREATE ROLE 'patient_role';
CREATE ROLE 'doctor_role';
CREATE ROLE 'receptionist_role';
CREATE ROLE 'labphysician_role';

/*Tạo user và grant role cho user*/
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'user';
GRANT 'admin_role' TO 'admin_user'@'localhost';
SET DEFAULT ROLE 'admin_role' TO 'admin_user'@'localhost';

CREATE USER 'patient_user'@'localhost' IDENTIFIED BY 'user';
GRANT 'patient_role' TO 'patient_user'@'localhost';
SET DEFAULT ROLE 'patient_role' TO 'patient_user'@'localhost';

CREATE USER 'doctor_user'@'localhost' IDENTIFIED BY 'user';
GRANT 'doctor_role' TO 'doctor_user'@'localhost';
SET DEFAULT ROLE 'doctor_role' TO 'doctor_user'@'localhost';

CREATE USER 'receptionist_user'@'localhost' IDENTIFIED BY 'user';
GRANT 'receptionist_role' TO 'receptionist_user'@'localhost';
SET DEFAULT ROLE 'receptionist_role' TO 'receptionist_user'@'localhost';

CREATE USER 'labphysician_user'@'localhost' IDENTIFIED BY 'user';
GRANT 'labphysician_role' TO 'labphysician_user'@'localhost';
SET DEFAULT ROLE 'labphysician_role' TO 'labphysician_user'@'localhost';

/*admin_role*/
GRANT SELECT, INSERT, UPDATE, DELETE ON qlkb.Appointment TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON qlkb.Bill TO admin_role WITH GRANT OPTION;
GRANT SELECT ON qlkb.Consultation TO admin_role WITH GRANT OPTION;
GRANT SELECT ON qlkb.Consultation_Diagnosis TO admin_role WITH GRANT OPTION;
GRANT SELECT ON qlkb.Consultation_Medicine TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON qlkb.diagnosis TO admin_role WITH GRANT OPTION;
GRANT SELECT (DoctorID, DoctorName, Gender, DoctorBirthdate, DateJoined, Specialization, Department, DoctorPhone, DoctorEmail), INSERT, UPDATE (DoctorID, DoctorName, Gender, DoctorBirthdate, DateJoined, Specialization, Department, DoctorPhone, DoctorEmail) ON qlkb.Doctor TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE (EndDate) ON qlkb.InsuranceDetail TO admin_role WITH GRANT OPTION;
GRANT SELECT (LabPhysID, LabPhysName, Gender, LabPhysBirthdate, DateJoined, Specialization, LabPhysPhone, LabPhysEmail), INSERT, UPDATE (LabPhysID, LabPhysName, Gender, LabPhysBirthdate, DateJoined, Specialization, LabPhysPhone, LabPhysEmail) ON qlkb.LaboratoryPhysician TO admin_role WITH GRANT OPTION;
GRANT SELECT ON qlkb.Medicaltest TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON qlkb.Medicine TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON qlkb.MedicineManufaturer TO admin_role WITH GRANT OPTION;
GRANT SELECT (PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact), INSERT, UPDATE (PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact) ON qlkb.Patient TO admin_role WITH GRANT OPTION;
GRANT SELECT (ReceptionistID, ReceptionistName, Gender, ReceptionistBirthdate, DateJoined, ReceptionistPhone, ReceptionistEmail), INSERT, UPDATE (ReceptionistID, ReceptionistName, Gender, ReceptionistBirthdate, DateJoined, ReceptionistPhone, ReceptionistEmail) ON qlkb.Receptionist TO admin_role WITH GRANT OPTION;

GRANT EXECUTE ON PROCEDURE qlkb.Appointment_List_byDoctor TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_Diagnoses TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_History TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_MedicalTest TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_Prescription TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Delete_Expired_Appointments TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Diagnosis_ofMonth TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Doctor_List_BySpecialization TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Medicine_ofMonth TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Medicine_Receiving TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Patient_List TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON PROCEDURE qlkb.Revenue_ofMonth TO admin_role WITH GRANT OPTION;

GRANT EXECUTE ON FUNCTION qlkb.age_Calculate TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON FUNCTION qlkb.billValueCalculate TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON FUNCTION qlkb.calculateRevenue TO admin_role WITH GRANT OPTION;
GRANT EXECUTE ON FUNCTION qlkb.numConsultation TO admin_role WITH GRANT OPTION;

/*patient_role*/
GRANT SELECT, INSERT, UPDATE ON qlkb.Appointment TO patient_role;
GRANT SELECT ON qlkb.Bill TO patient_role;
GRANT SELECT ON qlkb.Consultation TO patient_role;
GRANT SELECT ON qlkb.Consultation_Diagnosis TO patient_role;
GRANT SELECT ON qlkb.Consultation_Medicine TO patient_role;
GRANT SELECT ON qlkb.doctor_VIEW TO patient_role;
GRANT SELECT ON qlkb.InsuranceDetail TO patient_role;
GRANT SELECT ON qlkb.Medicaltest TO patient_role;
GRANT SELECT (PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact), INSERT, UPDATE (PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact) ON qlkb.Patient TO patient_role;

GRANT EXECUTE ON PROCEDURE qlkb.Consultation_Diagnoses TO patient_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_MedicalTest TO patient_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_Prescription TO patient_role;
GRANT EXECUTE ON PROCEDURE qlkb.Doctor_List_BySpecialization TO patient_role;

/*doctor_role*/
GRANT SELECT ON qlkb.Appointment TO doctor_role;
GRANT SELECT ON qlkb.Bill TO doctor_role;
GRANT SELECT, INSERT, UPDATE ON qlkb.Consultation TO doctor_role;
GRANT SELECT, INSERT, UPDATE ON qlkb.Consultation_Diagnosis TO doctor_role;
GRANT SELECT, INSERT, UPDATE ON qlkb.Consultation_Medicine TO doctor_role;
GRANT SELECT ON qlkb.diagnosis TO doctor_role;
GRANT SELECT (DoctorID, DoctorName, Gender, DoctorBirthdate, DateJoined, Specialization, Department, DoctorPhone, DoctorEmail), INSERT, UPDATE (DoctorID, DoctorName, Gender, DoctorBirthdate, DateJoined, Specialization, Department, DoctorPhone, DoctorEmail) ON qlkb.Doctor TO doctor_role;
GRANT SELECT ON qlkb.InsuranceDetail TO doctor_role;
GRANT SELECT ON qlkb.labphysician_VIEW TO doctor_role;
GRANT SELECT ON qlkb.Medicaltest TO doctor_role;
GRANT SELECT ON qlkb.Medicine TO doctor_role;
GRANT SELECT ON qlkb.MedicineManufaturer TO doctor_role;
GRANT SELECT ON qlkb.patient_VIEW TO doctor_role;

GRANT EXECUTE ON PROCEDURE qlkb.Appointment_List_byDoctor TO doctor_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_Diagnoses TO doctor_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_History TO doctor_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_MedicalTest TO doctor_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_Prescription TO doctor_role;

GRANT EXECUTE ON FUNCTION qlkb.age_Calculate TO doctor_role;
GRANT EXECUTE ON FUNCTION qlkb.billValueCalculate TO doctor_role;

/*receptionist_role*/
GRANT SELECT, INSERT, UPDATE, DELETE ON qlkb.Appointment TO receptionist_role;
GRANT SELECT, INSERT, UPDATE ON qlkb.Bill TO receptionist_role;
GRANT SELECT ON qlkb.doctor_VIEW TO receptionist_role;
GRANT SELECT ON qlkb.InsuranceDetail TO receptionist_role;
GRANT SELECT (PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact), INSERT, UPDATE (PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact) ON qlkb.Patient TO receptionist_role;
GRANT SELECT (ReceptionistID, ReceptionistName, Gender, ReceptionistBirthdate, DateJoined, ReceptionistPhone, ReceptionistEmail), INSERT, UPDATE (ReceptionistID, ReceptionistName, Gender, ReceptionistBirthdate, DateJoined, ReceptionistPhone, ReceptionistEmail) ON qlkb.Receptionist TO receptionist_role;

GRANT EXECUTE ON PROCEDURE qlkb.Patient_List TO receptionist_role;
GRANT EXECUTE ON PROCEDURE qlkb.Appointment_List_byDoctor TO receptionist_role;
GRANT EXECUTE ON PROCEDURE qlkb.Doctor_List_BySpecialization TO receptionist_role;

GRANT EXECUTE ON FUNCTION qlkb.age_Calculate TO receptionist_role;

/*labphysician_role*/
GRANT SELECT ON qlkb.Consultation TO labphysician_role;
GRANT SELECT ON qlkb.Consultation_Diagnosis TO labphysician_role;
GRANT SELECT ON qlkb.Consultation_Medicine TO labphysician_role;
GRANT SELECT ON qlkb.diagnosis TO labphysician_role;
GRANT SELECT ON qlkb.doctor_VIEW TO labphysician_role;
GRANT SELECT (LabPhysID, LabPhysName, Gender, LabPhysBirthdate, DateJoined, Specialization, LabPhysPhone, LabPhysEmail), INSERT, UPDATE (LabPhysID, LabPhysName, Gender, LabPhysBirthdate, DateJoined, Specialization, LabPhysPhone, LabPhysEmail) ON qlkb.LaboratoryPhysician TO labphysician_role;
GRANT SELECT, INSERT, UPDATE ON qlkb.Medicaltest TO labphysician_role;
GRANT SELECT ON qlkb.Medicine TO labphysician_role;
GRANT SELECT ON qlkb.MedicineManufaturer TO labphysician_role;
GRANT SELECT ON qlkb.patient_VIEW TO labphysician_role;

GRANT EXECUTE ON PROCEDURE qlkb.Consultation_Diagnoses TO labphysician_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_History TO labphysician_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_MedicalTest TO labphysician_role;
GRANT EXECUTE ON PROCEDURE qlkb.Consultation_Prescription TO labphysician_role;

GRANT EXECUTE ON FUNCTION qlkb.age_Calculate TO labphysician_role;