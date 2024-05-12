'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Medicine extends Model {
    static associate(models) {
      // define association here
      Medicine.belongsTo(models.MedicineManufacturer, { foreignKey: 'ManufID' });
      Medicine.belongsToMany(models.Consultation, { through: models.ConsultationMedicine, foreignKey: 'MedID' });
    }
  };
  
  Medicine.init({
    MedID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    MedName: {
      type: DataTypes.STRING,
      allowNull: false
    },
    MedDesc: {
      type: DataTypes.STRING,
      allowNull: false
    },
    Unit: {
      type: DataTypes.STRING,
      allowNull: false
    },
    PurchasePrice: {
      type: DataTypes.FLOAT,
      allowNull: false
    },
    Price: {
      type: DataTypes.FLOAT,
      allowNull: false
    },
    Quantity: {
      type: DataTypes.INTEGER,
      allowNull: false
    },
    ManufID: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Medicine',
    tableName: 'Medicine',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return Medicine;
};
