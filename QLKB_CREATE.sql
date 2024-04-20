CREATE DATABASE QLKB

USE QLKB 

CREATE TABLE Patient (
    PatientID INT IDENTITY(1,1) PRIMARY KEY,
    CitizenID VARCHAR(20) NOT NULL,
    PatientName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL,
    PatientBirthdate DATE NOT NULL,
    PatientPhone VARCHAR(20) NOT NULL, 
    PatientEmail VARCHAR(255) NOT NULL,
    PatientAddr VARCHAR(255),
    EmergencyContact VARCHAR(255),
	AccPassword VARCHAR(255) NOT NULL
)

CREATE TABLE InsuranceDetail (
    InsuranceID INT PRIMARY KEY,
    DiscountPercent DECIMAL(5,2) NOT NULL,
    EndDate DATE NOT NULL,
    PatientID INT,
    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID)
)

CREATE TABLE Receptionist (
    ReceptionistID INT IDENTITY(1,1) PRIMARY KEY,
    ReceptionistName VARCHAR(255) NOT NULL,
    Gender INT NOT NULL,
    ReceptionistBirthdate DATE NOT NULL,
    DateJoined DATE NOT NULL,
    ReceptionistPhone VARCHAR(20) NOT NULL,
    ReceptionistEmail VARCHAR(255) NOT NULL,
	AccPassword VARCHAR(255) NOT NULL
)

CREATE TABLE Doctor (
    DoctorID INT IDENTITY(1,1) PRIMARY KEY,
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
    AppointmentID INT IDENTITY(1,1) PRIMARY KEY,
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
    ConsultationID INT IDENTITY(1,1) PRIMARY KEY,
    Conclusion VARCHAR(255),
    StartTime SMALLDATETIME NOT NULL,
    EndTime SMALLDATETIME,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    FOREIGN KEY (PatientID) REFERENCES Patient (PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctor (DoctorID)
)

CREATE TABLE LaboratoryPhysician (
    LabPhysID INT IDENTITY(1,1) PRIMARY KEY,
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
    TestID INT IDENTITY(1,1) PRIMARY KEY,
    TestName VARCHAR(255) NOT NULL,
    Result VARCHAR(255) NOT NULL,
    TestTime DATETIME NOT NULL,
    TestFee MONEY NOT NULL,
    ConsultationID INT,
    LabPhysID INT,
    FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
    FOREIGN KEY (LabPhysID) REFERENCES LaboratoryPhysician (LabPhysID)
)

CREATE TABLE MedicineManufaturer (
	ManufID INT IDENTITY(1,1) PRIMARY KEY,
	ManufName VARCHAR(255) NOT NULL
)

CREATE TABLE Medicine (
    MedID INT IDENTITY(1,1) PRIMARY KEY,
    MedName VARCHAR(255) NOT NULL,
    MedDesc VARCHAR(255),
    Unit VARCHAR(50) NOT NULL,
    Price MONEY NOT NULL,
    Quantity INT NOT NULL,
	ManufID INT,
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
    DiagnosisID INT IDENTITY(1,1) PRIMARY KEY,
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
    BillID INT IDENTITY(1,1) PRIMARY KEY,
	BillType INT NOT NULL,
    BillDate DATE NOT NULL,
    PreTotal MONEY NOT NULL,
    Total MONEY NOT NULL,
	ConsultationID INT NOT NULL,
	InsuranceID INT,
	FOREIGN KEY (ConsultationID) REFERENCES Consultation (ConsultationID),
	FOREIGN KEY (InsuranceID) REFERENCES InsuranceDetail (InsuranceID)
)
