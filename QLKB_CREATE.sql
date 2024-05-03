CREATE DATABASE QLKB

USE QLKB 
DROP TABLE Patient
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
	AccPassword VARCHAR(255) NOT NULL
)

CREATE TABLE InsuranceDetail (
    InsuranceID INT PRIMARY KEY,
    DiscountPercent DECIMAL(5,2) NOT NULL,
    EndDate DATE NOT NULL,
    PatientID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
)

CREATE TABLE Receptionist (
    ReceptionistID INT AUTO_INCREMENT PRIMARY KEY,
    ReceptionistName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL,
    ReceptionistBirthdate DATE NOT NULL,
    DateJoined DATE NOT NULL,
    ReceptionistPhone VARCHAR(20) NOT NULL,
    ReceptionistEmail VARCHAR(255) NOT NULL,
	AccPassword VARCHAR(255) NOT NULL
)

CREATE TABLE Doctor (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    DoctorName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL,
    DoctorBirthdate DATE NOT NULL,
    DateJoined DATE NOT NULL,
    Specialization VARCHAR(255) NOT NULL,
    Department VARCHAR(255) NOT NULL,
    DoctorPhone VARCHAR(20) NOT NULL,
    DoctorEmail VARCHAR(255) NOT NULL,
	AccPassword VARCHAR(255) NOT NULL
)

CREATE TABLE Appointment (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    ConsultationTime SMALLDATETIME NOT NULL,
    Room VARCHAR(8) NOT NULL,
    Symptom VARCHAR(255) NOT NULL,
	PatientID INT NOT NULL,
    ReceptionistID INT NOT NULL,
    DoctorID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID),
    FOREIGN KEY (ReceptionistID) REFERENCES Receptionist (ReceptionistID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor (DoctorID)
)

CREATE TABLE Consultation (
    ConsultationID INT AUTO_INCREMENT PRIMARY KEY,
    Conclusion VARCHAR(255),
    StartTime SMALLDATETIME NOT NULL,
    EndTime SMALLDATETIME,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor (DoctorID)
)

CREATE TABLE LaboratoryPhysician (
    LabPhysID INT AUTO_INCREMENT PRIMARY KEY,
    LabPhysName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL,
    LabPhysBirthdate DATE NOT NULL,
    DateJoined DATE NOT NULL,
    Specialization VARCHAR(255) NOT NULL,
    LabPhysPhone VARCHAR(20) NOT NULL,
    LabPhysEmail VARCHAR(255) NOT NULL,
	AccPassword VARCHAR(255) NOT NULL
)

CREATE TABLE MedicalTest (
    TestID INT AUTO_INCREMENT PRIMARY KEY,
    TestName VARCHAR(255) NOT NULL,
    Result VARCHAR(255) NOT NULL,
    TestTime DATETIME NOT NULL,
    TestFee MONEY NOT NULL,
    ConsultationID INT NOT NULL,
    LabPhysID INT NOT NULL,
    FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
    FOREIGN KEY (LabPhysID) REFERENCES LaboratoryPhysician (LabPhysID)
)

CREATE TABLE MedicineManufaturer (
	ManufID INT AUTO_INCREMENT PRIMARY KEY,
	ManufName VARCHAR(255) NOT NULL
)

CREATE TABLE Medicine (
    MedID INT AUTO_INCREMENT PRIMARY KEY,
    MedName VARCHAR(255) NOT NULL,
    MedDesc VARCHAR(255),
    Unit VARCHAR(50) NOT NULL,
    Price MONEY NOT NULL,
    Quantity INT NOT NULL,
	ManufID INT NOT NULL,
	FOREIGN KEY (ManufID) REFERENCES MedicineManufaturer (ManufID)
)

CREATE TABLE Consultation_Medicine (
	ConsultationID INT NOT NULL,
	MedID INT NOT NULL,
	Quantity INT NOT NULL,
	PRIMARY KEY (ConsultationID, MedID),
	FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
	FOREIGN KEY (MedID) REFERENCES Medicine (MedID)
)

CREATE TABLE Diagnosis (
    DiagnosisID INT AUTO_INCREMENT PRIMARY KEY,
    DiagnosisName VARCHAR(255) NOT NULL,
    DiagnosisDesc VARCHAR(255),
    Severity VARCHAR(50)
)

CREATE TABLE Consultation_Diagnosis (
	DiagnosisID INT NOT NULL,
	ConsultationID INT NOT NULL,
	PRIMARY KEY (DiagnosisID, ConsultationID),
	FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
	FOREIGN KEY (DiagnosisID) REFERENCES Diagnosis (DiagnosisID)
)

CREATE TABLE Bill (
    BillID INT AUTO_INCREMENT PRIMARY KEY,
	BillType INT NOT NULL,
    BillDate DATE NOT NULL,
    PreTotal MONEY NOT NULL,
    Total MONEY NOT NULL,
	ConsultationID INT NOT NULL,
	InsuranceID INT,
	FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
	FOREIGN KEY (InsuranceID) REFERENCES InsuranceDetail (InsuranceID)
)
