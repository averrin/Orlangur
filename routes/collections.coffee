_ = require 'underscore'
#sync    = require 'synchronize'
mongo = require 'mongo-lite'
util = require 'util'
step = require 'step'
Handlebars = require 'Handlebars'

#mongo.options.safe = true
#mongo.options.multi = true
db = mongo.connect(util.format('mongodb://%s:%s@averr.in:27017/%s', 'averrin', 'aqwersdf', 'orlangur'))

success = (res)->
    res.send
        ok: 1
        err: ''

error = (res, err)->
    console.log err
    res.send
        ok: 0
        err: err

exports.list = (req, res) ->
    db.collection('__meta__').all (err, docs) ->
        if err
            console.log err
            return false

        res.render "index",
            collection: docs


exports.add = (req, res) ->
    db.createCollection req.params.name, (err, docs)->
        if err or not req.params.name
            error res, err
        db.collection('__meta__').insert
            name: req.params.name
            desc: req.params.name
            template: "<a href='#!/list/{{meta.name}}'>{{meta.desc}}</a>"
            ,
            (err, docs)->
                if err
                    error res, err
                success res



exports.del = (req, res) ->
    db.collection(req.params.name).drop (err, docs)->
        if err
            error res, err
        else
            db.collection('__meta__').remove name: req.params.name, (err, docs)->
                if err
                    error res, err
                else
                    success res

exports.view = (req, res)->
    name = req.params.name
    if name is '__meta__'
        db.collection(name).all (err, docs)->
            res.send docs
    else
        meta = db.collection('__meta__')
        meta.first name: name, (err, meta)->
            db.collection(name).all (err, docs)->
                items = []
                if err
                    error res, err
                _.each docs, (e,i)->
                    if meta.item_template
                        items.push Handlebars.compile(meta.item_template)(
                            meta: meta
                            item: e
                        )
                    else
                        items.push util.format '<li><pre>%s</pre></li>', JSON.stringify(e, `undefined`, 4)
                res.send items

exports.update = (req, res) ->
    meta = db.collection('__meta__')
    step ->
        JSON.parse req.param('items', null)
    , (err, items)->
        this.items = items
        meta.all {}, this
    , (err, docs)->
        items = this.items
        group = this.group()
        _.each docs, (doc, i)->
            if doc
                item = _.find items, (item)->
                    doc.name is item.name
                if item
                    i = _.indexOf items, item
                    items.splice(i, 1)
                    _.each _.difference(_.keys(doc), _.keys(item)), (e,i)->
                        if e != '_id'
                            delete doc[e]
                    delete item['_id']
                    _.extend doc, item
                    meta.save doc, group()
                else
                    meta.remove doc, group()
    , (err)->
        console.log err
        if not err
            success res