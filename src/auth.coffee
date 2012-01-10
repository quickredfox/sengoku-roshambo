setSession = (val)->
    if navigator.id
        navigator.id.session = if val then val else {}
        
getSession = ()->
    if navigator.id
        navigator.id.session
        
onLoggedIn = ( email )->
    setSession email: email
    $('.logged-in').show().find('.email').text( email )
    $('.logged-out').hide()
    $( document ).trigger 'login.browserid', [ getSession() ]
    
onLoggedOut = ()->
    goodbye = getSession()
    setSession()
    $('.logged-in').hide()
    $('.logged-out').show()
    $( document ).trigger 'logout.browserid', [ goodbye ] 

    
onGotVerifiedEmail = ( assertion )->
    if assertion isnt null
        $.ajax
            type: 'POST'
            url: '/auth/login'
            data: { assertion: assertion }
            success: ( res, status, xhr )->
                console.log "RES", res
                if res is null then onLoggedOut()
                else onLoggedIn( res )
            error: ( res, status, xhr )->
                console.log res
                alert( "login failure" + res )
                
    else onLoggedOut()
    
doLogin  = (e)-> 
    e.preventDefault() 
    navigator.id.getVerifiedEmail( onGotVerifiedEmail )
    
doLogout = (e)-> 
    e.preventDefault() 
    $.ajax
        type: 'POST'
        url: '/auth/logout'
        success: ()-> onLoggedOut()

$ ()->
    $('#login').bind 'click',  doLogin
    $('#logout').bind 'click', doLogout
    
    $.getJSON '/auth/whoami', (res)->
        if res is null then onLoggedOut()
        else onLoggedIn( res )
        ###
          triggers some events on document to let other scripts handle these states
        ###
        # $(document).on 'login.browserid', ( evt, data )->
        #     console.log "LOGED IN",  JSON.stringify data 
        # $(document).on 'logout.browserid', ( evt, data )->
        #     console.log "LOGED OUT", JSON.stringify data 
