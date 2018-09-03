var express = require('express');
var router = express.Router();

var connection = require('../mysqlConnection');

/* GET home page. */
router.get('/', function(req, res, next) {
  var query = 'SELECT * FROM books';
  connection.query(query, function(err, rows) {
    console.log(rows);
    res.render('index', {
      title: 'Express',
      boardList: rows
    });
  });
});

router.post('/', function(req, res, next) {
  var title = req.body.title;
  var query = 'INSERT INTO books (title) VALUES ("' + title + '")';
  connection.query(query, function(err, rows) {
    res.redirect('/');
  });
});
module.exports = router;
