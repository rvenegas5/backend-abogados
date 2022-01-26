const express = require("express");

const { AsyncWrapper } = require("../helpers");

// Controladores
const calificacionController = require("../controllers/calificacionController");

// Middlewares

const router = express.Router();

// router.get("/:id", passport, AsyncWrapper(usuarioController.getInfo));
router.get("/:id", AsyncWrapper(calificacionController.getEstrellas));

module.exports = router;