DELIMITER //
CREATE TRIGGER Consultation_Medicine_Quantity_Insert
BEFORE INSERT ON Consultation_Medicine
FOR EACH ROW
BEGIN
	DECLARE newQuantity INT;
    SET newQuantity = NEW.Quantity;
    IF EXISTS (SELECT 1 FROM MEDICINE WHERE MEDICINE.MedID = NEW.MedID) THEN
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

