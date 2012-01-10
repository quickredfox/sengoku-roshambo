nohm = require('nohm').Nohm;
redisClient = require('redis').createClient()
redisClient.select( 1 )
nohm.setClient( redisClient )
nohm.setPrefix('sengoku')


exports.Player = nohm.model "Player", 
    properties: 
        name:
            type: 'string'
            unique: false
            validations: [ ['notEmpty'] ]
        email:
            type: 'string'
            unique: true
            validations: [ ['notEmpty'], ['email'] ] 
        clan:       { type: 'json' }
        style:      { type: 'json' }
        statistics: { type: 'json' }
        