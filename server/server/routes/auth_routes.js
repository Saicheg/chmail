var passport = require('passport');
module.exports = function(app) {
	app.get('/login', function (req, res) {
        if (req.isAuthenticated()){
            res.redirect('/account', {currentPage: ''});
        }else{
            res.render('login.ejs', { message: "test"});
        }
	});
	app.get('/signup',function (req, res) {
        if (req.isAuthenticated()){
            res.redirect('/account');
        }else{
		  res.render('signup.ejs', { message: req.flash('signupMessage') });
        }
	});

	app.post('/signup', passport.authenticate('local-signup', {
		successRedirect : '/account', // redirect to the secure profile section
		failureRedirect : '/signup', // redirect back to the signup page if there is an error
		failureFlash : true // allow flash messages
	}));

	app.get('/account', isLoggedIn, function(req, res) {
		res.render('account.ejs', {
	            account : req.user, // get the user out of session and pass to template
	            'currentPage' : 'account'
	        });
	});
	app.get('/logout', function(req, res) {
		req.logout();
		res.redirect('/login');
	});

	app.get('/auth/google', passport.authenticate('google', { scope : ['profile', 'email'] }));

    // the callback after google has authenticated the user
    app.get('/oauth2/callback',
    	passport.authenticate('google', {
    		successRedirect : '/account',
    		failureRedirect : '/login'
    	})
    );

    app.get('/connect/google', passport.authorize('google', { scope : ['profile', 'email'] }));
    app.get('/connect/google/callback',
    	passport.authorize('google', {
    		successRedirect : '/account',
    		failureRedirect : '/login'
    	})
    );

    app.get('/unlink/google', function(req, res) {
        var account = req.user;
        account.google.token = undefined;
        account.save(function(err) {
           res.redirect('/account');
        });
    });
};

function isLoggedIn(req, res, next) {
	if (req.isAuthenticated()){
		return next();
	}
	res.redirect('/login');
};