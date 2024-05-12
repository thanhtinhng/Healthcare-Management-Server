'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class ConsultationMedicine extends Model {
    static associate(models) {
      // define association here
    }
  };
  
  ConsultationMedicine.init({
    ConsultationID: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    MedID: {
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    Quantity: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'ConsultationMedicine',
    tableName: 'Consultation_Medicine',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return ConsultationMedicine;
};
