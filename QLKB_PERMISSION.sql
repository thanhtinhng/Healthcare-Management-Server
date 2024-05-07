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
GRANT SELECT, INSERT, UPDATE ON qlkb.Doctor TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON qlkb.InsuranceDetail TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON qlkb.LaboratoryPhysician TO admin_role WITH GRANT OPTION;
GRANT SELECT ON qlkb.Medicaltest TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON qlkb.Medicine TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE, DELETE ON qlkb.MedicineManufaturer TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON qlkb.Patient TO admin_role WITH GRANT OPTION;
GRANT SELECT, INSERT, UPDATE ON qlkb.Receptionist TO admin_role WITH GRANT OPTION;
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

SHOW FUNCTION STATUS where db = 'qlkb'

