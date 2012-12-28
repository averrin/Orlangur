root = global ? window

Controller = Backbone.Router.extend
  routes:
    "": 'load'
    "!/list/:name": 'view'

  view: (name)->
    console.log 'view'
    $.ajax '/list/' + name, (data)->
      $('#items').html data


controller = new Controller
Backbone.history.start()

$('.add_collection').live 'click', (ev)->
  bootbox.prompt 'New collection', (name)->
    if name
      $.ajax '/add/' + name, (data)->
        if data.ok
          window.location.reload()

$('.del_collection').live 'click', (ev)->
  ev.preventDefault()
  $.ajax '/del/' + $(this).data('name'), (data)->
    if data.ok
      window.location.reload()