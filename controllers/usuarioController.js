const _ = require("lodash");
const db = require("../models/index");
const { QueryTypes } = require("sequelize");
/**
 * Funcion para obtener la informacion de los usuarios: Cliente, Abogado
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.getAbogado = async (req, res) => {
  try {
    const { id } = req.params;
    let UserInfo = await db.usuario.findOne({
      where: { id },
      attributes: { exclude: ["password"] },
    });

    if (_.isEmpty(UserInfo)) {
      UserInfo = [];
    }
    const response = {
      result: UserInfo,
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
exports.getAllAbogados = async (req, res) => {
  try {
    let responseBody = await db.sequelize.query(
      "select * from abogado inner join usuario on usuario.id = abogado.id_usuario",
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
