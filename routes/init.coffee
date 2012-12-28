index = require './index'
collections = require './collections'

module.exports = (app)->
  app.all '/', index.list
  app.all '/collections/:name', collections.view
  app.all '/add/:name', index.add
  app.all '/del/:name', index.del
  app.routes.get
