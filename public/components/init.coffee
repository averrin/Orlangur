require
    baseUrl: '/components/'
    shim:
        jquery:
            deps: []
            exports: '$'
        bootstrap:
            deps: ['jquery']
            exports: ''
        bootbox:
            deps: ['jquery']
            exports: ''

    ,
    ['domReady', 'main'], (domReady, main)->
        domReady ->
            main.init()
