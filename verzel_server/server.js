const bcrypt = require('bcrypt');
const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

// Criar uma única instância da conexão com o banco de dados
const pgp = require('pg-promise')();
const db = pgp('postgres://postgres:912167@localhost:5432/verzel');


// Configurar a chave secreta para o JWT
const secretKey = 'sua_chave_secreta';

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

// Rota para gravar um novo usuário e senha no banco de dados
app.post('/usuarios', async (req, res) => {
    try {
        // Recupere os dados do corpo da solicitação
        const { username, password } = req.body;

        // Verifique se o usuário já existe (opcional)
        const existingUser = await db.oneOrNone('SELECT * FROM usuarios WHERE username = $1', [username]);
        if (existingUser) {
            return res.status(400).json({ message: 'Usuário já existe' });
        }

        // Hash da senha antes de armazená-la no banco de dados
        const hashedPassword = await bcrypt.hash(password, 10); // Use o valor de salt apropriado

        // Insira os dados do novo usuário no banco de dados
        const newUser = await db.one(
            'INSERT INTO usuarios (username, password) VALUES ($1, $2) RETURNING id',
            [username, hashedPassword]
        );

        res.status(201).json({ message: 'Usuário criado com sucesso', userId: newUser.id });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao criar o usuário', error: error.message });
    }
});


// Middleware para verificar o token JWT
function verifyToken(req, res, next) {
    const token = req.headers.authorization;

    if (!token) {
        return res.status(403).json({ message: 'Token não fornecido' });
    }

    jwt.verify(token, secretKey, (err, decoded) => {
        if (err) {
            return res.status(401).json({ message: 'Token inválido' });
        }
        req.username = decoded.username;
        next();
    });
}

// Rota de testes
app.get('/', (req, res) => {
    res.json({ message: 'Rota de testes' });
});

// Rota protegida com autenticação JWT
app.get('/protected', verifyToken, (req, res) => {
    res.json({ message: 'Rota protegida', username: req.username });
});

// Rota para acessar dados paginados do banco de dados
app.get('/carros', async (req, res) => {
    try {
        const page = req.query.page || 1;
        const pageSize = req.query.pageSize || 10;
        const offset = (page - 1) * pageSize;

        // Consulta para contar o número total de registros na tabela 'carros'
        const totalCarros = await db.one('SELECT COUNT(*) FROM carros');

        // Consulta para obter os dados paginados
        const carros = await db.any('SELECT * FROM carros LIMIT $1 OFFSET $2', [pageSize, offset]);

        // Calcule o número total de páginas com base no número total de registros
        const totalPages = Math.ceil(totalCarros.count / pageSize);

        res.json({ carros, totalPages });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao acessar o banco de dados', error: error.message });
    }
});

// Rota para gravar um novo carro na tabela "carros"
app.post('/carros', verifyToken, async (req, res) => {
    try {
        // Recupere os dados do corpo da solicitação
        const { nome, marca, modelo, foto_base64, ano, cidade_brasileira, kilometragem, valor, local_imagem } = req.body;

        // Insira os dados na tabela "carros"
        const newCar = await db.one(
            'INSERT INTO carros (nome, marca, modelo, foto_base64, ano, cidade_brasileira, kilometragem, valor, local_imagem) ' +
            'VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING id',
            [nome, marca, modelo, foto_base64, ano, cidade_brasileira, kilometragem, valor, local_imagem]
        );

        res.status(201).json({ message: 'Carro inserido com sucesso', carId: newCar.id });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao inserir o carro no banco de dados', error: error.message });
    }
});

// Rota para editar um carro pelo ID
app.post('/carros/editar', verifyToken, async (req, res) => {
    try {
        // Recupere o ID do carro a ser editado e os novos dados do corpo da solicitação
        const { id, nome, marca, modelo, ano, cidade_brasileira, kilometragem, valor, local_imagem, foto_base64 } = req.body;

        // Verifique se o carro existe
        const existingCar = await db.oneOrNone('SELECT * FROM carros WHERE id = $1', [id]);
        if (!existingCar) {
            return res.status(404).json({ message: 'Carro não encontrado' });
        }

        // Atualize os dados do carro no banco de dados
        await db.none(
            'UPDATE carros SET nome = $1, marca = $2, modelo = $3, ano = $4, cidade_brasileira = $5, ' +
            'kilometragem = $6, valor = $7, local_imagem = $8, foto_base64 = $9 WHERE id = $10',
            [nome, marca, modelo, ano, cidade_brasileira, kilometragem, valor, local_imagem, foto_base64, id]
        );

        res.json({ message: 'Carro editado com sucesso' });
    } catch (error) {
        // Log de erro não tratado
        console.error('Erro não tratado ao editar o carro:', error);

        res.status(500).json({ message: 'Erro ao editar o carro', error: error.message });
    }
});


// Rota para excluir um carro pelo ID
app.post('/carros/excluir', verifyToken, async (req, res) => {
    try {
        // Recupere o ID do carro a ser excluído do corpo da solicitação
        const { id } = req.body;

        // Verifique se o carro existe
        const existingCar = await db.oneOrNone('SELECT * FROM carros WHERE id = $1', [id]);
        if (!existingCar) {
            return res.status(404).json({ message: 'Carro não encontrado' });
        }

        // Exclua o carro do banco de dados
        await db.none('DELETE FROM carros WHERE id = $1', [id]);

        res.json({ message: 'Carro excluído com sucesso' });
    } catch (error) {
        res.status(500).json({ message: 'Erro ao excluir o carro', error: error.message });
    }
});

app.listen(port, () => {
    console.log(`Servidor rodando na porta ${port}`);
});
