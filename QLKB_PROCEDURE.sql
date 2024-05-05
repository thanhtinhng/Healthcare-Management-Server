/*Hiển thị danh sách bệnh nhân*/
DELIMITER //
CREATE PROCEDURE Patient_List()
BEGIN
	SELECT PatientID, CitizenID, PatientName, Gender, PatientBirthdate, PatientPhone, PatientEmail, PatientAddr, EmergencyContact
    FROM Patient;
END
//
DELIMITER ;

/*Hiển thị danh bác sĩ theo chuyên môn (phục vụ đặt lịch)*/
DELIMITER //
CREATE PROCEDURE Doctor_List_BySpecialization(IN in_Specialization varchar(255))
BEGIN
	IF NOT EXISTS (SELECT * FROM Doctor WHERE Specialization = in_Specialization) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không hợp lệ.';
    END IF;
	SELECT DoctorID, DoctorName, Gender, Specialization, Department, DoctorPhone, DoctorEmail
    FROM Doctor
    WHERE Specialization = in_Specialization;
END
//
DELIMITER ;

/*Thêm thuốc vào kho*/
DELIMITER //
CREATE PROCEDURE Medicine_Receiving(IN in_MedID INT, IN in_Quantity INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM Medicine WHERE MedID = in_MedID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã thuốc không tồn tại.';
    END IF;
    
    UPDATE Medicine
    SET Quantity = Quantity + in_Quantity
    WHERE MedID = in_MedID;
END
//
DELIMITER ;

/*Hiển thị lịch sử khám bệnh của bệnh nhân*/
DELIMITER //
CREATE PROCEDURE Consultation_History(IN in_PatientID INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM Consultation WHERE PatientID = in_PatientID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã bệnh nhân không tồn tại hoặc bệnh nhân này thực hiện khám bệnh.';
    END IF;
    
    SELECT ConsultationID, Conclusion, StartTime, EndTime, PatientID, DoctorID
	FROM Consultation
    WHERE PatientID = in_PatientID;
END
//
DELIMITER ;

/*Hiển thị chi tiết các chẩn đoán của lần khám bệnh*/
DELIMITER //
CREATE PROCEDURE Consultation_Diagnoses(IN in_ConsultationID INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM Consultation WHERE ConsultationID = in_ConsultationID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã khám bệnh không tồn tại.';
    END IF;
    
    SELECT Consultation.ConsultationID, PatientID, DoctorID, DiagnosisName, DiagnosisDesc, Severity
	FROM Consultation 
    JOIN Consultation_Diagnosis ON Consultation.ConsultationID = Consultation_Diagnosis.ConsultationID
	JOIN Diagnosis ON Consultation_Diagnosis.DiagnosisID = Diagnosis.DiagnosisID
    WHERE ConsultationID = in_ConsultationID;
END
//
DELIMITER ;

/*Hiển thị chi tiết đơn thuốc của lần khám bệnh*/
DELIMITER //
CREATE PROCEDURE Consultation_Prescription(IN in_ConsultationID INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM Consultation WHERE ConsultationID = in_ConsultationID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã khám bệnh không tồn tại.';
    END IF;
    
    IF NOT EXISTS (SELECT * FROM Consultation_Medicine WHERE ConsultationID = in_ConsultationID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lần khám bệnh này không được kê đơn thuốc!';
    END IF;
    
    SELECT Consultation.ConsultationID, PatientID, DoctorID, MedName, Consultation_Medicine.Quantity, Unit
	FROM Consultation 
    JOIN Consultation_Medicine ON Consultation.ConsultationID = Consultation_Medicine.ConsultationID
	JOIN Medicine ON Consultation_Medicine.MedID = Medicine.MedID
    WHERE ConsultationID = in_ConsultationID;
END
//
DELIMITER ;

/*Hiển thị chi tiết các xét nghiệm của lần khám bệnh*/
DELIMITER //
CREATE PROCEDURE Consultation_MedicalTest(IN in_ConsultationID INT)
BEGIN
	IF NOT EXISTS (SELECT * FROM Consultation WHERE ConsultationID = in_ConsultationID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã khám bệnh không tồn tại.';
    END IF;
    
	IF NOT EXISTS (SELECT * FROM MedicalTest WHERE ConsultationID = in_ConsultationID) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lần khám bệnh này không được chỉ định xét nghiệm!';
    END IF;
    
    SELECT ConsultationID, TestID, TestName, TestTime, Result
	FROM MedicalTest
    WHERE ConsultationID = in_ConsultationID;
END
//
DELIMITER ;

/*Hiển thị danh sách cuộc hẹn của bác sĩ*/
DELIMITER //
CREATE PROCEDURE Appointment_List_byDoctor(IN in_DoctorID INT, IN in_AppointmentDate DATE)
BEGIN
	SELECT * 
    FROM Appointment
    WHERE DoctorID = in_DoctorID AND DATE(ConsultationTime) = in_AppointmentDate
    ORDER BY ConsultationTime;
END
//
DELIMITER ;

/*Thống kê bệnh nhân mắc bệnh nào nhiều nhất theo tháng.*/
DELIMITER //
CREATE PROCEDURE Diagnosis_ofMonth (IN in_Month INT)
BEGIN
	SELECT Consultation_Diagnosis.DiagnosisID, DiagnosisName, COUNT(Consultation_Diagnosis.DiagnosisID) AS Number_of_Cases
    FROM Diagnosis, Consultation_Diagnosis, Consultation
    WHERE MONTH(Consultation.StartTime) = in_Month AND Consultation.ConsultationID = Consultation_Diagnosis.ConsultationID AND Consultation_Diagnosis.DiagnosisID = Diagnosis.DiagnosisID
    GROUP BY Consultation_Diagnosis.DiagnosisID, DiagnosisName
    ORDER BY COUNT(Consultation_Diagnosis.DiagnosisID) DESC;
END
//
DELIMITER ;

/*Thống kê thuốc nào được kê đơn nhiều nhất trong tháng.*/
DELIMITER //
CREATE PROCEDURE Medicine_ofMonth (IN in_Month INT)
BEGIN
	SELECT Medicine.MedID, MedName, COUNT(Consultation_Medicine.MedID) AS Quantity_of_MoNth
    FROM Medicine, Consultation_Medicine, Consultation
    WHERE MONTH(Consultation.StartTime) = in_Month AND Consultation.ConsultationID = Consultation_Medicine.ConsultationID AND Consultation_Medicine.MedID = Medicine.MedID
    GROUP BY Medicine.MedID, MedName
    ORDER BY COUNT(Consultation_Medicine.MedID) DESC;
END    
//
DELIMITER ;

/*Thống kê doanh thu từng tháng của từng năm.*/
DELIMITER //
CREATE PROCEDURE Revenue_ofMonth()
BEGIN
	SELECT YEAR(BillDate) AS Year, MONTH(BillDate) AS Month, COALESCE(SUM(Total), 0) AS Revenue
    FROM Bill
    GROUP BY YEAR(BillDate), MONTH(BillDate)
    ORDER BY YEAR(BillDate), MONTH(BillDate);
END
//
DELIMITER ;

/*Xóa các cuộc hẹn đã hết hạn. Ở đây quy định cuộc hẹn nào quá 7 cách ngày hiện tại sẽ bị xóa khỏi CSDL (Có sử dụng cursor)*/
DELIMITER //
CREATE PROCEDURE Delete_Expired_Appointments()
BEGIN
	DECLARE Expired_Date DATETIME;
    DECLARE done BOOL DEFAULT false;
    DECLARE loopAppointmentID INT;
    DECLARE loopConsultationTime DATETIME;
    DECLARE cur CURSOR FOR SELECT AppointmentID, ConsultationTime FROM Appointment;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
	SET Expired_Date = DATE_SUB(NOW(), INTERVAL 7 DAY);
    
    OPEN cur;
    delete_expired_appointments_loop: LOOP
		FETCH cur INTO loopAppointmentID, loopConsultationTime;
        IF done = true THEN LEAVE delete_expired_appointments_loop;
        END IF;
        IF (loopConsultationTime < Expired_Date) THEN
			DELETE FROM Appointment
            WHERE AppointmentID = loopAppointmentID;
		END IF;
	END LOOP;
    CLOSE cur;
END
//
DELIMITER ;

