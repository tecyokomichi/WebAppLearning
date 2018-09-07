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
  }else if(uri == "/authorshow"){
    if(req.method == "POST"){
      var authorshowbody = '';
      req.on('data', function(chunk) {
        authorshowbody += chunk;
      });
      req.on('end', function() {
        now = returnDatetimeStr();
        var sql = "";
        var authorId = 0;
        prms = authorshowbody.split('&');
        var o = returnAuthorParam(prms);
        if(o.id){
          authorId = o.id;
          sql = "UPDATE authors SET name=" + "'" + o.name + "', age=" + o.age + ", updated_at=" + "'" + now + "'" + " WHERE id=" + o.id + ";"
        }else{
          sql = "INSERT INTO authors (name, age, created_at, updated_at) VALUES (" + "'" + o.name + "', " + o.age + ", '" + now + "', '" + now + "'" +  ");";
        }
        connection.query(sql, function(err, result){
          if (err) throw err;
          var authorshowindex = fs.readFileSync('./views/authorindex.ejs', 'utf8');
          if(result.insertId) authorId = result.insertId;
          var afterSql = "SELECT * FROM authors WHERE id=" + authorId + ";";
          connection.query(afterSql, (err, rows, fields) => {
            if (err) throw err;
            var authorshowindexejs = ejs.render(authorshowindex, {
              title:"作者詳細",
              authors:rows
            });
            res.writeHead(200, {'Content-Type': 'text/html'});
            res.write(authorshowindexejs);
            res.end();
          });
        });
      });
    }
  }else if(uri == "/authordelete"){
    if(req.method == "POST"){
      var authordeletebody = '';
      req.on('data', function(chunk) {
        authordeletebody += chunk;
      });
      req.on('end', function() {
        var authordelete = fs.readFileSync('./views/authordelete.ejs', 'utf8');
        connection.query('DELETE FROM authors WHERE ' + authordeletebody + ';', (err, rows, fields) => {
          if (err) throw err;
          var authordeleteejs = ejs.render(authordelete, {
            message:"作者データ削除"
          });
          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(authordeleteejs);
          res.end();
        });
      });
    }
  }else if(uri == "/bookindex"){
    var bookindex = fs.readFileSync('./views/bookindex.ejs', 'utf8');
    var bookindexejs;
    if(req.method == "POST"){
      var bookindexbody = '';
      req.on('data', function(chunk) {
        bookindexbody += chunk;
      });
      req.on('end', function() {
        connection.query('SELECT * FROM books WHERE author_' + bookindexbody + ';', (err, rows, fields) => {
          if (err) throw err;
          bookindexjs = ejs.render(bookindex, {
            title:"書籍一覧",
            books:rows
          });
          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(bookindexjs);
          res.end();
        });
      });
    }else{
      connection.query('SELECT * from books;', (err, rows, fields) => {
        if (err) throw err;
        bookindexejs = ejs.render(bookindex, {
          title:"書籍一覧",
          books:rows
        });
        res.writeHead(200, {'Content-Type': 'text/html'});
        res.write(bookindexejs);
        res.end();
      });
    }
  }else if(uri == "/booknew"){
    connection.query('SELECT * FROM authors;', (err, rows, fields) => {
      var booknew = fs.readFileSync('./views/booknew.ejs', 'utf8');
      var booknewejs = ejs.render(booknew, {
        title:"書籍新規",
        authors:rows
      });
      res.writeHead(200, {'Content-Type': 'text/html'});
      res.write(booknewejs);
      res.end();
    });
  }else if(uri == "/bookedit"){
    if(req.method == "POST"){
      connection.query('SELECT * FROM authors;', (err, rows, fields) => {
        var authors = rows;
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
              authors:authors,
              books:rows
            });
            res.writeHead(200, {'Content-Type': 'text/html'});
            res.write(bookeditjs);
            res.end();
          });
        });
      });
    }
  }else if(uri == "/bookshow"){
    if(req.method == "POST"){
      var bookshowbody = '';
      req.on('data', function(chunk) {
        bookshowbody += chunk;
      });
      req.on('end', function() {
        now = returnDatetimeStr();
        var sql = "";
        var bookId = 0;
        console.log(bookshowbody);
        prms = bookshowbody.split('&');
        console.log(prms);
        var o = returnBookParam(prms);
        if(o.id){
          bookId = o.id;
          sql = "UPDATE books SET book_kind=" + o.bookKind + ", author_id=" + o.authorId + ", title=" + "'" + o.title + "', updated_at=" + "'" + now + "'" + " WHERE id=" + o.id + ";"
        }else{
          sql = "INSERT INTO books (book_kind, author_id, title, created_at, updated_at) VALUES (" + o.bookKind + ", " + o.authorId + ", '" + o.title + "', '" + now + "', '" + now + "'" +  ");";
        }
        console.log(sql);
        connection.query(sql, function(err, result){
          if (err) throw err;
          var bookshowindex = fs.readFileSync('./views/bookindex.ejs', 'utf8');
          if(result.insertId) bookId = result.insertId;
          var afterSql = "SELECT * FROM books WHERE id=" + bookId + ";";
          connection.query(afterSql, (err, rows, fields) => {
            if (err) throw err;
            var bookshowindexejs = ejs.render(bookshowindex, {
              title:"詳細書籍",
              books:rows
            });
            res.writeHead(200, {'Content-Type': 'text/html'});
            res.write(bookshowindexejs);
            res.end();
          });
        });
      });
    }
  }else if(uri == "/bookdelete"){
    if(req.method == "POST"){
      var bookdeletebody = '';
      req.on('data', function(chunk) {
        bookdeletebody += chunk;
      });
      req.on('end', function() {
        var bookdelete = fs.readFileSync('./views/bookdelete.ejs', 'utf8');
        connection.query('DELETE FROM books WHERE ' + bookdeletebody + ';', (err, rows, fields) => {
          if (err) throw err;
          var bookdeleteejs = ejs.render(bookdelete, {
            message:"書籍データ削除"
          });
          res.writeHead(200, {'Content-Type': 'text/html'});
          res.write(bookdeleteejs);
          res.end();
        });
      });
    }
  }else if(uri == "/badrequest"){
    var badrequest = fs.readFileSync('./views/badrequest.html', 'utf8');
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(badrequest);
    res.end();
  }else if(uri == "/notfind"){
    var notfind = fs.readFileSync('./views/notfind.html', 'utf8');
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(notfind);
    res.end();
  }else if(uri == "/style.css"){
    var style = fs.readFileSync('./style.css', 'utf8');
    res.writeHead(200, {'Content-Type': 'text/css'});
    res.write(style);
    res.end();
  }
}

