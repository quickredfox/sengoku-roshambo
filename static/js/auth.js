(function() {
  var doLogin, doLogout, getSession, onGotVerifiedEmail, onLoggedIn, onLoggedOut, setSession;
  setSession = function(val) {
    if (navigator.id) {
      return navigator.id.session = val ? val : {};
    }
  };
  getSession = function() {
    if (navigator.id) {
      return navigator.id.session;
    }
  };
  onLoggedIn = function(email) {
    setSession({
      email: email
    });
    $('.logged-in').show().find('.email').text(email);
    $('.logged-out').hide();
    return $(document).trigger('login.browserid', [getSession()]);
  };
  onLoggedOut = function() {
    var goodbye;
    goodbye = getSession();
    setSession();
    $('.logged-in').hide();
    $('.logged-out').show();
    return $(document).trigger('logout.browserid', [goodbye]);
  };
  onGotVerifiedEmail = function(assertion) {
    if (assertion !== null) {
      return $.ajax({
        type: 'POST',
        url: '/auth/login',
        data: {
          assertion: assertion
        },
        success: function(res, status, xhr) {
          console.log("RES", res);
          if (res === null) {
            return onLoggedOut();
          } else {
            return onLoggedIn(res);
          }
        },
        error: function(res, status, xhr) {
          console.log(res);
          return alert("login failure" + res);
        }
      });
    } else {
      return onLoggedOut();
    }
  };
  doLogin = function(e) {
    e.preventDefault();
    return navigator.id.getVerifiedEmail(onGotVerifiedEmail);
  };
  doLogout = function(e) {
    e.preventDefault();
    return $.ajax({
      type: 'POST',
      url: '/auth/logout',
      success: function() {
        return onLoggedOut();
      }
    });
  };
  $(function() {
    $('#login').bind('click', doLogin);
    $('#logout').bind('click', doLogout);
    return $.getJSON('/auth/whoami', function(res) {
      if (res === null) {
        return onLoggedOut();
      } else {
        return onLoggedIn(res);
      }
      /*
                triggers some events on document to let other scripts handle these states
              */
    });
  });
}).call(this);
