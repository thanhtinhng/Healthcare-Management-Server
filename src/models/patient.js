'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Patient extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  };
Patient.init({
  PatientID: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  CitizenID: DataTypes.STRING,
  PatientName: DataTypes.STRING,
  Gender: DataTypes.INTEGER,
  PatientBirthdate: DataTypes.DATE,
  PatientPhone: DataTypes.STRING,
  PatientEmail: DataTypes.STRING,
  PatientAddr: DataTypes.STRING,
  EmergencyContact: DataTypes.STRING,
  AccPassword: DataTypes.STRING,
  }, {
    sequelize,
    modelName: 'Patient',
    tableName: 'patient',
    timestamps: false
  });
  return Patient;
};