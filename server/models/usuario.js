const Sequelize = require('sequelize');
module.exports = function(sequelize, DataTypes) {
  return sequelize.define('usuario', {
    id: {
      autoIncrement: true,
      type: DataTypes.INTEGER,
      allowNull: false,
      primaryKey: true
    },
    cedula: {
      type: DataTypes.STRING(10),
      allowNull: false
    },
    nombres: {
      type: DataTypes.STRING(191),
      allowNull: false
    },
    apellidos: {
      type: DataTypes.STRING(191),
      allowNull: false
    },
    telefono: {
      type: DataTypes.STRING(191),
      allowNull: false
    },
    direccion: {
      type: DataTypes.STRING(191),
      allowNull: false
    },
    email: {
      type: DataTypes.STRING(191),
      allowNull: false
    },
    usuario: {
      type: DataTypes.STRING(191),
      allowNull: false
    },
    password: {
      type: DataTypes.STRING(191),
      allowNull: false
    },
    role: {
      type: DataTypes.INTEGER,
      allowNull: false
    }
  }, {
    sequelize,
    tableName: 'usuario',
    timestamps: true,
    indexes: [
      {
        name: "PRIMARY",
        unique: true,
        using: "BTREE",
        fields: [
          { name: "id" },
        ]
      },
    ]
  });
};
