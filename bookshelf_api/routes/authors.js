var express = require('express');
var router = express.Router();

var connection = require('../mysqlconnection');

/* GET users listing. */
router.get('/authors', function(req, res, next){
  var query = 'SELECT *, DATE_FORMAT(created_at, \'%Y年%m月%d日 %k時%i分%s秒\') AS created_at FROM authors';
  connection.query(query, function(err, rows) {
    console.log(rows);
    res.render('index', { title: '作者一覧' });
  });
});

module.exports = router;
