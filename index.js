require("dotenv").config();
const cors = require("cors");
const express = require("express");
const app = express();
const PORT = process.env.PORT;

// Database
const db = require("./models");
app.use(cors());
app.use(express.json());

app.use("/auth", require("./routes/auth"));
app.use("/usuario", require("./routes/usuario"));

db.sequelize.sync().then(() => {
  app.listen(PORT, () => {
    console.log(`Servidor ejecutandose en el puerto ${PORT}`);
  });
});
