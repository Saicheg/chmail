/**
 * Created by vladimirhudnitsky on 4/26/15.
 */

var google = require('googleapis');
var config = require('../../providers.json');
var gmail = google.gmail('v1');
module.exports = function(app) {
    app.get('/mythreads/:identiryId', function(req, res) {
        var id = req.params.identiryId;
        app.models.userIdentity.findById(id, function(err, instance) {
            if(err || !instance){
                res.send(err);
            }else {

                var OAuth2 = google.auth.OAuth2;
                var oauth2Client = new OAuth2(config["google-login"].clientID, config["google-login"].clientSecret, config["google-login"].callbackURL);

                oauth2Client.setCredentials({
                    access_token: instance.__data.credentials.accessToken,
                    refresh_token: instance.__data.credentials.accessToken
                });

                gmail.users.threads.list({"auth" : oauth2Client, "userId" : "me"}, function(err, response){
                    console.log('Result: ' + (err ? err.message : response));
                });
            }
        });
    });
}

