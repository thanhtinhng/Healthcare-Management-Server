/*Tính tuổi của bệnh nhân (phục vụ việc xem xét cấp loại thuốc và tư vấn phương pháp điều trị thích hợp cho bệnh nhân)*/
DELIMITER //
CREATE FUNCTION age_Calculate(in_Birthdate DATE)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	RETURN FLOOR(DATEDIFF(NOW(), in_Birthdate) / 365);
END
//
DELIMITER ;

DELIMITER //
/*Tính số bệnh nhân đến khám trong ngày/tháng/năm.*/
CREATE FUNCTION numConsultation(in_day INT, in_month INT, in_year INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE num_Consultation INT;
    
	IF (in_day IS NOT NULL AND in_month IS NULL) OR (in_month IS NOT NULL AND in_year IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tham số truyền vào không đúng, hãy truyền vào ngày-tháng-năm hoặc tháng-năm hoặc năm hoặc không truyền (nếu muốn tính tất cả).';
        RETURN NULL;
    END IF;
    
    /*Tính số lượt khám bệnh theo ngày-tháng-năm*/
    IF in_day IS NOT NULL THEN
		SELECT COUNT(Consultation.ConsultationID) INTO num_Consultation
        FROM Consultation
        WHERE DAY(Consultation.StartTime) = in_day AND MONTH(Consultation.StartTime) = in_month AND YEAR(Consultation.StartTime) = in_year;
	ELSE 
		/*Tính số lượt khám bệnh theo tháng-năm*/
		IF in_month IS NOT NULL THEN
			SELECT COUNT(Consultation.ConsultationID) INTO num_Consultation
			FROM Consultation
			WHERE MONTH(Consultation.StartTime) = in_month AND YEAR(Consultation.StartTime) = in_year;
		ELSE 
			/*Tính số lượt khám bệnh theo năm*/
			IF in_year IS NOT NULL THEN
				SELECT COUNT(Consultation.ConsultationID) INTO num_Consultation
				FROM Consultation
				WHERE YEAR(Consultation.StartTime) = in_year;
			/*Tính số lượt khám bệnh tất cả*/
			ELSE
				SELECT COUNT(Consultation.ConsultationID) INTO num_Consultation
				FROM Consultation;
			END IF;
		END IF;
    END IF;
    RETURN num_Consultation;
END;
//
DELIMITER ;

/*Tính doanh thu trong ngày/tháng/năm.*/
DELIMITER //
CREATE FUNCTION calculateRevenue(in_day INT, in_month INT, in_year INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE revenue FLOAT;
    
	IF (in_day IS NOT NULL AND in_month IS NULL) OR (in_month IS NOT NULL AND in_year IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tham số truyền vào không đúng, hãy truyền vào ngày-tháng-năm hoặc tháng-năm hoặc năm hoặc không truyền (nếu muốn tính tất cả).';
        RETURN NULL;
    END IF;
    
    /*Tính doanh thu theo ngày-tháng-năm*/
    IF in_day IS NOT NULL THEN
		SELECT COALESCE(SUM(Total), 0) INTO revenue
        FROM Bill
        WHERE DAY(BillDate) = in_day AND MONTH(BillDate) = in_month AND YEAR(BillDate) = in_year;
	ELSE 
		/*Tính doanh thu theo tháng-năm*/
		IF in_month IS NOT NULL THEN
			SELECT COALESCE(SUM(Total), 0) INTO revenue
			FROM Bill
			WHERE MONTH(BillDate) = in_month AND YEAR(BillDate) = in_year;
		ELSE 
			/*Tính doanh thu theo năm*/
			IF in_year IS NOT NULL THEN
				SELECT COALESCE(SUM(Total), 0) INTO revenue
				FROM Bill
				WHERE YEAR(BillDate) = in_year;
			/*Tính doanh thu tất cả các ngày*/
			ELSE
				SELECT COALESCE(SUM(Total), 0) INTO revenue
				FROM Bill;
			END IF;
		END IF;
    END IF;
    RETURN revenue;
END;
//
DELIMITER ;

/*Tính trị giá hóa đơn thuốc*/
DELIMITER //
CREATE FUNCTION billPrescriptionValueCalculate(in_ConsultationID INT)
RETURNS FLOAT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE total FLOAT;
    DECLARE loopQuantity INT;
    DECLARE loopPrice INT;
    DECLARE done BOOL DEFAULT false;
    DECLARE cur_Medicine CURSOR FOR
		SELECT consultation_medicine.Quantity, Price
        FROM consultation_medicine JOIN Medicine ON consultation_medicine.MedID = Medicine.MedID
        WHERE consultation_medicine.ConsultationID = in_ConsultationID;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    SET total = 0;
    
    /*Tính tổng giá đơn thuốc*/
    OPEN cur_Medicine;
    prescription_total_loop: LOOP
		FETCH cur_Medicine INTO loopQuantity, loopPrice;
        IF done = true THEN LEAVE prescription_total_loop;
        END IF;
        SET total = total + loopQuantity * loopPrice;
	END LOOP;
    CLOSE cur_Medicine;
    
    RETURN total;
END
//
DELIMITER ;

/*Tính trị giá hóa đơn xét nghiệm*/
DELIMITER //
CREATE FUNCTION billTestValueCalculate(in_ConsultationID INT)
RETURNS FLOAT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE total FLOAT;
    DECLARE loopFee FLOAT;
    DECLARE done BOOL DEFAULT false;

	DECLARE cur_Test CURSOR FOR
		SELECT TestFee
        FROM MedicalTest
        WHERE MedicalTest.ConsultationID = in_ConsultationID;
        
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = true;
    
    SET total = 0;

    /*Tính tổng giá đơn xét nghiệm*/
    OPEN cur_Test;
    test_total_loop: LOOP
		FETCH cur_Test INTO loopFee;
        IF done = true THEN LEAVE test_total_loop;
        END IF;
        SET total = total + loopFee;
	END LOOP;
    CLOSE cur_Test;
    
    RETURN total;
END
//
DELIMITER ;