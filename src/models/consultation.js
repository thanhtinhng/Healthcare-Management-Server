'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Consultation extends Model {
    static associate(models) {
      // define association here
      Consultation.belongsTo(models.Patient, { foreignKey: 'PatientID' });
      Consultation.belongsTo(models.Doctor, { foreignKey: 'DoctorID' });
      Consultation.hasMany(models.MedicalTest, { foreignKey: 'ConsultationID' });
      Consultation.belongsToMany(models.Medicine, { through: models.ConsultationMedicine, foreignKey: 'ConsultationID' })
      Consultation.belongsToMany(models.Diagnosis, { through: models.ConsultationDiagnosis, foreignKey: 'ConsultationID' })
      Consultation.hasMany(models.Bill, { foreignKey: 'ConsultationID' });
    }
  };
  
  Consultation.init({
    ConsultationID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    Conclusion: {
      type: DataTypes.STRING,
      allowNull: true
    },
    StartTime: {
      type: DataTypes.DATE,
      allowNull: false
    },
    EndTime: {
      type: DataTypes.DATE,
      allowNull: true,
      validate: {
        endTimeAfterStartTime(value) {
          if (value && value <= this.StartTime) {
            throw new Error('EndTime must be after StartTime');
          }
        }
      }
    },
    PatientID: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    DoctorID: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Consultation',
    tableName: 'Consultation',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return Consultation;
};
