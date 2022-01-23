const express = require("express");

const { AsyncWrapper } = require("../helpers");

// Controladores
const abogadoController = require("../controllers/abogadoController");
// Middlewares

const router = express.Router();

// router.get("/:id", passport, AsyncWrapper(usuarioController.getInfo));

router.get("/:id", AsyncWrapper(abogadoController.getAbogadobyid));


module.exports = router;