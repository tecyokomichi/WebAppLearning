var http = require('http');
var url = require('url');
var fs = require('fs');
var server = http.createServer();
var mime = {
  ".html": "text/html",
  ".css":  "text/css"
};
var connection = require('./dbconnection');

server.on('request', function(req, res){
  var Response = {
    "renderTop": function(){
      var template = fs.readFile('./views/top.html', 'utf-8', function(err, data){
        res.writeHead(200, { 'content-Type': 'text/html' });
        res.write(data);
        res.end();
      });
    },
    "renderAuthorindexejs": function(){
      var template = fs.readFile('./views/authorindex.ejs', 'utf-8', function (err, data){
        res.writeHead(200, { 'content-Type': 'text/html' });
        res.write(data);
        res.end();
      });
    },
    "renderAuthorindex": function(){
      var template = fs.readFile('./views/authorindex.html', 'utf-8', function (err, data){
        res.writeHead(200, { 'content-Type': 'text/html' });
        res.write(data);
        res.end();
      });
    },
    "renderAuthorindexjs": function(){
      var template = fs.readFile('./views/authorindex.js', 'utf-8', function (err, data){
        res.writeHead(200, { 'content-Type': 'text/javascript' });
        res.write(data);
        res.end();
      });
    },
    "renderBundlejs": function(){
      var template = fs.readFile('./bundle.js', 'utf-8', function (err, data){
        res.writeHead(200, { 'content-Type': 'text/javascript' });
        res.write(data);
        res.end();
      });
    },
    "renderDbconnectionjs": function(){
      var template = fs.readFile('./dbconnection.js', 'utf-8', function (err, data){
        res.writeHead(200, { 'content-Type': 'text/javascript' });
        res.write(data);
        res.end();
      });
    },
    "renderBookindex": function(){
      var template = fs.readFile('./views/bookindex.html', 'utf-8', function (err, data){
        res.writeHead(200, { 'content-Type': 'text/html' });
        res.write(data);
        res.end();
      });
    },
    "renderStylesheet": function(){
      var template = fs.readFile('./style.css', 'utf-8', function (err, data){
        res.writeHead(200, { 'content-Type': 'text/css' });
        res.write(data);
        res.end();
      });
    }
  };

  var uri = url.parse(req.url).pathname;

  if(uri === "/"){
    Response["renderTop"]();
    return;
  }else if(uri === "/authorindexejs"){
    Response["renderAuthorindexejs"]();
    return;
  }else if(uri === "/authorindex"){
    Response["renderAuthorindex"]();
    return;
  }else if(uri === "/authorindex.js"){
    Response["renderAuthorindexjs"]();
    return;
  }else if(uri === "/bundle.js"){
    Response["renderBundlejs"]();
    return;
  }else if(uri === "/dbconnection.js"){
    Response["renderDbconnectionjs"]();
    return;
  }else if(uri === "/style.css"){
    Response["renderStylesheet"]();
    return;
  }else if(uri === "/bookindex"){
    Response["renderBookindex"]();
    return;
  }
});

server.listen(3939)
console.log('Server running at http://localhost:3939/');
