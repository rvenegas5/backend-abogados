const _ = require("lodash");
const db = require("../models/index");
/**
 * Funcion para subir la informacion de los usuarios:  Abogado
 * @param  {*} req
 * @param  {*} res
 * @return {Object} response
 */
exports.register = async (req, res) => {
  await validateRequest(req);
  try {
    const {
        id_usuario,
        linkedin,
        especializacion,
        bufete,
      } = req.body;
  
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

