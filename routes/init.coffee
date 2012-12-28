index = require './index'
collections = require './collections'

module.exports = (app)->
  app.all '/', collections.list
  app.all '/list/:name', collections.view
  app.all '/add/:name', collections.add
  app.all '/del/:name', collections.del
  app.routes.get
