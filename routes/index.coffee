#fs = require 'fs'
#path = require 'path'
#_ = require 'underscore'
#fs.readdirSync(__dirname).forEach (file) ->
#  route_fname = __dirname + "/" + file
##  route_name = path.basename(route_fname, ".js")
#  for key in _.keys(require(route_fname))
##    console.log key, require(route_fname)[key]
#    exports[key] = require(route_fname)[key]  if key isnt "index" and key[0] isnt "."

exports.list = (req, res) ->
  db.collectionNames (err, docs) ->
    if err
      console.log err
      return false
    res.render "index",
      collection: docs


exports.add = (req, res) ->
  db.createCollection req.params.name, (err, docs)->
    if err
      console.log err
      return false
    res.redirect '/'



exports.del = (req, res) ->
  db.collection(req.params.name).drop (err, docs)->
    if err
      console.log err
      return false
    res.redirect '/'