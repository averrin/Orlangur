express = require('express')
routes = require('./routes')
user = require('./routes/user')
http = require('http')
path = require('path')

app = express();

app.configure(->
  app.set('port', process.env.PORT || 3000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(require('stylus').middleware(__dirname + '/public'));
  app.use(express.static(path.join(__dirname, 'public')));
);

app.configure('development', ->
  app.use(express.errorHandler());
);

mongo = require('mongo-lite');
util = require('util');
_ = require('underscore');

global.db = mongo.connect(util.format('mongodb://%s:%s@averr.in:27017/%s', 'averrin', 'aqwersdf', 'orlangur'))

app.get('/', routes.index);
app.get('/users', user.list);

http.createServer(app).listen(app.get('port'), ->
  console.log("Express server listening on port " + app.get('port'));
);
