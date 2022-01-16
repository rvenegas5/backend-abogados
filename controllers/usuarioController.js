const _ = require("lodash");
const db = require("../models/index");
/**
 * Funcion para obtener la informacion de los usuarios: Cliente, Abogado
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.getInfo = async (req, res) => {
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
