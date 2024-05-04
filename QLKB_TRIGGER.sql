/*Kiểm tra số lượng thuốc trong kho và cập nhật lại số lượng thuốc khi kê đơn mới.*/
DELIMITER //
CREATE TRIGGER Consultation_Medicine_Quantity_Insert
BEFORE INSERT ON Consultation_Medicine
FOR EACH ROW
BEGIN
	DECLARE newQuantity INT;
    SET newQuantity = NEW.Quantity;
    IF EXISTS (SELECT 1 FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedIConsultation_Medicine_Quantity_InsertConsultation_Medicine_Quantity_UpdateD) THEN
		IF (SELECT Quantity - newQuantity FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedID) >= 0 THEN
			UPDATE MEDICINE
            SET Quantity = Quantity - newQuantity
            WHERE MEDICINE.MedID = NEW.MedID;
		ELSE
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Số lượng thuốc kê đơn lớn hơn số lượng sẵn có!';
		END IF;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã thuốc không tồn tại!';
	END IF;
END;
//
DELIMITER ;

/*Kiểm tra số lượng thuốc trong kho và cập nhật lại số lượng thuốc khi cập nhật đơn thuốc.*/
DELIMITER //
CREATE TRIGGER Consultation_Medicine_Quantity_Update
BEFORE UPDATE ON Consultation_Medicine
FOR EACH ROW
BEGIN
	DECLARE newQuantity, oldQuantity INT;
    SET newQuantity = NEW.Quantity;
    SET oldQuantity = OLD.Quantity;
    IF EXISTS (SELECT 1 FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedID) THEN
		IF (NEW.MedID = OLD.MedID) THEN
			IF (SELECT ((Quantity + oldQuantity) - newQuantity) FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedID) >= 0 THEN
				UPDATE MEDICINE
				SET Quantity = (Quantity + oldQuantity) - newQuantity
				WHERE MEDICINE.MedID = NEW.MedID;
			ELSE
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Số lượng thuốc cập nhật lớn hơn số lượng sẵn có!';
			END IF;
		ELSE
			IF (SELECT (Quantity - newQuantity) FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedID) >= 0 THEN
				UPDATE MEDICINE
                SET Quantity = Quantity - newQuantity
				WHERE MEDICINE.MedID = NEW.MedID;
				
                UPDATE MEDICINE
                SET Quantity = Quantity + oldQuantity
                WHERE MEDICINE.MedID = OLD.MedID;
			ELSE
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Số lượng thuốc cập nhật lớn hơn số lượng sẵn có!';
			END IF;
        END IF;
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã thuốc không tồn tại!';
	END IF;
END;
//
DELIMITER ;

/*Kiểm tra có đúng của bệnh nhân không và có còn hạn sử dụng không.*/
DELIMITER //
CREATE TRIGGER Bill_Insurance_Owner_Date_Insert
BEFORE INSERT ON BiLL
FOR EACH ROW
BEGIN
	DECLARE insuranceOwnerID INT;
    DECLARE patientConsultation INT;
	DECLARE insuranceDate DATE;
    DECLARE consultTime DATETIME;
    
/*Kiểm tra có đúng mã bảo hiểm của bệnh nhân không*/
    SET insuranceOwnerID = (SELECT PatientID
							FROM InsuranceDetail
                            WHERE InsuranceID = NEW.InsuranceID);
	SET patientConsultation = (SELECT PatientID
								FROM Consultation
								WHERE ConsultationID = NEW.ConsultationID);            
	IF (insuranceOwnerID != patientConsultation) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã bảo hiểm của bệnh nhân không đúng!';
	END IF;
    
/*Kiểm tra ngày hết hạn bảo hiểm.*/
    SET insuranceDate = (SELECT EndDate
						FROM InsuranceDetail
						WHERE InsuranceID = NEW.InsuranceID);
    SET consultTime = (SELECT StartTime
						FROM Cosultation
						WHERE ConsultationID = NEW.ConsultationID);
    IF (insuranceDate < consultTime) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bảo hiểm đã hết hạn!';
	END IF;
END
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Bill_Insurance_Owner_Date_Update
BEFORE UPDATE ON BiLL
FOR EACH ROW
BEGIN
	DECLARE insuranceOwnerID INT;
    DECLARE patientConsultation INT;
	DECLARE insuranceDate DATE;
    DECLARE consultTime DATETIME;
    
/*Kiểm tra có đúng mã bảo hiểm của bệnh nhân không.*/
    SET insuranceOwnerID = (SELECT PatientID
							FROM InsuranceDetail
                            WHERE InsuranceID = NEW.InsuranceID);
	SET patientConsultation = (SELECT PatientID
								FROM Consultation
								WHERE ConsultationID = NEW.ConsultationID);            
	IF (insuranceOwnerID != patientConsultation) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Mã bảo hiểm của bệnh nhân không đúng!';
	END IF;
    
/*Kiểm tra ngày hết hạn bảo hiểm*/
    SET insuranceDate = (SELECT EndDate
						FROM InsuranceDetail
						WHERE InsuranceID = NEW.InsuranceID);
    SET consultTime = (SELECT StartTime
						FROM Cosultation
						WHERE ConsultationID = NEW.ConsultationID);
    IF (insuranceDate < consultTime) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bảo hiểm đã hết hạn!';
	END IF;
END
//
DELIMITER ;

/*Kiểm tra lịch trống của bác sĩ khi đặt lịch. (sử dụng cursor)*/
DELIMITER //
CREATE TRIGGER Appointment_Check_Available_INSERT
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    DECLARE done BOOL DEFAULT false;
    DECLARE loopDoctorID INT;
    DECLARE loopConsultationTime INT;
	DECLARE cur CURSOR FOR SELECT DoctorID, ConsultationTime FROM Appointment WHERE DoctorID = NEW.DoctorID ;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    OPEN CUR;
    check_available: LOOP
		FETCH cur INTO loopDoctorID, loopConsultationTime;
        IF done = true THEN LEAVE check_available; 
        END IF;
        IF (loopDoctorID = NEW.DoctorID AND loopConsultationTime = NEW.ConsultationTime) THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Thời gian bạn đặt không còn trống!';
		END IF;
	END LOOP;
        CLOSE cur;
END
//
DELIMITER ;

