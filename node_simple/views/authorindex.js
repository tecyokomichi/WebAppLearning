var connection = require('../mysqlconnection');
//var connection = dbconnection.returnConnection();

window.onload = function(){
  connection.connect();
  connection.query('SELECT * from authors;', (err, rows, fields) => {
    if (err) throw err;
    console.log('The solution is: ', rows);
    alert('authors: ', rows.length);
  });
}
