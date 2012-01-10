express = require 'express'
RedisStore = require('connect-redis') express
HTTPS = require 'https'
QS = require 'querystring'

COOKIE_SECRET = process.env.COOKIE_SECRET || 'Shinmen Takezō vs Sasaki Kojirō'
IP_ADDRESS    = process.env.IP_ADDRESS || '127.0.0.1'
BROWSERID_URL = process.env.BROWSERID_URL || 'https://browserid.org'
BROWSERID_HOST= process.env.BROWSERID_HOST || 'browserid.org'
PORT          = process.env.PORT || 4567
LOCAL_HOSTNAME= undefined

app = express.createServer()

app.configure ()->
    app.use express.logger()
    app.use express.cookieParser()
    app.use express.bodyParser()
    app.use express.session secret: COOKIE_SECRET, store: new RedisStore()
    
    
app.configure 'development', ()->
    app.use express.static(__dirname + '/static')
    app.use express.errorHandler({ dumpExceptions: true, showStack: true })
    
app.configure 'production', ()->
    app.use express.static(__dirname + '/static', { maxAge: 31557600000 })
    app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.use app.router

       
app.requireAuthentication = ( req, res, next )->
    email = req.session.email
    if !email
        res.writeHead( 400, { 'Content-Type': 'text/plain' } )
        res.write("Bad Request: you must be authenticated.")
        return res.end()
    else next()
    
app.get '/auth/whoami', ( req, res )->
    email = if req.session and typeof req.session.email is 'string' then req.session.email else null
    res.json( email )

app.post '/auth/login', ( req, res )->
    data = 
        host: BROWSERID_HOST
        path: '/verify'
        method: 'POST'
    vreq = HTTPS.request data, (vres)->
        body = ''
        vres.on 'data', (chunk)-> body+=chunk
        vres.on 'end', ()->
            try
                verified = JSON.parse( body )
                valid = verified and verified.status and verified.status is 'okay'
                email = if valid then verified.email else null
                req.session.email = email
                if valid
                    console.log "Assertion verified successfully for email:", email
                else
                    console.log "Failed to verify assertion", verified.reason
                res.json( email )
            catch E
                console.log "non-JSON response from verifier"
                res.json( null )
    audience = if req.headers['host'] then req.headers['host'] else LOCAL_HOSTNAME   
    data = QS.stringify( assertion: req.body.assertion, audience: audience )
    vreq.setHeader 'Content-Type', 'application/x-www-form-urlencoded'
    vreq.setHeader 'Content-Length', data.length
    vreq.write( data )
    vreq.end()
    console.log "Verifying assertion."

app.post '/auth/logout', (req,res)->
    req.session.email = null
    res.json( true )


app.listen PORT, IP_ADDRESS, ()->
    address = app.address()
    LOCAL_HOSTNAME = address.address + ':' + address.port
    console.log "Listening on #{LOCAL_HOSTNAME}"

