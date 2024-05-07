/*Kiểm tra số lượng thuốc trong kho và cập nhật lại số lượng thuốc khi kê đơn mới.*/
DELIMITER //
CREATE TRIGGER Consultation_Medicine_Quantity_Insert
BEFORE INSERT ON Consultation_Medicine
FOR EACH ROW
BEGIN
	DECLARE newQuantity INT;
    SET newQuantity = NEW.Quantity;
    IF EXISTS (SELECT 1 FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedID) THEN
    /*Trừ số lượng thuốc sẵn có trong kho*/
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
			IF (SELECT Quantity + oldQuantity - newQuantity FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedID) >= 0 THEN
				UPDATE MEDICINE
				SET Quantity = (Quantity + oldQuantity) - newQuantity
				WHERE MEDICINE.MedID = NEW.MedID;
			ELSE
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Số lượng thuốc cập nhật lớn hơn số lượng sẵn có!';
			END IF;
		ELSE
			IF (SELECT Quantity - newQuantity FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedID) >= 0 THEN
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
						FROM Consultation
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
						FROM Consultation
						WHERE ConsultationID = NEW.ConsultationID);
    IF (insuranceDate < consultTime) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bảo hiểm đã hết hạn!';
	END IF;
END
//
DELIMITER ;

/*Kiểm tra lịch trống của bác sĩ khi đặt lịch.*/
DELIMITER //
CREATE TRIGGER Appointment_Check_Available_INSERT
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 
				FROM Appointment 
				WHERE DoctorID = NEW.DoctorID AND ConsultationTime = NEW.ConsultationTime)
		THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Thời gian bạn đặt không còn trống!';
	END IF;
END
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Appointment_Check_Available_UPDATE
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 
				FROM Appointment 
				WHERE DoctorID = NEW.DoctorID AND ConsultationTime = NEW.ConsultationTime)
		THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Thời gian bạn đặt không còn trống!';
	END IF;
END
//
DELIMITER ;

/*Các cuộc hẹn khám bệnh phải được đặt cách nhau 30 phút*/
DELIMITER //
CREATE TRIGGER Appointment_Time_INSERT
BEFORE INSERT ON Appointment
FOR EACH ROW
BEGIN
	IF (SELECT MINUTE(NEW.ConsultationTime)) != 0 AND (SELECT MINUTE(NEW.ConsultationTime)) != 30 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Thời gian phải cách nhau ít nhất 30 phút.';
	END IF;
/*Thao tác này có nghĩa là bắt buộc giờ đặt lịch phải là 00 phút hoặc 30 phút (ví dụ 7:00; 7:30; 8:00;...) để đảm bảo các cuộc hẹn phải cách nhau 30 phút.*/
END
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Appointment_Time_UPDATE
BEFORE UPDATE ON Appointment
FOR EACH ROW
BEGIN
	IF (SELECT MINUTE(NEW.ConsultationTime)) != 0 AND (SELECT MINUTE(NEW.ConsultationTime)) != 30 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Thời gian phải cách nhau ít nhất 30 phút.';
	END IF;
/*Thao tác này có nghĩa là bắt buộc giờ đặt lịch phải là 00 phút hoặc 30 phút (ví dụ 7:00; 7:30; 8:00;...) để đảm bảo các cuộc hẹn phải cách nhau 30 phút.*/
END
//
DELIMITER ;

/*Tự động tính trị giá hóa đơn khi INSERT*/
DELIMITER //
CREATE TRIGGER Bill_Total_INSERT
BEFORE INSERT ON Bill
FOR EACH ROW
BEGIN
	DECLARE trigger_pretotal FLOAT;
    DECLARE trigger_total FLOAT;
    DECLARE discount DECIMAL(5,2);
    
    /*Gọi hàm tính trị giá hóa đơn*/
    SET trigger_pretotal = billValueCalculate(NEW.ConsultationID);
    
    SET NEW.PreTotal = trigger_pretotal;
    SET NEW.Total = trigger_pretotal;
    
    /*Nếu có sử dụng bảo hiểm thì tính giảm giá*/
    IF NEW.InsuranceID IS NOT NULL THEN
		SELECT DiscountPercent INTO discount
        FROM InsuranceDetail
        WHERE InsuranceID = NEW.InsuranceID;
		SET trigger_total = trigger_pretotal - trigger_pretotal * discount;
		SET NEW.Total = trigger_total;
	END IF;
END
//
DELIMITER ;

/*Tự động tính trị giá hóa đơn khi UPDATE*/
DELIMITER //
CREATE TRIGGER Bill_Total_UPDATE
BEFORE UPDATE ON Bill
FOR EACH ROW
BEGIN
	DECLARE discount DECIMAL(5,2);
    DECLARE trigger_total FLOAT;
    
    /*Ràng buộc không được phép sửa PreTotal*/
	IF (NEW.PreTotal != OLD.PreTotal) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trị giá hóa đơn phải được tính tự động, không được sửa thủ công.';
	END IF;
    
    /*Nếu cập nhật không sử dụng bảo hiểm thì cập nhật lại giá cuối cùng bằng giá ban đầu*/
	IF NEW.InsuranceID IS NULL THEN
		SET NEW.Total = OLD.PreTotal;
        
	/*Nếu cập nhật có sử dụng bảo hiểm thì cập nhật lại giá cuối*/
	ELSE 
		SELECT DiscountPercent INTO discount
        FROM InsuranceDetail
        WHERE InsuranceID = NEW.InsuranceID;
		SET trigger_total = OLD.PreTotal - OLD.PreTotal * discount;
		SET NEW.Total = trigger_total;
	END IF;
END
//
DELIMITER ;



