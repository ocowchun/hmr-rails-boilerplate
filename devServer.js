var path = require('path');
var express = require('express');
var webpack = require('webpack');
var rawConfig = require('./webpack.config');
var _ = require('underscore');

var oldEntry = rawConfig.entry;
var entries = _.keys(oldEntry);
var newEntry = {};

var hmrClient = 'webpack-hot-middleware/client?path=http://localhost:5000/__webpack_hmr&reload=true';

_.each(entries, function(entry) {
  newEntry[entry] = _.flatten([hmrClient, oldEntry[entry]]);
});

var config=_.extend(rawConfig,{entry:newEntry});

var app = express();
var compiler = webpack(config);

app.use(require('webpack-dev-middleware')(compiler, {
  noInfo: true,
  publicPath: config.output.publicPath
}));

app.use(require('webpack-hot-middleware')(compiler));

app.get('*', function(req, res) {
  res.sendFile(path.join(__dirname, 'index.html'));
});

app.listen(5000, 'localhost', function(err) {
  if (err) {
    console.log(err);
    return;
  }

  console.log('Listening at http://localhost:5000');
});
