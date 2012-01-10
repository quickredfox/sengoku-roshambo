(function() {
  var rollDie;
  rollDie = function(n) {
    if (n == null) {
      n = 6;
    }
    return (Math.random() * n) + 1;
  };
}).call(this);
