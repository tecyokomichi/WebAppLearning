var express = require('express');
var router = express.Router();
var connection = require('../mysqlConnection');

router.get('/:book_id', function(req, res, next) {
  var bookId = req.params.book_id;
  var query = 'SELECT * FROM books WHERE id = ' + bookId;
  connection.query(query, function(err, book) {
    res.render('book', {
      title: book[0].title,
      board: book[0]
    });
  });
});

module.exports = router;
