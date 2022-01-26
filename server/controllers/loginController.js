const _ = require("lodash");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const { validateRequest } = require("../helpers");

const db = require("../models/index");

/**
 * Funcion encargada del inicio de sesion de todos los usuarios: Cliente, Abogado
 * . Retorna un token que se utilizara en la llamada de todos los endpoints
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.login = async (req, res) => {
  await validateRequest(req);
  try {
    const { email, password } = req.body;
    const unAuthorizedResponse = "Credenciales incorrectas.";

    const User = await db.usuario.findOne({
      where: {
        email,
      },
      attributes: { exclude: ["password"] },
    });

    // User does not exists
    if (!User) {
      return res.status(401).send(unAuthorizedResponse);
    }

    // Get user password
    const Password = await db.usuario.findOne({
      where: {
        id: User.id,
      },
    });

    // Verify password
    if (!bcrypt.compareSync(password, Password.password)) {
      return res.status(401).send(unAuthorizedResponse);
    }

    // Make JWT
    const expiresIn = 28800;
    const user = User.get({ plain: true });
    const token = jwt.sign(user, "secret", {
      expiresIn,
    });

    const result = {
      id: User.id,
      role: User.role,
      cedula: User.cedula,
      nombres: User.nombres,
      apellidos: User.apellidos,
      telefono: User.telefono,
      email: User.email,
      usuario: User.usuario,
      direccion: User.direccion,
      createdAt: User.createdAt,
      updatedAt: User.updatedAt,
      token,
    };

    return res.send({
      result,
      expiresIn,
      tokenType: "Bearer",
    });
  } catch (error) {
    console.log("ERROR", error);
    const responseError = {
      message: "Something bad happened!",
      error: error.stack,
    };
    return res.status(500).send(JSON.stringify(responseError));
  }
};

/**
 * Funcion para registrar usuarios de tipo: Cliente y Abogado, retorna
 * un token que se utilizara para llamada de los diferentes endpoints
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.register = async (req, res) => {
  await validateRequest(req);
  try {
    const {
      cedula,
      nombres,
      apellidos,
      telefono,
      email,
      usuario,
      direccion,
      password,
      role,
    } = req.body;

    const unAuthorizedResponse =
      "Ya existe un usuario registrado con ese correo.";

    let User = await db.usuario.findOne({
      where: {
        email,
      },
    });

    // Usuario existe
    if (User) {
      return res.status(401).send(unAuthorizedResponse);
    }

    const saltRounds = 10;
    const salt = bcrypt.genSaltSync(saltRounds);
    const hash = bcrypt.hashSync(password, salt);

    // Registrar Cliente o Abogado
    User = await db.usuario.create({
      cedula,
      nombres,
      apellidos,
      telefono,
      email,
      usuario,
      direccion,
      role,
      password: hash,
    });

    const user = {
      id: User.id,
      role: User.role,
    };

    // Make JWT
    const expiresIn = 28800;
    const token = jwt.sign(user, "secret", {
      expiresIn,
    });

    const result = {
      id: User.id,
      role: User.role,
      cedula: User.cedula,
      nombres: User.nombres,
      apellidos: User.apellidos,
      telefono: User.telefono,
      direccion: User.direccion,
      email: User.email,
      createdAt: User.createdAt,
      updatedAt: User.updatedAt,
      token,
    };

    return res.send({
      result,
      expiresIn,
      tokenType: "Bearer",
    });
  } catch (error) {
    console.log("ERROR", error);
    const responseError = {
      message: "Something bad happened!",
      error: error.stack,
    };
    return res.status(500).send(JSON.stringify(responseError));
  }
};
