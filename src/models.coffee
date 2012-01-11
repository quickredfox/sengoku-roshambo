nohm = require('nohm').Nohm;
redisClient = require('redis').createClient()
redisClient.select( 1 )
nohm.setClient( redisClient )
nohm.setPrefix('sengoku')

exports.orm=nohm
exports.Player = nohm.model "Player", 
  methods:
    toJSON:-> 
      email: @email
    toString:-> 
      @email
  properties: 
    email:
        type: 'string'
        unique: true
        validations: [ ['notEmpty'], ['email'] ] 

exports.Samurai = nohm.model "Samurai",
  methods:
    toJSON:-> 
      name:  @name
      clan:  if @clan then @clan.name 
      style: if @style then @style.name 
      stats: @stats
    toString:->
      json = @toJSON()
      [ json.clan or '', json.name ].join(' ').trim()
  properties:
    name:
      type: 'string'
      unique: false
      validations: [ ['notEmpty'] ]
    clan: 
      type: 'json'
    style:
      type: 'json'
    stats:
      type: 'json'
      defaultValue:
        life:        30 # player's health, reduced by combat, refilled by time
        strength:    0  # affects attacks 
        resistance:  0  # affects attacks
        victories:   0  # affects other players ;P these actually give me 3 values, victories+defeats = experience
        defeats:     0  # affects other players ;P these actually give me 3 values, victories+defeats = experience

exports.