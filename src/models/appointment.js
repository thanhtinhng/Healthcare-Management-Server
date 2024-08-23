'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Appointment extends Model {
    static associate(models) {
      // define association here
      Appointment.belongsTo(models.Patient, { foreignKey: 'PatientID' });
      Appointment.belongsTo(models.Receptionist, { foreignKey: 'ReceptionistID' });
      Appointment.belongsTo(models.Doctor, { foreignKey: 'DoctorID' });
    }
  };
  
  Appointment.init({
    AppointmentID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    ConsultationTime: {
      type: DataTypes.STRING,
      allowNull: false,
      // validate: {
      //   isConsultationTimeValid(value) {
      //     const time = value.toLocaleTimeString('en-US', { hour12: false });
      //     if (time < '07:00:00' || time > '15:30:00') {
      //       throw new Error('Consultation time must be between 07:00:00 and 15:30:00');
      //     }
      //   }
      // }
    },
    Symptom: {
      type: DataTypes.STRING,
      allowNull: true
    },
    PatientID: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    ReceptionistID: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    DoctorID: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
  }, {
    sequelize,
    modelName: 'Appointment',
    tableName: 'Appointment',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return Appointment;
};
