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
  db.createTable('authors', {
    id: {type: 'int', primaryKey: true, autoIncrement: true, allowNull: false},
    name: 'string',
    created_at: {type: 'datetime'},
    updated_at: {type: 'datetime'}
  });
  return null;
};

exports.down = function(db) {
  db.dropTable('authors');
  return null;
};

exports._meta = {
  "version": 1
};
