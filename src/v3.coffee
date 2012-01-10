rollDie = ( n=6 )-> (Math.random()*n)+1






# 
# attacker: 
#   roll: 5
#   name: 'Yojimbo'
#   statistics:  
#      life:     100
#      strength: 6
#      defense:  6
#   modifiers:
#     weapon: 
#       cut:   1
#       block: 1
#       stab:  1
#     style:  
#       precision:    0
#       retaliation:  0
#       martial_arts: 0
#   strike: { name: "Kirioshi", type: 'c', stops: [] }
#   
# target: 
#   roll: 3
#   name: 'Sanjuro'
#   statistics:  
#      life:     100
#      strength: 6
#      defense:  6
#   modifiers:
#     weapon: 
#       cut:   1
#       block: 1
#       stab:  1
#     style:  
#       precision:    0
#       retaliation:  0
#       martial_arts: 0
#   strike: { name: "Tsuki", type: 's', stops: [] }
# 
# 
# canHit = ( attacker, target, roll )->
#     canhit = []
#     # determine by dice
#     if target.life <= 0
#         canhit = [ false, 'dead' ]
#     else if roll is DIE_MIN 
#         canhit = [ false, 'miss']
#     else if roll is DIE_MAX 
#         canhit = [ true,  'critical' ]
#     else 
#         canhit = [ true,  'hit'  ]
#     # re-evaluate by strike
#     if canhit[0] is true
#       if attacker.stops.length > 0
#         stopped = attacker.stops.reduce ( bool, cur )->
#             if bool is false then bool = target.strike.name is cur
#             return bool
#         , false  
#     return canhit
#     
# attack = ( a, b )->
#   [canhit,hitstatus] = canHit( a, b, roll = rollDie() )  
#   hit_str = 0
#  
#       
#     
#   
#     
#   
#   
#   
#   
#   
# STRIKES=
#   Kirioshi: 
#     description: 'Downward straight cut.'
#     type: 'cut'
#     stops: []
#   Mayoko_Giri:
#     description: 'Side cut, left to right.'
#     type: 'cut'
#     stops: ['Kirioshi']
#   Kesa_Giri:
#     description: 'Downward diagonal cut.'
#     type: 'cut'
#     stops: ['Tsuki', 'Mayoko_Giri']
#   Kiriagi:
#     description: 'Upward diagonal cut.'
#     stops: ['Tsuki', 'Kirioshi']    
#   Tsuki:
#     description: 'Straight thrust'
#     stops: []
# 
# 








