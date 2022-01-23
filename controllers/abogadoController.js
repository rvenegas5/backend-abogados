const _ = require("lodash");
const db = require("../models/index");
const { QueryTypes } = require("sequelize");

/**
 * Funcion para subir la informacion de los usuarios:  Abogado
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.register = async (req, res) => {
  await validateRequest(req);
  try {
    const { id_usuario, linkedin, especializacion, bufete } = req.body;

    const unAuthorizedResponse =
      "Ya existe un abogado registrado con ese correo.";

    let User = await db.abogado.findOne({
      where: {
        linkedin,
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
    User = await db.abogado.create({
      id_usuario,
      linkedin,
      especializacion,
      bufete,
      password: hash,
    });

    const user = {
      id: User.id,
      especializacion: User.especializacion,
    };

    // Make JWT
    const expiresIn = 28800;
    const token = jwt.sign(user, "secret", {
      expiresIn,
    });

    const result = {
      id: User.id,
      id_usuario: User.id_usuario,
      linkedin: User.linkedin,
      especializacion: User.especializacion,
      bufete: User.bufete,
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
      message: "Ha ocurrido un ERROR!",
      error: error.stack,
    };
    return res.status(500).send(JSON.stringify(responseError));
  }
};

/**
 * Funcion para obtener toda la informacion de los Abogados
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.getAllAbogados = async (req, res) => {
  try {
    let responseBody = await db.sequelize.query(
      "select *, abogado.id as id_abogado from abogado inner join usuario on usuario.id = abogado.id_usuario",
      {
        type: QueryTypes.SELECT,
      }
    );
    const result = [];
    for (const abogado of responseBody) {
      result.push(abogado);
    }
    const response = {
      result,
    };

    return res.send(response);
  } catch (error) {
    console.log("ERROR", error);
    const responseError = {
      message: "Ha ocurrido un ERROR!",
      error: error.stack,
    };
    return res.status(500).send(JSON.stringify(responseError));
  }
};

/**
 * Funcion para obtener toda la informacion de los Abogados
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.getAbogado = async (req, res) => {
  try {
    const { usuario } = req.params;
    let responseBody = await db.sequelize.query(
      `select *, abogado.id as id_abogado from abogado inner join usuario on usuario.id = abogado.id_usuario where usuario.usuario = '${usuario}'`,
      {
        type: QueryTypes.SELECT,
      }
    );
    
    const response = {
      result: responseBody,
    };

    return res.send(response);
  } catch (error) {
    console.log("ERROR", error);
    const responseError = {
      message: "Ha ocurrido un ERROR!",
      error: error.stack,
    };
    return res.status(500).send(JSON.stringify(responseError));
  }
};

exports.getAbogadobyid = async (req, res) => {
  try {
    const { id } = req.params;
    let UserInfo = await db.abogado.findOne({
      where: { id }
      
    });

    if (_.isEmpty(UserInfo)) {
      UserInfo = [];
    }
    
    return res.send(UserInfo);
  } catch (error) {
    console.log("ERROR", error);
    const responseError = {
      message: "Ha ocurrido un ERROR!",
      error: error.stack,
    };
    return res.status(500).send(JSON.stringify(responseError));
  }
};
