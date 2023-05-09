const express = require("express");
const os = require("os");

const PORT = 3000;

const app = express()
  .get("/", (req, res) => {
    const hostname = os.hostname;
    const ip = req.headers["x-forwarded-for"] || req.connection.remoteAddress;
    const version = process.env.VERSION || "unknown";

    res.write(`Hostname: ${hostname}\n`);
    res.write(`Server address: ${ip}\n`);
    res.write(`Version: ${version}\n`);
  })

  .listen(PORT, () => {
    console.log(`listening on port ${PORT}`);
  });
