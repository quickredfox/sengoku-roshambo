(function() {
  var askForLogin, fetchLogin;
  askForLogin = function() {
    var defer;
    defer = $.Deferred();
    navigator.id.get(function(assertion) {
      if (assertion) {
        return defer.resolve(assertion);
      } else {
        return defer.reject();
      }
    });
    return defer.promise();
  };
  fetchLogin = function(assertion) {
    var data, post, url;
    url = 'https://browserid.org/verify';
    data = {
      assertion: assertion,
      audience: 'http://localhost:4567'
    };
    post = $.post(url, data);
    post.fail(function() {
      return console.log('fail', arguments);
    });
    return post.done(function() {
      return console.log('done', arguments);
    });
  };
  $(function() {
    var $btn;
    $btn = $('<button>').text('Sign in.').appendTo(document.body);
    return $btn.on('click', function() {
      var prompt;
      $btn.remove();
      prompt = askForLogin();
      prompt.fail(function() {
        return console.log('prompt fail', arguments);
      });
      return prompt.done(function() {
        return console.log('prompt done', arguments);
      });
    });
  });
}).call(this);
