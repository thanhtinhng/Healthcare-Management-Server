CREATE DATABASE QLKB;

CREATE TABLE Allcode (
	id int AUTO_INCREMENT PRIMARY KEY,
    `type` varchar(50),
    `key` varchar(50),
    `value` varchar(255)
);

CREATE TABLE Admins (
    AdminID INT AUTO_INCREMENT PRIMARY KEY,
    CitizenID VARCHAR(20) NOT NULL UNIQUE,
    AdminName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL CHECK (Gender IN(0, 1)), /*0:Nam, 1: Nu*/
    AdminBirthdate DATE NOT NULL,
    AdminPhone VARCHAR(20) NOT NULL,
    AdminEmail VARCHAR(255) NOT NULL UNIQUE,
    AdminAddr VARCHAR(255) NOT NULL,
	AccPassword VARCHAR(255) NOT NULL,
    RoleId VARCHAR(2) NOT NULL DEFAULT 'R1'
);

CREATE TABLE Patient (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    CitizenID VARCHAR(20) NOT NULL UNIQUE,
    PatientName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL CHECK (Gender IN(0, 1)), /*0:Nam, 1: Nu*/
    PatientBirthdate DATE NOT NULL,
    PatientPhone VARCHAR(20) NOT NULL CHECK(PatientPhone LIKE('0%')), 
    PatientEmail VARCHAR(255) NOT NULL UNIQUE,
    PatientAddr VARCHAR(255) NOT NULL,
    EmergencyContact VARCHAR(255),
	AccPassword VARCHAR(255) NOT NULL,
    RoleId VARCHAR(2) NOT NULL DEFAULT 'R3'
);

CREATE TABLE InsuranceDetail (
    InsuranceID VARCHAR(20) PRIMARY KEY,
    DiscountPercent DECIMAL(5,2) NOT NULL,
    EndDate DATE NOT NULL,
    PatientID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
);

CREATE TABLE Receptionist (
    ReceptionistID INT AUTO_INCREMENT PRIMARY KEY,
    ReceptionistName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL CHECK (Gender IN(0, 1)),
    ReceptionistBirthdate DATE NOT NULL,
    DateJoined DATE NOT NULL,
    ReceptionistPhone VARCHAR(20) NOT NULL CHECK(ReceptionistPhone LIKE('0%')),
    ReceptionistEmail VARCHAR(255) NOT NULL UNIQUE,
	AccPassword VARCHAR(255) NOT NULL
);

ALTER TABLE Receptionist ADD CONSTRAINT CHECK_RECEPT_JOINED CHECK(ReceptionistBirthdate < DateJoined);

CREATE TABLE Doctor (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL CHECK (Gender IN(0, 1)),
    DoctorBirthdate DATE NOT NULL,
    DateJoined DATE NOT NULL,
    Specialization VARCHAR(255) NOT NULL,
    Department VARCHAR(255) NOT NULL,
    DoctorPhone VARCHAR(20) NOT NULL CHECK(DoctorPhone LIKE('0%')),
    DoctorEmail VARCHAR(255) NOT NULL UNIQUE,
	AccPassword VARCHAR(255) NOT NULL,
    RoleId VARCHAR(2) NOT NULL DEFAULT 'R2'
);

ALTER TABLE Doctor ADD CONSTRAINT CHECK_DR_JOINED CHECK(DoctorBirthdate < DateJoined);

CREATE TABLE Appointment (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY AUTO_INCREMENT,
    ConsultationTime DATETIME NOT NULL,
    Symptom VARCHAR(255) NOT NULL,
	PatientID INT NOT NULL,
    ReceptionistID INT,
    DoctorID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID),
    FOREIGN KEY (ReceptionistID) REFERENCES Receptionist (ReceptionistID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor (DoctorID)
);

ALTER TABLE Appointment ADD CONSTRAINT CHECK_APPOINTMENT_TIME CHECK(TIME(ConsultationTime) BETWEEN '07:00:00' AND '15:30:00');

