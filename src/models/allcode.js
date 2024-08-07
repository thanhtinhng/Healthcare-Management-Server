'use strict';
const { Model, DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  class Allcode extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
        // define association here
        
    }
  };
  
  Allcode.init({
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    type: {
        type: DataTypes.STRING,
    },
    key: {
        type: DataTypes.STRING,
    },
    value: {
        type: DataTypes.STRING,
    }
  }, {
    sequelize,
    modelName: 'Allcode',
    tableName: 'Allcode',
    timestamps: false // Không sử dụng các cột 'createdAt' và 'updatedAt'
  });
    return Allcode;
};