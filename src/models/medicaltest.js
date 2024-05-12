'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class MedicalTest extends Model {
    static associate(models) {
      // define association here
      MedicalTest.belongsTo(models.Consultation, { foreignKey: 'ConsultationID' });
      MedicalTest.belongsTo(models.LaboratoryPhysician, { foreignKey: 'LabPhysID' });
    }
  };
  
  MedicalTest.init({
    TestID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    TestName: {
      type: DataTypes.STRING,
      allowNull: false
    },
    Result: {
      type: DataTypes.STRING,
      allowNull: false
    },
    TestTime: {
      type: DataTypes.DATE,
      allowNull: false
    },
    TestFee: {
      type: DataTypes.FLOAT,
      allowNull: false
    },
    ConsultationID: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    LabPhysID: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'MedicalTest',
    tableName: 'MedicalTest',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return MedicalTest;
};
