# Verzel Car e Servidor NodeJS
Este projeto é uma aplicação desenvolvida em Flutter e Node.js que utiliza um banco de dados PostgreSQL. Ele combina a versatilidade do Flutter para criar interfaces de usuário móveis com a potência do Node.js para o backend e armazenamento de dados no PostgreSQL.

# Visão Geral
O projeto é uma aplicação multifuncional que visa fornecer uma solução completa para vendas e cadastros de carros usados. Ele oferece uma experiência de usuário atraente e responsiva graças ao Flutter, ao mesmo tempo em que permite a manipulação eficiente de dados por meio do Node.js e do PostgreSQL.

# Começando
## Configuração Local do servidor
Para configurar seu ambiente local e estabelecer uma conexão com o banco de dados PostgreSQL, siga estas etapas:

# Pré-requisitos
Antes de começar, verifique se você possui as seguintes ferramentas instaladas em seu sistema:

## Node.js: 
Certifique-se de ter o Node.js instalado em sua máquina. Você pode verificar a instalação executando o seguinte comando no terminal: node -v
Isso deve exibir a versão do Node.js, indicando que a instalação foi bem-sucedida.
### Versão: v18.16.0

# PostgreSQL: 
Você deve ter o PostgreSQL instalado e configurado em seu sistema. Certifique-se de que o servidor PostgreSQL esteja em execução.

## Configuração do Banco de Dados

Crie o banco de dados, aqui criei com nome VERZEL, as tabelas e estruturas de banco de dados necessárias para o projeto. As tabelas e estruturas de banco de dados pode ser feito executando o script SQL da pasta scripts_banco.

## Configuração do Projeto Node.js
Clone o repositório do projeto para o seu sistema local.

## Acesse o diretório do projeto.
cd seu-repo
Instale as dependências do Node.js. Isso instalará todas as bibliotecas necessárias definidas no arquivo package.json.
npm install
Configure as informações de conexão com o banco de dados no seu projeto. No arquivo server.js na linha 12, altere usuário, senha e porta
## const db = pgp('postgres://usuario:senha@localhost:porta/nome_banco');

Execute o projeto Node.js.

## npm start ou node server.js
Isso iniciará o servidor Node.js e estabelecerá uma conexão com o banco de dados PostgreSQL.

# Postman
A api poderá ser testada através do postman, existe um arquivo na pasta postman do projeto com todas as rotas mapeadas. Através da rota Usuários crie um usuário e senha conforme o body de exemplo no arquivo:
{
    "username": "usuario_login",
    "password": "senha"
}

# Sobre o Aplicativo
## Versão do Flutter: Flutter 3.10.0 
