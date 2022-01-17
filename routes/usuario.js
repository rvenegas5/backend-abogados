const express = require("express");

const { AsyncWrapper } = require("../helpers");

// Controladores
const usuarioController = require("../controllers/usuarioController");

// Middlewares

const router = express.Router();

// router.get("/:id", passport, AsyncWrapper(usuarioController.getInfo));
router.get("/:id", AsyncWrapper(usuarioController.getAbogado));

router.get("/", AsyncWrapper(usuarioController.getAllAbogados));

module.exports = router;
