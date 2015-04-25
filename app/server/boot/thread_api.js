/**
 * Created by vladimirhudnitsky on 4/26/15.
 */

var Gmail = require('node-gmail-api');
module.exports = function(app) {
    app.get('/mythreads/:identiryId', function(req, res) {
        var id = req.params.identiryId;
        app.models.userIdentity.findById(id, function(err, instance) {
            if(err || !instance){
                res.send(err);
            }else {
                var gmail = new Gmail(instance.__data.credentials.accessToken);
                var threads = gmail.threads('', {});
                threads.on('data', function (d) {
                    console.log(d.snippet);
                    res.send("ok");
                })
            }
        });
    });
}

