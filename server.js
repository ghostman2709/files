// Arquivo server.js
const { createServer } = require("http");

const server = createServer((req, res) => {
  console.log("Requisição recebida");
  res.setHeader("Content-Type", "text/html");
  res.writeHead(200);
  res.end("<h1>Hello Erico mrx</h1>");
});

server.listen(8080, "localhost", () => {
  console.log(`Erico seu Servidor rodando na porta 8080!`);
});
