
###
	sengoku
###
# #devensive attributes
# @honor      = 10
# @reputation = 10
# @health     = 100
# # fighting attributes
# @technique  = 4
# @strength   = 6
# @defense    = 3
# # situational attributes
# @clans      = [] # 0 clans = "ronin"

DIE_MIN = 1
DIE_MAX = 6
HIT_MISS = 0
dieRoll = ()-> Math.floor(Math.random()*6)+1


# Character = ( name )->
#     instance        = @
#     instance.name   = name
#     instance.attack = dieRoll()
#     instance.block  = dieRoll()
#     instance.life   = 20*dieRoll()
#     instance.loose = ( hit, assailant )->
#         before= instance.life
#         console.log "life: #{instance.life}, hit: #{hit}"
#         instance.life = instance.life - hit
#         # todo: claculate armor vs weapons
#         if instance.life <= 0 
#              instance.life = 0
#              console.log "#{assailant.name} killed #{instance.name}, #{instance.name} died a miserable death."
#         else 
#             console.log "#{assailant.name} dealt damage to #{instance.name} before: #{before}, after: #{instance.life}"
#     return instance
#     


combat = ( assailant, target )->
    if target.life <= 0 
        throw "stop hitting on the corpse asshole!"
    offense = assailant.name
    defense = target.name
    attack  = assailant.attack
    block   = target.block
    roll    = dieRoll()
    if  roll is DIE_MIN 
        console.log "[die:#{roll}] <#{offense}:#{attack}> attacks <#{defense}:#{block}> and misses."
    else if roll is DIE_MAX
        hit = dieRoll()
        console.log "[die:#{roll}] <#{offense}:#{attack}> attacks <#{defense}:#{block}> with a direct hit! (#{hit})"
        target.fail hit, assailant
    else 
        mod = attack + ( roll - DIE_MID )
        hit = block - mod
        if hit > 0 
             console.log "[die:#{roll}] <#{offense}:#{attack}> attacks <#{defense}:#{block}> and hits. (#{hit})"
             target.fail hit, assailant
        else 
            console.log "[die:#{roll}] <#{offense}:#{attack}> attacks <#{defense}:#{block}> and gets blocked."


canHit = ( attacker, target, roll )->
    canhit = []
    if target.life <= 0
        canhit = [ false, 'dead' ]
    else if roll is DIE_MIN 
        canhit = [ false, 'miss']
    else if roll is DIE_MAX 
        canhit = [ true,  'critical' ]
    else 
        canhit = [ true,  'hit'  ]
    return canhit

calcHit = ( attacker, target, roll )->        
    [can,type] = canHit( attacker, target, roll ) 
    output = [can,type]
    if can
        dif = attacker.strength + (roll - Math.floor( DIE_MIN + DIE_MAX/2 ) )
        hit = target.block - dif
        hit += dieRoll() if type is 'critical'
        hit = hit + ( attacker.weapon - target.armor )
        if hit <= 0 
            can  = false
            output[1] = 'blocked'
            hit  = 0
        if hit >= target.life 
            output[1] = 'kill'
            hit  = target.life 
        output.push( hit )
    else output.push( hit = 0 )
    target.life = target.life - hit
    return output
    

      
        
        
        
class Samurai 
    toString: ()->
        "<#{@name}:[L:#{@life},S:#{@strength},D:#{@block}]>"
    constructor: ( @name )->
        @life   = ( 5 * dieRoll() ) + 5
        @strength = dieRoll()
        @block    = dieRoll()
        @block  = @block-dieRoll() if @attack is 6 and @block is 6
        @armor  = 1
        @weapon = 1
        return @
    attack: ( target )->
        roll   = dieRoll()
        if @life is 0
            console.log "In his/her tomb, #{@} dreams of combat."
        else
            [can,type,hit] = calcHit( @, target, roll )
            if can
                console.log "#{@} rolled a #{roll} to attack #{target} with success [#{type}, #{hit}]"
            else
                if type is 'dead' 
                    console.log "#{@} is raping CORPSES!"
                else 
                    console.log "#{@} rolled a #{roll} to attack #{target} and failed [#{type}, #{hit}]"


musashi  = new Samurai( 'Myamoto Musashi' )
yojimbo  = new Samurai( 'Yojimbo' )
enemies = [yojimbo, musashi];
ROUND = 0
toggle = (()->
    i=0
    ()-> i++%2    
)()

round = ()->
    a = toggle()
    b = toggle()
    toggle()
    enemies[a].attack( enemies[b] )
    if enemies[a].life is 0 or enemies[b].life is 0
        console.log "END"
    else
        setTimeout round, 500
setTimeout round, 500

