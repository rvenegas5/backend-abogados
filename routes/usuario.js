const express = require("express");

const { AsyncWrapper } = require("../helpers");

// Controladores
const usuarioController = require("../controllers/usuarioController");
const abogadoController = require("../controllers/abogadoController");
// Middlewares

const router = express.Router();

// router.get("/:id", passport, AsyncWrapper(usuarioController.getInfo));
router.get("/:id", AsyncWrapper(usuarioController.getAbogado));

router.get("abogados", AsyncWrapper(abogadoController.getAllAbogados));

module.exports = router;
