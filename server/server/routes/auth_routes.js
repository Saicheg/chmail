var passport = require('passport');
module.exports = function(app) {
	app.get('/login', function (req, res) {
        if (req.isAuthenticated()){
            res.redirect('/account', {currentPage: ''});
        }else{
            res.render('login.ejs', { message: req.flash('loginMessage') }); 
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
	app.post('/login', passport.authenticate('local-login', {
		successRedirect : '/home',
		failureRedirect : '/login',
		failureFlash : true
	}));

	app.get('/auth/google', passport.authenticate('google', { scope : ['profile', 'email'] }));

    // the callback after google has authenticated the user
    app.get('/oauth2/callback',
    	passport.authenticate('google', {
    		successRedirect : '/account',
    		failureRedirect : '/login'
    	})
    );

    //connects routes
    app.get('/connect/local', function(req, res) {
    	res.render('connect_local.ejs', { message: req.flash('loginMessage') });
    });
    app.post('/connect/local', passport.authenticate('local-signup', {
		successRedirect : '/account', // redirect to the secure profile section
		failureRedirect : '/connect/local', // redirect back to the signup page if there is an error
		failureFlash : true // allow flash messages
	}));

    app.get('/connect/google', passport.authorize('google', { scope : ['profile', 'email'] }));
    app.get('/connect/google/callback',
    	passport.authorize('google', {
    		successRedirect : '/account',
    		failureRedirect : '/login'
    	})
    );

    //unlink accounts
    app.get('/unlink/local', function(req, res) {
        var account = req.user;
        account.local.email = undefined;
        account.local.password = undefined;
        account.save(function(err) {
            res.redirect('/account');
        });
    });

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