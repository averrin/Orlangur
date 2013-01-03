index = require './index'
collections = require './collections'

module.exports = (app)->
    app.all '/', index.index
    app.all '/template/:name', index.template
    app.all '/collections', collections.list
    app.get '/list/:name', collections.view
    app.get '/add/:name', collections.add
    app.get '/del/:name', collections.del
    app.all '/update/:name', collections.update
