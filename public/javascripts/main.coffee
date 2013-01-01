root = global ? window

Controller = Backbone.Router.extend
    routes:
        "": 'load'
        "!/list/:name": 'view'

    view: (name)->
        console.log 'view collection'
        $.get '/list/' + name, (data)->
            console.log data
            ul = $('#items ul')
            ul.children().remove()
            console.log ul
            _.each data, (e,i)->
                console.log e
                ul.append $(e)


controller = new Controller
Backbone.history.start()

$('.add_collection').live 'click', (ev)->
    bootbox.prompt 'New collection', (name)->
        if name
            $.get '/add/' + name, (data)->
                if data.ok
                    window.location.reload()

$('.del_collection').live 'click', (ev)->
    ev.preventDefault()
    $.get '/del/' + $(this).data('name'), (data)->
        if data.ok
            window.location.reload()

$('.edit_meta').live 'click', (ev)->
    ev.preventDefault()
    name = '__meta__'
    $.get '/list/' + name, (data)->
        root.editor = CodeMirror (elt)->
            $('#meta_editor #editor').html()
            $('#meta_editor #editor').html elt
        ,
            theme: 'ambiance'
            mode:
                name: "javascript"
                json: true
            lineNumbers: true
            value: JSON.stringify(data, `undefined`, 4)
        $('#meta_editor').modal 'show'

$('#save_meta').live 'click', (ev)->
    name = '__meta__'
    $.post '/update/' + name, items: root.editor.getValue(), (data)->
        console.log data
        if data.ok
            $('#meta_editor').modal 'hide'