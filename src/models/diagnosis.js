'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Diagnosis extends Model {
    static associate(models) {
      // define association here
      Diagnosis.belongsToMany(models.Consultation, { through: models.ConsultationDiagnosis, foreignKey: 'DiagnosisID' });

    }
  };
  
  Diagnosis.init({
    DiagnosisID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    DiagnosisName: {
      type: DataTypes.STRING,
      allowNull: false
    },
    DiagnosisDesc: {
      type: DataTypes.STRING,
      allowNull: false
    },
    Severity: {
      type: DataTypes.STRING,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Diagnosis',
    tableName: 'Diagnosis',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return Diagnosis;
};
