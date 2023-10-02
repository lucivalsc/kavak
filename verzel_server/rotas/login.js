const db = require('./db');
const secretKey = require('./db'); 
const bcrypt = require('./db'); 
const express = require('express');
// Use o router em vez de criar uma nova instância do app
const app = express.Router();

// Rotas de autenticação
app.post('/login', async (req, res) => {
    const { username, password } = req.body;

    try {
        // Consulta para buscar o usuário com o nome de usuário especificado
        const user = await db.oneOrNone('SELECT * FROM usuarios WHERE username = $1', [username]);

        // Verifique se o usuário existe
        if (!user) {
            return res.status(401).json({ message: 'Usuário não encontrado' });
        }

        // Verifique se a senha está correta
        const passwordMatch = await bcrypt.compare(password, user.password);

        if (passwordMatch) {
            // Gere um token JWT
            const token = jwt.sign({ username }, secretKey, { expiresIn: '1h' });
            res.json({ token });
        } else {
            res.status(401).json({ message: 'Credenciais inválidas' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Erro ao autenticar usuário', error: error.message });
    }
});

module.exports = app;