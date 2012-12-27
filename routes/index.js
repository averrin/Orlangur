
/*
 * GET home page.
 */
var mongo = require('mongo-lite');
var util = require('util');
var _ = require('underscore');

db = mongo.connect(util.format('mongodb://%s:%s@averr.in:27017/%s', 'averrin', 'aqwersdf', 'orlangur'))

exports.index = function(req, res){
    db.collectionNames(
        function(err, docs){
            if(err){
                console.log(err);
                return false;
            }
            res.render('index', { collection: docs });
        }
    )
};