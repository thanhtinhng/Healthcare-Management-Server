'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Receptionist extends Model {
    static associate(models) {
        // define association here
        Receptionist.hasMany(models.Appointment, { foreignKey: 'ReceptionistID' });
        
    }
  };
  
  Receptionist.init({
    ReceptionistID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    ReceptionistName: {
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
    ReceptionistBirthdate: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    DateJoined: {
      type: DataTypes.DATEONLY,
      allowNull: false,
      validate: {
        customValidator(value) {
          if (this.ReceptionistBirthdate >= value) {
            throw new Error('DateJoined must be after ReceptionistBirthdate');
          }
        }
      }
    },
    ReceptionistPhone: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        is: ['^0'] // Bắt đầu bằng số 0
      }
    },
    ReceptionistEmail: {
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
    modelName: 'Receptionist',
    tableName: 'Receptionist',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });
  return Receptionist;
};
