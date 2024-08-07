'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Patient extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
        // define association here
        Patient.hasOne(models.InsuranceDetail, { foreignKey: 'PatientID' });
        Patient.hasMany(models.Appointment, { foreignKey: 'PatientID' });
        Patient.hasMany(models.Consultation, { foreignKey: 'PatientID' });
    }
  };
  
  Patient.init({
    PatientID: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    CitizenID: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true
    },
    PatientName: {
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
    PatientBirthdate: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    PatientPhone: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        is: ['^0'] // Bắt đầu bằng số 0
      }
    },
    PatientEmail: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
      validate: {
        isEmail: true // Kiểm tra định dạng email
      }
    },
    PatientAddr: {
      type: DataTypes.STRING,
      allowNull: false
    },
    EmergencyContact: {
      type: DataTypes.STRING
    },
    AccPassword: {
      type: DataTypes.STRING,
      allowNull: false
    },
    RoleId: {
      type: DataTypes.STRING,
      allowNull: false,
      defaultValue: 'R3'
    }
  }, {
    sequelize,
    modelName: 'Patient',
    tableName: 'Patient',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });
    return Patient;
};

//   Patient.init({
//     PatientID: {
//       type: DataTypes.INTEGER,
//       primaryKey: true,
//       autoIncrement: true
//     },
//     CitizenID: {
//       type: DataTypes.STRING,
//       allowNull: true,
//       unique: true
//     },
//     PatientName: {
//       type: DataTypes.STRING,
//       allowNull: true
//     },
//     Gender: {
//       type: DataTypes.INTEGER,
//       allowNull: true,
//       validate: {
//         isIn: [[0, 1]] // Giá trị phải là 0 hoặc 1
//       }
//     },
//     PatientBirthdate: {
//       type: DataTypes.DATEONLY,
//       allowNull: true
//     },
//     PatientPhone: {
//       type: DataTypes.STRING,
//       allowNull: true,
//       validate: {
//         is: ['^0'] // Bắt đầu bằng số 0
//       }
//     },
//     PatientEmail: {
//       type: DataTypes.STRING,
//       allowNull: true,
//       unique: false,
//       validate: {
//         isEmail: true // Kiểm tra định dạng email
//       }
//     },
//     PatientAddr: {
//       type: DataTypes.STRING,
//       allowNull: true
//     },
//     EmergencyContact: {
//       type: DataTypes.STRING
//     },
//     AccPassword: {
//       type: DataTypes.STRING,
//       allowNull: true
//     }
//   }, {
//     sequelize,
//     modelName: 'Patient',
//     tableName: 'Patient',
//     timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
//   });

//   return Patient;
// };
