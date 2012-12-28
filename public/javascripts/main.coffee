root = global ? window

Controller = Backbone.Router.extend
  routes:
    "": 'load'
    "!/collections/:page": 'load'

  load: (page)->
    console.log 'load?'
    $.ajax '/collections/' + page, (data)->
      console.log data

controller = new Controller
Backbone.history.start()