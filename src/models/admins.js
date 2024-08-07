'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Admin extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
        // define association here
        
    }
  };
  
  Admin.init({
    AdminID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    CitizenID: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },
    AdminName: {
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
    AdminBirthdate: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    AdminPhone: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        is: ['^0'] // Bắt đầu bằng số 0
      }
    },
    AdminEmail: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true // Kiểm tra định dạng email
      }
    },
    AdminAddr: {
      type: DataTypes.STRING,
      allowNull: false
    },
    AccPassword: {
      type: DataTypes.STRING,
      allowNull: false
    },
    RoleId: {
      type: DataTypes.STRING,
      allowNull: false
    }
  }, {
    sequelize,
    modelName: 'Admin',
    tableName: 'Admin',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });
    return Admin;
};