function returnDatetimeStr() {
  var datetime = new Date();
  var year = datetime.getFullYear().toString();
  var month = (datetime.getMonth()+1).toString();
  var date = datetime.getDate().toString();
  var hour = datetime.getHours().toString();
  var minute = datetime.getMinutes().toString();
  var second = datetime.getSeconds().toString();
  year = ('0000' + year).slice(-4);
  month = ('00' + month).slice(-2);
  date = ('00' + date).slice(-2);
  hour = ('00' + hour).slice(-2);
  minute = ('00' + minute).slice(-2);
  second = ('00' + second).slice(-2);
  return year + '-' + month + '-' + date + ' ' + hour + ':' + minute + ':' + second;
}

function returnAuthorParam(a) {
  var r = [];
  for(var i=0; i<a.length; i++){
    var prms = a[i].split('=');
    r.push(decodeURIComponent(prms[1]));
  }
  if(r.length == 3){
    return { id:r[0], name:r[1], age:r[2] };
  }else{
    return { name:r[0], age:r[1] };
  }
}

function returnBookParam(a) {
  var r = [];
  for(var i=0; i<a.length; i++){
    var prms = a[i].split('=');
    r.push(decodeURIComponent(prms[1]));
    console.log(r)
  }
  if(r.length == 4){
    return { id:r[0], bookKind:r[1], authorId:r[2], title:r[3] };
  }else{
    return { bookKind:r[0], authorId:r[1], title:r[2] };
  }
}
