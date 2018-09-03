var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: './dbconnection.js',
  target: 'node',
  output: { path: __dirname, filename: 'bundle.js' },
  module: {
    rules: [
      {
        test: /.jsx?$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          presets: ['es2015', 'react'],
        },
      },
    ],
  }
};
