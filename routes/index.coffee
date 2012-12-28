#fs = require 'fs'
#path = require 'path'
#_ = require 'underscore'
#fs.readdirSync(__dirname).forEach (file) ->
#  route_fname = __dirname + "/" + file
##  route_name = path.basename(route_fname, ".js")
#  for key in _.keys(require(route_fname))
##    console.log key, require(route_fname)[key]
#    exports[key] = require(route_fname)[key]  if key isnt "index" and key[0] isnt "."