_ = require 'underscore'

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