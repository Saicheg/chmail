var GoogleStrategy = require('passport-google-oauth').OAuth2Strategy;
var persistedModel = new require('loopback').PersistedModel;
var configAuth = require('./auth');

// expose this function to our app using module.exports
module.exports = function(passport) {

    // required for persistent login sessions
    // passport needs ability to serialize and unserialize users out of session

    // used to serialize the user for the session
    passport.serializeUser(function(user, done) {
        done(null, user.id);
    });

    // used to deserialize the user
    passport.deserializeUser(function(id, done) {
        persistedModel.findById(id, function(err, instance){
            done(err, instance);
        });
    });

    passport.use(new GoogleStrategy({
        clientID : configAuth.googleAuth.clientID,
        clientSecret : configAuth.googleAuth.clientSecret,
        callbackURL : configAuth.googleAuth.callbackURL,
        passReqToCallback : true

    },
    function(req, token, refreshToken, profile, done) {
        // make the code asynchronous
        process.nextTick(function() {
            if (!req.user) {
                var newUser = {};
                newUser.google_id = profile.id;
                newUser.token = token;
                newUser.name = profile.displayName;
                newUser.email = profile.emails[0].value;

                persistedModel.findOrCreate({'where': {'google_id': profile.id}}, newUser, function (err, instance) {
                    if (err) {
                        return done(err);
                    }
                    if (!instance.token) {
                        instance.token = token;
                        instance.name = profile.displayName;
                        instance.email = profile.emails[0].value;
                        instance.save({}, function (err, instance) {
                            if (err)
                                throw err;
                            return done(null, instance);
                        });
                    }
                    return done(null, instance);

                });
            }
        });
    }));

};
