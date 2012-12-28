module.exports.view = (req, res)->
  db.collection(req.params.name).all (err, docs)->
    if err
      console.log err
      return false
    res.send docs