'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class MedicineManufacturer extends Model {
    static associate(models) {
      // define association here
      MedicineManufacturer.hasMany(models.Medicine, { foreignKey: 'ManufID' });
    }
  };
  
  MedicineManufacturer.init({
    ManufID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    ManufName: {
      type: DataTypes.STRING,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'MedicineManufacturer',
    tableName: 'MedicineManufacturer',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return MedicineManufacturer;
};
