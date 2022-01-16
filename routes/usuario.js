const express = require("express");

const { AsyncWrapper } = require("../helpers");

// Controladores
const usuarioController = require("../controllers/usuarioController");

// Middlewares

const router = express.Router();

// router.get("/:id", passport, AsyncWrapper(usuarioController.getInfo));
router.get("/:id", AsyncWrapper(usuarioController.getInfo));

module.exports = router;