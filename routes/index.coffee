exports.index = (req, res) ->
  db.collectionNames (err, docs) ->
    if err
      console.log err
      return false
    res.render "index",
      collection: docs