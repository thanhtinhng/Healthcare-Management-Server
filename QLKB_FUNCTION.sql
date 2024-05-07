/*Tính tuổi của bệnh nhân (phục vụ việc xem xét cấp loại thuốc và tư vấn phương pháp điều trị thích hợp cho bệnh nhân)*/
DELIMITER //
CREATE FUNCTION Age_Calculate(in_Birthdate DATE)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	RETURN FLOOR(DATEDIFF(NOW(), in_Birthdate) / 365);
END
//
DELIMITER ;

DELIMITER //
/*Tính số lượt khám bệnh trong ngày/tháng/năm.*/
CREATE FUNCTION numConsultation(in_day INT, in_month INT, in_year INT)
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
	DECLARE num_Consultation INT;
    
	IF (in_day IS NOT NULL AND in_month IS NULL) OR (in_month IS NOT NULL AND in_year IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tham số truyền vào không đúng, hãy truyền vào ngày tháng năm hoặc tháng năm hoặc năm hoặc không truyền nếu muốn tính tất cả.';
        RETURN NULL;
    END IF;
    
    /*Tính số lượt khám bệnh theo ngày*/
    IF in_day IS NOT NULL THEN
		SELECT COUNT(Consultation.ConsultationID) INTO num_Consultation
        FROM Consultation
        WHERE DAY(Consultation.StartTime) = in_day AND MONTH(Consultation.StartTime) = in_month AND YEAR(Consultation.StartTime) = in_year;
	ELSE 
		/*Tính số lượt khám bệnh theo tháng*/
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
