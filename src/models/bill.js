'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Bill extends Model {
    static associate(models) {
      Bill.belongsTo(models.Consultation, { foreignKey: 'ConsultationID' });
      Bill.belongsTo(models.InsuranceDetail, { foreignKey: 'InsuranceID' });
    }
  };
  
  Bill.init({
    BillID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    BillType: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    BillDate: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    PreTotal: {
      type: DataTypes.FLOAT,
      defaultValue: 0,
      allowNull: false
    },
    Total: {
      type: DataTypes.FLOAT,
      defaultValue: 0,
      allowNull: false
    },
    ConsultationID: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    InsuranceID: {
      type: DataTypes.STRING,
      allowNull: true
    }
  }, {
    sequelize,
    modelName: 'Bill',
    tableName: 'Bill',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return Bill;
};
