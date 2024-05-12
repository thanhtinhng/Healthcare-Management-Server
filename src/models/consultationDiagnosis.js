'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class ConsultationDiagnosis extends Model {
    static associate(models) {
      // define association here
    }
  };
  
  ConsultationDiagnosis.init({
    DiagnosisID: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    ConsultationID: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    }
  }, {
    sequelize,
    modelName: 'ConsultationDiagnosis',
    tableName: 'Consultation_Diagnosis',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return ConsultationDiagnosis;
};
