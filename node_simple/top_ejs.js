var http = require('http');
var url = require('url');
var fs = require('fs');
var ejs = require('ejs');
var connection = require('./mysqlconnection.js', 'utf8');
var server = http.createServer();
server.on('request', doRequest);
server.listen(3939);
console.log('Server running!');

function doRequest(req, res) {
  var uri = url.parse(req.url).pathname;
  if(uri == "/"){
    var top = fs.readFileSync('./views/top.html', 'utf8');
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(top);
    res.end();
  }else if(uri == "/authorindex"){
    var authorindex = fs.readFileSync('./views/authorindex.ejs', 'utf8');
    connection.query('SELECT * from authors;', (err, rows, fields) => {
      if (err) throw err;
      console.log('The solution is: ', rows);
      var authorindexejs = ejs.render(authorindex, {
        title:"作者一覧",
        mysqlconnection:connection,
        authors:rows
      });
      res.writeHead(200, {'Content-Type': 'text/html'});
      res.write(authorindexejs);
      res.end();
    });
  }else if(uri == "/authorshow"){
    console.log(req.method);
  }else if(uri == "/authoredit"){
    console.log(req.method);
    if(req.method == "POST"){
      var authoreditbody = '';
      req.on('data', function(chunk) {
        authoreditbody += chunk;
      });
      req.on('end', function() {
        console.log(authoreditbody);
        var authoredit = fs.readFileSync('./views/authoredit.ejs', 'utf8');
        connection.query('SELECT * FROM authors WHERE ' + authoreditbody + ';', (err, rows, fields) => {
          if (err) throw err;
          console.log(rows.length);
          var authoreditejs = ejs.render(authoredit, {
            title:"作者編集",
            mysqlconnection:connection,
            authors:rows
          });
          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(authoreditejs);
          res.end();
        });
      });
    }
  }else if(uri == "/authorupdate"){

  }else if(uri == "/authordelete"){
    console.log(req.method);
    if(req.method == "POST"){
      var authordeletebody = '';
      req.on('data', function(chunk) {
        authordeletebody += chunk;
      });
      req.on('end', function() {
        console.log(authordeletebody);
        var authordelete = fs.readFileSync('./views/authordelete.ejs', 'utf8');
        connection.query('DELETE FROM authors WHERE ' + authordeletebody + ';', (err, rows, fields) => {
          if (err) throw err;
          console.log(rows.length);
          var authordeleteejs = ejs.render(authordelete, {
            title:"作者データ削除"
          });

          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(authordeleteejs);
          res.end();
        });
      });
    }
  }else if(uri == "/bookindex"){
    var bookindex = fs.readFileSync('./views/bookindex.ejs', 'utf8');
    connection.query('SELECT * from books;', (err, rows, fields) => {
      if (err) throw err;
      var bookindexejs = ejs.render(bookindex, {
        title:"書籍一覧",
        mysqlconnection:connection,
        books:rows
      });
      res.writeHead(200, {'Content-Type': 'text/html'});
      res.write(bookindexejs);
      res.end();
    });
  }else if(uri == "/bookedit"){
    console.log(req.method);
    if(req.method == "POST"){
      var bookeditbody = '';
      req.on('data', function(chunk) {
        bookeditbody += chunk;
      });
      req.on('end', function() {
        console.log(bookeditbody);
        var bookedit = fs.readFileSync('./views/bookedit.ejs', 'utf8');
        connection.query('SELECT * FROM books WHERE ' + bookeditbody + ';', (err, rows, fields) => {
          if (err) throw err;
          console.log(rows.length);
          var bookeditjs = ejs.render(bookedit, {
            title:"書籍編集",
            mysqlconnection:connection,
            books:rows
          });
          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(bookeditjs);
          res.end();
        });
      });
    }
  }else if(uri == "/bookdelete"){
    console.log(req.method);
    if(req.method == "POST"){
      var bookdeletebody = '';
      req.on('data', function(chunk) {
        bookdeletebody += chunk;
      });
      req.on('end', function() {
        console.log(bookdeletebody);
        var bookdelete = fs.readFileSync('./views/bookdelete.ejs', 'utf8');
        connection.query('DELETE FROM books WHERE ' + bookdeletebody + ';', (err, rows, fields) => {
          if (err) throw err;
          console.log(rows.length);
          var bookdeleteejs = ejs.render(bookdelete, {
            title:"書籍データ削除"
          });

          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(bookdeleteejs);
          res.end();
        });
      });
    }
  }else if(uri == "/style.css"){
    var style = fs.readFileSync('./style.css', 'utf8');
    res.writeHead(200, {'Content-Type': 'text/css'});
    res.write(style);
    res.end();
  }
}

