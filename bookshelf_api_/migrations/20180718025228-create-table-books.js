'use strict';

var dbm;
var type;
var seed;

/**
  * We receive the dbmigrate dependency from dbmigrate initially.
  * This enables us to not have to rely on NODE_PATH.
  */
exports.setup = function(options, seedLink) {
  dbm = options.dbmigrate;
  type = dbm.dataType;
  seed = seedLink;
};

exports.up = function(db) {
  db.createTable('books', {
    id: {type: 'int', primaryKey: true, autoIncrement: true, allowNull: false},
    title: 'string',
    is_lended: {type: 'boolean', defaultValue: false},
    author_id: {type: 'int'},
    created_at: {type: 'datetime'},
    updated_at: {type: 'datetime'}
  });
  return null;
};

exports.down = function(db) {
  db.dropTable('books');
  return null;
};

exports._meta = {
  "version": 1
};
