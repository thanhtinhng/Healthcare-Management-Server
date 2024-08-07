'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Doctor extends Model {
    static associate(models) {
        // define association here
        Doctor.hasMany(models.Appointment, { foreignKey: 'DoctorID' });
        Doctor.hasMany(models.Consultation, { foreignKey: 'DoctorID' });
    }
  };
  
  Doctor.init({
    DoctorID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    DoctorName: {
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
    DoctorBirthdate: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    DateJoined: {
      type: DataTypes.DATEONLY,
      allowNull: false,
      validate: {
        customValidator(value) {
          if (this.DoctorBirthdate >= value) {
            throw new Error('DateJoined must be after DoctorBirthdate');
          }
        }
      }
    },
    Specialization: {
      type: DataTypes.STRING,
      allowNull: false
    },
    Department: {
      type: DataTypes.STRING,
      allowNull: false
    },
    DoctorPhone: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        is: ['^0'] // Bắt đầu bằng số 0
      }
    },
    DoctorEmail: {
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
    },
    RoleId: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: 'R2'
    }
  }, {
    sequelize,
    modelName: 'Doctor',
    tableName: 'Doctor',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });

  return Doctor;
};
