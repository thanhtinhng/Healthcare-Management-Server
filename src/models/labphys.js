'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class LaboratoryPhysician extends Model {
    static associate(models) {
      // define association here
      LaboratoryPhysician.hasMany(models.MedicalTest, { foreignKey: 'LabPhysID' });
    }
  };
  
  LaboratoryPhysician.init({
    LabPhysID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    LabPhysName: {
      type: DataTypes.STRING,
      allowNull: false
    },
    Gender: {
      type: DataTypes.INTEGER,
      allowNull: false,
      validate: {
        isIn: [[0, 1]] // Giá trị phải là 0 hoặc 1
      }
    },
    LabPhysBirthdate: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    DateJoined: {
      type: DataTypes.DATEONLY,
      allowNull: false,
      validate: {
        customValidator(value) {
          if (this.LabPhysBirthdate >= value) {
            throw new Error('DateJoined must be after LabPhysBirthdate');
          }
        }
      }
    },
    Specialization: {
      type: DataTypes.STRING,
      allowNull: false
    },
    LabPhysPhone: {
      type: DataTypes.STRING,
      allowNull: false
    },
    LabPhysEmail: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true // Kiểm tra định dạng email
      }
    },
    AccPassword: {
      type: DataTypes.STRING,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'LaboratoryPhysician',
    tableName: 'LaboratoryPhysician',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return LaboratoryPhysician;
};
