
// Criar uma única instância da conexão com o banco de dados
const pgp = require('pg-promise')();
const db = pgp('postgres://postgres:912167@localhost:5432/verzel');


// Configurar a chave secreta para o JWT
const secretKey = 'sua_chave_secreta';
const bcrypt = require('bcrypt');

module.exports = db;
module.exports = secretKey;
module.exports = bcrypt;