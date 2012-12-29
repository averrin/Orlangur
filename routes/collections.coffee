_ = require 'underscore'
sync  = require 'synchronize'
mongo = require 'mongo-lite'
util = require 'util'

#mongo.options.safe = true
mongo.options.multi = true
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
      template: '{{meta.desc}}'
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
  db.collection(req.params.name).all (err, docs)->
    if err
      error res, err
    res.send docs

exports.update = (req, res) ->
  items = JSON.parse req.param('items', null)
  if items
    console.log '----'
    console.log items[1]
    db.collection(req.params.name).save items[1], (err)->
      db.collection(req.params.name).all name:items[1].name, (err, docs)->
        console.log docs
        console.log '----'
        success res
  else
    error res, 'items is null'