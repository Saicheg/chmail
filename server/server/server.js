var loopback = require('loopback');
var boot = require('loopback-boot');
var passport = require('passport');
var app = module.exports = loopback();
var flash = require('connect-flash');

var allowCrossDomain = function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // intercept OPTIONS method
  if ('OPTIONS' == req.method) {
    res.send(200);
  } else {
    next();
  }
};
//
//app.configure(function() {
//  app.set('view engine', 'ejs');
//  app.set('views', __dirname + '/public');
//  app.use(express.cookieParser());
//  app.use(express.bodyParser());
//  app.use(express.methodOverride());
//  app.use(express.session({secret: 'secret'}));
//  app.use(allowCrossDomain);
//  app.use(express.session({secret: 'secretchmailkey'}));
//  app.use(passport.initialize());
//  app.use(passport.session()); // persistent login sessions
//  app.use(flash()); // use connect-flash for flash messages stored in session
//  app.use(app.router);
//  app.use(express.static(path.resolve(__dirname, 'public')));
//});

// Routes.
//auth
require('./config/passport')(passport);
require('./routes/auth_routes')(app);
//web site
require('./routes/login')(app);


app.start = function() {
  // start the web server
  return app.listen(function() {
    app.emit('started');
    console.log('Web server listening at: %s', app.get('url'));
  });
};

// Bootstrap the application, configure models, datasources and middleware.
// Sub-apps like REST API are mounted via boot scripts.
boot(app, __dirname, function(err) {
  if (err) throw err;

  // start the server if `$ node server.js`
  if (require.main === module) {
    app.start();
  }
});
