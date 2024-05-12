'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class InsuranceDetail extends Model {
    static associate(models) {
      // Mỗi chi tiết bảo hiểm chỉ thuộc về một bệnh nhân
      InsuranceDetail.belongsTo(models.Patient, { foreignKey: 'PatientID' });
      InsuranceDetail.hasMany(models.Bill, { foreignKey: 'InsuranceID' });
    }
  };
  
  InsuranceDetail.init({
    InsuranceID: {
      type: DataTypes.STRING,
      primaryKey: true
    },
    DiscountPercent: {
      type: DataTypes.DECIMAL(5, 2),
      allowNull: false
    },
    EndDate: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    PatientID: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'Patient',
        key: 'PatientID'
      }
    }
  }, {
    sequelize,
    modelName: 'InsuranceDetail',
    tableName: 'InsuranceDetail',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return InsuranceDetail;
};
