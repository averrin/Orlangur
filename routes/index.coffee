exports.index = (req, res) ->
    res.render 'index'

exports.template = (req, res) ->
    res.render req.params.name