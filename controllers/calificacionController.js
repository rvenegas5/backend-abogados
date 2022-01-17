const _ = require("lodash");
const db = require("../models/index");
/**
 * Funcion para obtener la informacion de los calificaciones de un abogado
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.getEstrellas = async (req, res) => {
  try {

   
    let Stars =  db.calificacion.findAll({
        where: {
            id_abogado: req.params.id
          }
      
    });

    if (_.isEmpty(Stars)) {
        Stars = [];
    }
    const response = {
      result: Stars,
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
