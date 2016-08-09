import json

px_wide = 116
brightness = 1

pp_map = { "strips" : [[]] }

for y in [1,2,5,6,7,8,9,10,13,14]:

    for px in range(1,116):
        pp_map["strips"][0].append([px,y])

    for px in range(115,0,-1):
        pp_map["strips"][0].append([px,y+2])

''' # THIS VERSION GENERATES FILE AS DIRECTED BY CHRISTOHER
for y in [1,2,5,6,7,8,9,10,13,14]:

    for px in range(1,116):
        pp_map["strips"][0].append([px,y])

    for px in range(115,0,-1):
        pp_map["strips"][0].append([px,y+2])
'''
'''
for idx,y in enumerate([1,2,5,6,9,10,13,14]):

    pp_map["strips"].append([])
    
    for x in range(1,px_wide):
        # first strip addressed incrementally away from data pin
        pp_map["strips"][idx].append([x,y,1,brightness])
        
    for x in range((px_wide-1)*2, px_wide-1, -1):
        # 2nd strip from addressed incrementally towards data pin
        pp_map["strips"][idx].append([x,y+2,1,brightness])
        

for y in range(0,16):

    pp_map["strips"].append([])

    if y % 2: # odds
        
        for x in range((px_wide-1)*2, px_wide-1, -1):
            # 2nd strip from addressed incrementally towards data pin
            pp_map["strips"][y].append([x,y,1,brightness])
        
    else: # evens

        for x in range(1,px_wide):
            # first strip addressed incrementally away from data pin
            pp_map["strips"][y].append([x,y,1,brightness])
'''

print json.dumps(pp_map, sort_keys=True, indent=4, separators=(",", ": "))