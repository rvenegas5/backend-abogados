require("dotenv").config();
const express = require("express");
const app = express();
const PORT = process.env.PORT;

// Database
const db = require("./models");

db.sequelize.sync().then(() => {
  app.listen(PORT, () => {
    console.log(`Servidor ejecutandose en el puerto ${PORT}`);
  });
});
