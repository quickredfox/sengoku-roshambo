(function() {
  var nohm, redisClient;
  nohm = require('nohm').Nohm;
  redisClient = require('redis').createClient();
  redisClient.select(1);
  nohm.setClient(redisClient);
}).call(this);
