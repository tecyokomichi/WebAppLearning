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
    doRes(fs.readFileSync('./views/top.html', 'utf8'), res, 200, {'Content-Type': 'text/html'});
  }else if(uri == "/authorindex"){
    connection.query('SELECT * from authors;', (err, rows, fields) => {
      if (err) throw err;
      var authorindex = ejs.render(fs.readFileSync('./views/authorindex.ejs', 'utf8'), {
        title:"作者一覧",
        authors:rows
      });
      doRes(authorindex, res, 200, {'Content-Type': 'text/html'});
    });
  }else if(uri == "/authornew"){
    var authornew = ejs.render(fs.readFileSync('./views/authornew.ejs', 'utf8'), {
      title:"作者新規"
    });
    doRes(authornew, res, 200, {'Content-Type': 'text/html'});
  }else if(uri == "/authoredit"){
    if(req.method == "POST"){
      var authoreditbody = '';
      req.on('data', function(chunk) {
        authoreditbody += chunk;
      });
      req.on('end', function() {
        doEdit(fs.readFileSync('./views/authoredit.ejs', 'utf8'), res, 'SELECT *  FROM authors WHERE ' + authoreditbody + ';', { 'Content-Type': 'text/html' });
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
        var authorsql = "";
        var authorId = 0;
        prms = authorshowbody.split('&');
        var authoro = returnAuthorParam(prms);
        var errors = prmCheckAuthor(authoro);
        if(errors && errors.length){
          var badrequeste = ejs.render(fs.readFileSync('./views/badrequest.ejs', 'utf8'), {
            title:'400 BadRequest',
            message:'エラー 入力に不備があります',
            detail:errors[0]
          });
          doRes(badrequest, res, 400, {'Content-Type': 'text/html'});
          return;
        }
        if(authoro.id){
          authorId = authoro.id;
          authorsql = "UPDATE authors SET name=" + "'" + authoro.name + "', age=" + authoro.age + ", updated_at=" + "'" + now + "'" + " WHERE id=" + authoro.id + ";"
        }else{
          authorsql = "INSERT INTO authors (name, age, created_at, updated_at) VALUES (" + "'" + authoro.name + "', " + authoro.age + ", '" + now + "', '" + now + "'" +  ");";
        }
        doshow(authorId, fs.readFileSync('./views/authorindex.ejs', 'utf8'), res, authorsql, "SELECT * FROM authors WHERE id=", { 'Content-Type': 'text/html' });
      });
    }
  }else if(uri == "/authordelete"){
    if(req.method == "POST"){
      var authordeletebody = '';
      req.on('data', function(chunk) {
        authordeletebody += chunk;
      });
      req.on('end', function() {
        doDelete(fs.readFileSync('./views/authordelete.ejs', 'utf8'), res, 'DELETE FROM authors WHERE ' + authordeletebody + ';', { 'Content-Type': 'text/html' }, { message:'作者データ削除' });
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
          doRes(bookindexejs, res, 200, {'Content-Type': 'text/html'})
        });
      });
    }else{
      connection.query('SELECT * from books;', (err, rows, fields) => {
        if (err) throw err;
        bookindexejs = ejs.render(bookindex, {
          title:"書籍一覧",
          books:rows
        });
        doRes(bookindexejs, res, 200, {'Content-Type': 'text/html'})
      });
    }
  }else if(uri == "/booknew"){
    connection.query('SELECT * FROM authors;', (err, rows, fields) => {
      if (err) throw err;
      var booknew = ejs.render(fs.readFileSync('./views/booknew.ejs', {
        title:"書籍新規",
        authors:rows
      });
      doRes(booknew, res, 200, {'Content-Type': 'text/html'});
    });
  }else if(uri == "/bookedit"){
    if(req.method == "POST"){
      connection.query('SELECT * FROM authors;', (err, rows, fields) => {
        if (err) throw err;
        var authors = rows;
        var bookeditbody = '';
        req.on('data', function(chunk) {
          bookeditbody += chunk;
        });
        req.on('end', function() {
          doEdit(fs.readFileSync('./views/bookedit.ejs', 'utf8'), res, 'SELECT *  FROM books WHERE ' + bookeditbody + ';', { 'Content-Type': 'text/html' }, authors);
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
        var booksql = "";
        var bookId = 0;
        prms = bookshowbody.split('&');
        var booko = returnBookParam(prms);
        if(booko.id){
          bookId = booko.id;
          booksql = "UPDATE books SET book_kind=" + booko.bookKind + ", author_id=" + booko.authorId + ", title=" + "'" + booko.title + "', updated_at=" + "'" + now + "'" + " WHERE id=" + booko.id + ";"
        }else{
          booksql = "INSERT INTO books (book_kind, author_id, title, created_at, updated_at) VALUES (" + booko.bookKind + ", " + booko.authorId + ", '" + booko.title + "', '" + now + "', '" + now + "'" +  ");";
        }
        doshow(bookId, fs.readFileSync('./views/bookindex.ejs', 'utf8'), res, booksql, "SELECT * FROM books WHERE id=", { 'Content-Type': 'text/html' })
      });
    }
  }else if(uri == "/bookdelete"){
    if(req.method == "POST"){
      var bookdeletebody = '';
      req.on('data', function(chunk) {
        bookdeletebody += chunk;
      });
      req.on('end', function() {
        doDelete(fs.readFileSync('./views/bookdelete.ejs', 'utf8'), res, 'DELETE FROM books WHERE ' + bookdeletebody + ';', { 'Content-Type': 'text/html' }, { message:'図書データ削除' });
      });
    }
  }else if(uri == "/badrequest"){
    doRes(fs.readFileSync('./views/badrequest.html', 'utf8'), res, 200, {'Content-Type': 'text/html'});
  }else if(uri == "/style.css"){
    doRes(fs.readFileSync('./style.css', 'utf8'), res, 200, {'Content-Type': 'text/css'});
  }else{
    var notfind = fs.readFileSync('./views/notfind.html', 'utf8');
    doRes(notfind, res, 403, {'Content-Type': 'text/html'});
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
  }else if(r.length == 2){
    return { name:r[0], age:r[1] };
  }else if(r.length == 1){
    return { id:r[0] };
  }else{
    return { };
  }
}

function returnBookParam(a) {
  var r = [];
  for(var i=0; i<a.length; i++){
    var prms = a[i].split('=');
    r.push(decodeURIComponent(prms[1]));
  }
  if(r.length == 5){
    return { id:r[0], bookKind:r[1], authorId:r[2], title:r[3], isLended:r[4] };
  }else if(r.length == 3){
    return { bookKind:r[0], authorId:r[1], title:r[2] };
  }else if(r.length == 1){
    return{ id:r[0] };
  }else{
    return { };
  }
}

function prmCheckAuthor(o) {
  var r = [];
  var name = o.name;
  var age = o.age;
  if(name.length){
    if(name.length > 10){
     r.push('名称が長過ぎます');
    }
  }else{
    r.push('名称が入力されていません');
  }
  if(isNaN(age)){
    r.push('年齢は数値でなければいけません');
  }
  return r;
}

function doRes(f, r, c, o) {
  r.writeHead(c, o);
  r.write(f);
  r.end();
}

function doshow(tid, f, r, s, as, aas, o) {
  connection.query(s, function(err, result){
    if (err) throw err;
    if(result.insertId) tid = result.insertId;
    var afterSql = as + tid + ";";
    connection.query(afterSql, (err, rows, fields) => {
      if (err) throw err;
      var addAfterSql = '';
      if(s.indexOf('authors') != -1){
        addAfterSql = aas + tid;
      }else{
        addAfterSql = aas + rows[0].author_id;
      }
      connection.query(addAfterSql, (er, rs, fs) => {
        var ob = s.indexOf('authors') != -1 ? { title:"作者詳細", author:rows[0], books:rs }:{ title:"書籍詳細", book:rows[0], author:rs[0] };
        var showf = ejs.render(f, ob)
        doRes(showf, r, 200, o);
      });
    });
  });
}

function doEdit(f, r, s, o, a=null) {
  connection.query(s, (err, rows, fields) => {
    if (err) throw err;
    var ob = s.indexOf('authors') != -1 ? { title:"作者編集", authors:rows }:{ title:"書籍編集", books:rows, authors:a };
    var editf = ejs.render(f, ob);
    doRes(editf, r, 200, o);
  });
}

function doDelete(f, r, s, o1, o2) {
  connection.query(s, (err, rows, fields) => {
    if (err) throw err;
    var deletef = ejs.render(f, o2);
    doRes(deletef, r, 200, o1);
  });
}

