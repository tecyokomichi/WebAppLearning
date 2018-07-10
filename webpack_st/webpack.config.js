const webpack = require('webpack');
module.exports = {
    entry : './react-app.js',
    output : {
        filename : 'react-app.bundle_plugin.js'
    },
    module : {
        rules : [
            {
                test: /\.js$/,
                loader: 'babel-loader',
                exclude: /node_modules/,
                query: {
                  presets: ['react', 'es2015']
                }
            }
        ]
    },
    plugins : [
      new webpack.ProvidePlugin({
        $: 'jquery'
      })
    ]
};
