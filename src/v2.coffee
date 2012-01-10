### 
  fighting styles (8)
###

rnd = ( n=6 )-> (Math.random()*n)+1

WEAPONS_DATA= 
  Katana:    { cut: .6, block: .2, stab: .4, hits: 8  }
  Wakisashi: { cut: .4, block: .2, stab: .6, hits: 8  }
  Spear:     { cut: .0, block: .3, stab: .9, hits: 3  }
  Naginata:  { cut: .2, block: .3, stab: .8, hits: 4  }
  Bo:        { cut: .0, block: .9, stab: .3, hits: 4  }
  Hattori_Hanzo: { cut: 1, block: .2, stab: .5, hits: Infinity  }

STRIKES=
  Kirioshi: 
    description: 'Downward straight cut.'
    type: 'cut'
    stops: []
  Mayoko_Giri:
    description: 'Side cut, left to right.'
    type: 'cut'
    stops: ['Kirioshi']
  Kesa_Giri:
    description: 'Downward diagonal cut.'
    type: 'cut'
    stops: ['Tsuki', 'Mayoko_Giri']
  Kiriagi:
    description: 'Upward diagonal cut.'
    stops: ['Tsuki', 'Kirioshi']    
  Tsuki:
    description: 'Straight thrust'
    stops: []
  
compareStrikes = ( strikeA, strikeB )->
  Kirioshi
  

PERKS_DATA=
  FirstStrike: ( combat )->
    combat.on 'start', ()->
        combat.attacker.autoAttack( combat.target, 'first strike' )
  Retaliation: ( combat )->
    combat.attacker.on 'block', ()->
        combat.attacker.autoAttack( combat.target, 'retaliate' )
  Fear: ( combat )->
    if !combat.target.fearful
      combat.target.fearful = true
      combat.target.block = combat.target.block-(combat.target.block/2)
  Weakblade: ( combat )->
    if !combat.attacker.weakblade
      combat.attacker.weakblade = true
      combat.attacker.weapons = combat.attacker.weapons.map ( weapon )->
        weapon.hits = Math.ceil( weapon.hits*0.6 )
  MartialArtist: ( combat )->
    if !combat.attacker.jiujitsu
      combat.attacker.weapons.push 
        
FIGHTING_STYLES=
  name: 
      
      
    
  
    
Style.DATA = [
    name: 'Muso Jikiden Eishin-ryu'
    description: 'Draw and cut in one powerful move.'
    onStart: ( target )->
        autoAttack( @, target, 'First Strike' )
    onRound:  ( target )->
    onAttack: ( target )->
    onBlock:  ( target)->
,
    name: 'Hyoho Niten Ichi-ryu'
    description: 'Myamoto musashi style, dual swords above head, one defends the other cuts, repeat.'
    onStart: ( target )->
      target.block = target.block - ( 0.5 * target.block )
    onRound: ( target )->
    onBlock: ( target )->
      if rnd() >= 2 then autoAttack( @, target, 'Retaliate' )
, 
    name: 'Tenshin Shoden Katori Shinto-ryu'
    description: 'Multiple weapons, practitioner of jiujitsu hand combat.'
    onStart: ( target )->
    onRound: ()->
      
    perks: [ 'weaponry', 'weakblade', 'fist( +50 )' ]
,
    name: 'Mugai-ryu'
    description: 'Style of precision, techniques used in practice allow for precise cuts.'
    perks: [ 'precision(+15)' ]
,
    name: 'Ono-ha Itto-ryu'
    description: 'Relies on a single poweful cut down the center line.'
    perks: [ 'precision( +50, kirioshi )', 'onesword' ]
,
    name: 'Yagyu Shinkage-ryu'
    description: 'Thinner blades allow for flow and subtle movement, prefer to disarm than to kill.'
    perks: [ 'weakblade', 'disarm', 'fist( +50 )'  ]
,
    name: 'Jigen-ryu'
    description: "Running slice meant to kill on first strike top left to bottom right."
    perks: ['precision( +50, kesa-giri )']
, 
    name: 'Tamiya-ryu'
    description: 'Longe hilts for more grip and power. Raised stance makes feet hard to follow.'
    perks: ['strength( +50 )', 'fear( +15 )']
]

        



Fighter = ( @name )-> 
    @info=
        level:     1
        victories: 0   
        losses:    0
        retreats:  0
        forfeits:  0
    @stats=
        life:     100 # defines how many hits one can take before dying
        # 12 points basic, 12 distributed
        strength: rnd( 6 ) + 6 
        defense:  rnd( 6 ) + 6 
    @weapons=[
        name: 'Katana',   strength: .3
        name: 'wakisahi', strength: .2        
    ]
    
        katana:   2
        wakisahi: 1
    
    return @

    # 
    # style: ( style )->
    #     if style is undefined then return @style
    #     if typeof style is number then style = FightingStyles[ style ]
    #     return @style = style
    # roll: ( d = 6 )-> Math.floor( Math.random() * d ) + 1
    
    

FightingStyles = [
    name: 'Muso Jikiden Eishin-ryu'
    description: 'Draw and cut in one powerful move.'
    perks: [ 'firststrike' ]
,
    name: 'Hyoho Niten Ichi-ryu'
    description: 'Myamoto musashi style, dual swords above head, one defends the other cuts, repeat.'
    perks: [ 'retaliation', 'fear( +50 )' ]
, 
    name: 'Tenshin Shoden Katori Shinto-ryu'
    description: 'Multiple weapons, practitioner of jiujitsu hand combat.'
    perks: [ 'weaponry', 'weakblade', 'fist( +50 )' ]
,
    name: 'Mugai-ryu'
    description: 'Style of precision, techniques used in practice allow for precise cuts.'
    perks: [ 'precision(+15)' ]
,
    name: 'Ono-ha Itto-ryu'
    description: 'Relies on a single poweful cut down the center line.'
    perks: [ 'precision( +50, kirioshi )', 'onesword' ]
,
    name: 'Yagyu Shinkage-ryu'
    description: 'Thinner blades allow for flow and subtle movement, prefer to disarm than to kill.'
    perks: [ 'weakblade', 'disarm', 'fist( +50 )'  ]
,
    name: 'Jigen-ryu'
    description: "Running slice meant to kill on first strike top left to bottom right."
    perks: ['precision( +50, kesa-giri )']
, 
    name: 'Tamiya-ryu'
    description: 'Longe hilts for more grip and power. Raised stance makes feet hard to follow.'
    perks: ['strength( +50 )', 'fear( +15 )']
]
 
SwordCuts = [
    name: 'Kirioshi'
    description: 'Downward straight cut.'
,
    name: 'Mayoko Giri'
    description: 'Side cut, left to right.'
,
    name: 'Mayoko Giri (alt)'
    description: 'Side cut, right to left.'
,
    name: 'Kesa Giri'
    description: 'Downward diagonal cut. Top left to bottom right.'
,
    name: 'Kesa Giri  (alt)'
    description: 'Downward diagonal cut. Top right to bottom left.'    
,
    name: 'Kiriagi'
    description: 'Upward diagonal cut. Bottom right to top left.'
,
    name: 'Kiriagi (alt)'
    description: 'Upward diagonal cut. Bottom left to top right.'
,
    name: 'Tsuki'
    description: 'Straight thrust'
]

