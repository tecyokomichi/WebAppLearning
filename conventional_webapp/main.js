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
        authors:rows
      });
      res.writeHead(200, {'Content-Type': 'text/html'});
      res.write(authorindexejs);
      res.end();
    });
  }else if(uri == "/authornew"){
    var authornew = fs.readFileSync('./views/authornew.ejs', 'utf8');
    var authornewejs = ejs.render(authornew, {
      title:"作者新規"
    });
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(authornewejs);
    res.end();
  }else if(uri == "/authoredit"){
    if(req.method == "POST"){
      var authoreditbody = '';
      req.on('data', function(chunk) {
        authoreditbody += chunk;
      });
      req.on('end', function() {
        var authoredit = fs.readFileSync('./views/authoredit.ejs', 'utf8');
        connection.query('SELECT * FROM authors WHERE ' + authoreditbody + ';', (err, rows, fields) => {
          if (err) throw err;
          var authoreditejs = ejs.render(authoredit, {
            title:"作者編集",
            authors:rows
          });
          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(authoreditejs);
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
        books:rows
      });
      res.writeHead(200, {'Content-Type': 'text/html'});
      res.write(bookindexejs);
      res.end();
    });
  }else if(uri == "/booknew"){
    var booknew = fs.readFileSync('./views/booknew.ejs', 'utf8');
    var booknewejs = ejs.render(booknew, {
      title:"書籍新規"
    });
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(booknewejs);
    res.end();
  }else if(uri == "/bookedit"){
    if(req.method == "POST"){
      var bookeditbody = '';
      req.on('data', function(chunk) {
        bookeditbody += chunk;
      });
      req.on('end', function() {
        var bookedit = fs.readFileSync('./views/bookedit.ejs', 'utf8');
        connection.query('SELECT * FROM books WHERE ' + bookeditbody + ';', (err, rows, fields) => {
          if (err) throw err;
          var bookeditjs = ejs.render(bookedit, {
            title:"書籍編集",
            books:rows
          });
          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(bookeditjs);
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
