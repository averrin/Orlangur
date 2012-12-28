colors = require 'colors'
console.log 'Init start'.yellow
express = require 'express'
routes = require './routes/init'
#user = require './routes/user'
#collections = require './routes/collections'
#routes = require './routes/index'
http = require 'http'
path = require 'path'
mongo = require 'mongo-lite'
util = require 'util'
_ = require 'underscore'
stylus = require 'stylus'

Handlebars = require 'Handlebars'
global.Handlebars = Handlebars

console.dir Handlebars

app = express()

app.configure ->
  app.set 'port', process.env.PORT || 3000
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.set express.favicon()
  app.set express.logger('dev')
  app.set express.bodyParser()
  app.set express.methodOverride()
  app.use app.router
  app.use stylus.middleware(__dirname + '/public')
  app.use express.static(path.join(__dirname, 'public'))

app.configure 'development', ->
  app.set express.errorHandler(dumpExceptions: true, showStack: true)


routes_dict = routes(app)
console.log 'Routes:'.blue, routes_dict.length
#console.log routes_dict

global.db = mongo.connect(util.format('mongodb://%s:%s@averr.in:27017/%s', 'averrin', 'aqwersdf', 'orlangur'))

http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port:".green, app.get('port')
