const { body } = require("express-validator");

/* Validaciones para Usuarios */
module.exports.login = [
  body("email")
    .exists()
    .isString()
    .withMessage("Es necesario email"),
  body("password")
    .exists()
    .isString()
    .withMessage("Es necesario contrasena"),
];
