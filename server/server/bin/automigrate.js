var path = require('path');
var app = require(path.resolve(__dirname, '../server'));

var accounts = [
  {
    email: 'foo@bar.com',
    createdAt: new Date(),
    lastModifiedAt: new Date()
  },
  {
    email: 'baz@qux.com',
    createdAt: new Date(),
    lastModifiedAt: new Date()
  }
];
var dataSource = app.dataSources.accountDs;

dataSource.automigrate('Account', function(err) {
  if (err) console.log(err);

  var Account = app.models.Account;
  var count = accounts.length;

  accounts.forEach(function(account) {
    Account.create(account, function(err, record) {
      if (err) return console.log(err);

      console.log('Record created:', record);

      count--;

      if (count === 0) {
        console.log('done');
        dataSource.disconnect();
      }
    });
  });
});
