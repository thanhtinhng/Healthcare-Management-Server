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

/*view để xem thông tin*/
/*Danh sách bệnh nhân*/
CREATE VIEW patient_list_VIEW AS
SELECT PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact
FROM Patient;

/*Danh sách thuốc sắp hết hàng trong kho (xét số lượng <= 50)*/
CREATE VIEW medicine_low_quantity_VIEW AS
SELECT MedID, MedName, Unit, Quantity
FROM Medicine
WHERE Quantity <= 50;

/*View để kết hợp dữ liệu từ nhiều bảng*/
/*Hiển thị đầy đủ thông tin thuốc về thuốc*/
CREATE VIEW medicine_details_VIEW AS
SELECT MedID, MedName, MedDesc, Unit, PurchasePrice, Price, Quantity, Medicine.ManufID, ManufName
FROM Medicine JOIN MedicineManufaturer ON Medicine.ManufID = MedicineManufaturer.ManufID;

/*Hiển thị chi tiết đơn thuốc của các lần khám bệnh*/
CREATE VIEW prescription_VIEW AS
SELECT Consultation.ConsultationID, PatientName, DoctorName, EndTime, Consultation_Medicine.MedID, MedName, Consultation_Medicine.Quantity, Unit
FROM Consultation
JOIN Patient ON Consultation.PatientID = Patient.PatientID
JOIN Doctor ON Consultation.DoctorID = Doctor.DoctorID
JOIN Consultation_Medicine ON Consultation.ConsultationID = Consultation_Medicine.ConsultationID
JOIN Medicine ON Consultation_Medicine.MedID = Medicine.MedID
ORDER BY ConsultationID;

 