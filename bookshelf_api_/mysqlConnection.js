var mysql = require('mysql');

var dbConfig = {
  host: 'localhost',
  user: 'root',
  password: 'pikaichi',
  database: 'bookshelf_development'
};

var connection = mysql.createConnection(dbConfig);
