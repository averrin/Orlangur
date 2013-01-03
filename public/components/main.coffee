root = global ? window

root.loadCss = (urls, callback) ->
    _.each urls, (e,i)->
        link = document.createElement("link")
        link.type = "text/css"
        link.rel = "stylesheet"
        link.href = e
        document.getElementsByTagName("head")[0].appendChild link
    callback()

root.get_template = (name, place, callback)->
    $(place).load '/template/' + name, callback

define ['jquery', 'lodash', 'backbone-amd', 'codemirror', 'bootbox', 'bootstrap'], ($, _, Backbone)->
    init: ->
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
            root.loadCss ['/components/css/codemirror.css', '/components/css/ambiance.css'], ->
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
                if data.ok
                    $('#meta_editor').modal 'hide'


        root.get_template 'col_list', $('#lc'), (data)->
            $.get '/collections', (data)->
                _.each data, (e,i)->
                    $('#collection_list').append e

            Controller = Backbone.Router.extend
                routes:
                    "": 'load'
                    "!/list/:name": 'view'

                view: (name)->
                    console.log 'view collection'
                    root.get_template 'items_list', $('#rc'), (data)->
                        $.get '/list/' + name, (data)->
                            ul = $('#rc ul')
                            $('.del_collection').attr 'data-name', name
                            $('.del_collection').attr 'data-name'
                            ul.children().remove()
                            $('#meta_info').html JSON.stringify(data.meta, `undefined`, 4).replace(/</g, '&lt;').replace(/>/g, '&gt;')
                            _.each data.items, (e,i)->
                                ul.append $(e)

            root.controller = new Controller
            Backbone.history.start()
