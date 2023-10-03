## Verzel App e Servidor NodeJS
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
Abra um terminal e acesse o PostgreSQL usando o utilitário psql ou outra ferramenta de administração de banco de dados.

psql -U seu_usuario -d seu_banco_de_dados
Substitua seu_usuario pelo nome de usuário PostgreSQL e seu_banco_de_dados pelo nome do banco de dados que você deseja usar para o projeto.

Crie as tabelas e estruturas de banco de dados necessárias para o projeto. Isso pode ser feito executando scripts SQL da pasta script_banco.

## Configuração do Projeto Node.js
Clone o repositório do projeto para o seu sistema local.

## Acesse o diretório do projeto.
cd seu-repo
Instale as dependências do Node.js. Isso instalará todas as bibliotecas necessárias definidas no arquivo package.json.

npm install
Configure as informações de conexão com o banco de dados no seu projeto. No arquivo server.js na linha 12, altere usuário, senha e porta
## const db = pgp('postgres://usuario:senha@localhost:porta/verzel');

Execute o projeto Node.js.

## npm start ou node server.js
Isso iniciará o servidor Node.js e estabelecerá uma conexão com o banco de dados PostgreSQL.


# Sobre o Aplicativo
## Versão do Flutter: Flutter 3.10.0 
