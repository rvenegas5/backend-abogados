module.exports = {
    MYSQL_DATABASE: process.env.MYSQL_DATABASE,
    MYSQL_USER: process.env.MYSQL_USER,
    MYSQL_ROOT_PASSWORD: process.env.MYSQL_ROOT_PASSWORD,
    MYSQL_HOSTNAME: process.env.MYSQL_HOSTNAME,
    MYSQL_ROOT_PORT: process.env.MYSQL_ROOT_PORT,
    ROL: {
      CLIENTE: {
        ROL_ID: 1,
        ROL: "CLIENTE",
      },
      ABOGADO: {
        ROL_ID: 2,
        ROL: "ABOGADO",
      },
    },
  };