CREATE TABLE Consultation (
    ConsultationID INT AUTO_INCREMENT PRIMARY KEY,
    Conclusion VARCHAR(255),
    StartTime DATETIME NOT NULL,
    EndTime DATETIME,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor (DoctorID)
);

ALTER TABLE Consultation ADD CONSTRAINT CHECK_CONSULT_ENDTIME CHECK(EndTime > StartTime);

CREATE TABLE LaboratoryPhysician (
    LabPhysID INT AUTO_INCREMENT PRIMARY KEY,
    LabPhysName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL CHECK (Gender IN(0, 1)),
    LabPhysBirthdate DATE NOT NULL,
    DateJoined DATE NOT NULL,
    Specialization VARCHAR(255) NOT NULL,
    LabPhysPhone VARCHAR(20) NOT NULL,
    LabPhysEmail VARCHAR(255) NOT NULL UNIQUE,
	AccPassword VARCHAR(255) NOT NULL
);

ALTER TABLE LaboratoryPhysician ADD CONSTRAINT CHECK_LP_JOINED CHECK(LabPhysBirthdate < DateJoined);

CREATE TABLE MedicalTest (
    TestID INT AUTO_INCREMENT PRIMARY KEY,
    TestName VARCHAR(255) NOT NULL,
    Result VARCHAR(255) NOT NULL,
    TestTime DATETIME NOT NULL,
    TestFee FLOAT NOT NULL,
    ConsultationID INT NOT NULL,
    LabPhysID INT NOT NULL,
    FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
    FOREIGN KEY (LabPhysID) REFERENCES LaboratoryPhysician (LabPhysID)
);

CREATE TABLE MedicineManufacturer (
	ManufID INT AUTO_INCREMENT PRIMARY KEY,
	ManufName VARCHAR(255) NOT NULL
);

CREATE TABLE Medicine (
    MedID INT AUTO_INCREMENT PRIMARY KEY,
    MedName VARCHAR(255) NOT NULL,
    MedDesc VARCHAR(255) NOT NULL,
    Unit VARCHAR(50) NOT NULL,
    PurchasePrice FLOAT NOT NULL,
    Price FLOAT NOT NULL,
    Quantity INT NOT NULL,
	ManufID INT NOT NULL,
	FOREIGN KEY (ManufID) REFERENCES MedicineManufacturer (ManufID)
);

CREATE TABLE Consultation_Medicine (
	ConsultationID INT NOT NULL,
	MedID INT NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY (ConsultationID, MedID),
	FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
	FOREIGN KEY (MedID) REFERENCES Medicine (MedID)
);

CREATE TABLE Diagnosis (
    DiagnosisID INT AUTO_INCREMENT PRIMARY KEY,
    DiagnosisName VARCHAR(255) NOT NULL,
    DiagnosisDesc VARCHAR(255) NOT NULL,
    Severity VARCHAR(50) NOT NULL
);

CREATE TABLE Consultation_Diagnosis (
	DiagnosisID INT NOT NULL,
	ConsultationID INT NOT NULL,
	PRIMARY KEY (DiagnosisID, ConsultationID),
	FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
	FOREIGN KEY (DiagnosisID) REFERENCES Diagnosis (DiagnosisID)
);

CREATE TABLE Bill (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
	BillType INT NOT NULL,
    BillDate DATE NOT NULL,
    PreTotal FLOAT NOT NULL,
    Total FLOAT NOT NULL,
	ConsultationID INT NOT NULL,
	InsuranceID VARCHAR(20),
	FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
	FOREIGN KEY (InsuranceID) REFERENCES InsuranceDetail (InsuranceID)
);

ALTER TABLE Bill MODIFY PreTotal FLOAT DEFAULT 0 NULL;
ALTER TABLE Bill MODIFY Total FLOAT DEFAULT 0 NULL;

