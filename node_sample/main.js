var http = require('http');
var url = require('url');
var fs = require('fs');
var server = http.createServer();
var connection = require('./mysqlConnection');

// http.createServerがrequestされたら、(イベントハンドラ)
server.on('request', function (req, res) {
    var Response = {
        "renderHTML": function () {
            var template = fs.readFile('./views/main.html', 'utf-8', function (err, data) {
                res.writeHead(200, {
                    'content-Type': 'text/html'
                });
                res.write(data);
            });
        },
        "indexGenerator": function () {
            var template = fs.readFile('./views/index.html', 'utf-8', function (err, data) {
                res.writeHead(200, {
                    'content-Type': 'text/html'
                });
                res.write(data);
                res.end();
           });
        },
        "newGenerator": function () {
            var template = fs.readFile('./views/new.html', 'utf-8', function (err, data) {
                res.writeHead(200, {
                    'content-Type': 'text/html'
                });
                res.write(data);
            });
        },
        "showGenerator": function () {
            var template = fs.readFile('./views/show.html', 'utf-8', function (err, data) {
                res.writeHead(200, {
                    'content-Type': 'text/html'
                });
                res.write(data);
                res.end();
           });
        },
        "notfoundGenerator": function () {
            var template = fs.readFile('./views/notfound.html', 'utf-8', function (err, data) {
                res.writeHead(200, {
                    'content-Type': 'text/html'
                });
                res.write(data);
                res.end();
            });
        }
};
var uri = url.parse(req.url).pathname;


    if(uri === "/"){
      Response["renderHTML"]();
      return;
    }else if(uri === "/index"){
      Response["indexGenerator"]();
      return;
    }else if(uri == "/new"){
      Response["newGenerator"]();
      return;
    }else if(uri == "/show"){
      Response["showGenerator"]();
      return;
    }else{
      Response["notfoundGenerator"]();
      return;
    };
});

server.listen(8080)
console.log('Server running at http://localhost:8080/');
