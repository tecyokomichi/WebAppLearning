var http = require('http');
      fs = require('fs');
var server = http.createServer();
var settings = require('./settings')
console.log(settings);
server.on('request', function(req, res) {
  fs.readFile(__dirname + '/view/main.html', 'utf-8', function(err, data){
    if(err){
      res.writeHead(404, {'Content-Type': 'text/plain'});
      res.write("Not Found");
      return res.end();
    }
    res.writeHead(200, {'Content-Type': 'text/html'});
    res.write(data);
    res.end();
  });
})
server.listen(settings.port,settings.host)
