# Uniscript Depository
This is a script destinated to farming materials all with the ox_target system. You need to insert the element in the Config.Raccolta
This element have these attribute:
- coords : here you have to set coords vector3(x,y,z) where the farming will be.
- itemRequest : set the item name that is needed to farm the element. If no need it can be removed.
- dict : dict of animation.
- lib : lib of animation.
- prop : prop to spawn when farming. If no need it can be removed.
- rotation : If prop is setted, set rotation too for the position of prop.
- qtymax : Max quantity to farm in one step.
- qtymin : Min quantity to farm in one step.
- randomItem : set it true if there are more then one item.
- item : list of items to farm in this element, example -> {'bread', 'water'}


Some examples of elements...

In this example is not setted 'item' attribute so the item of element is the name specified in the squared brackets.
```sh
['wood'] = {
    coords = { vector3(-557.94, 5234.29, 71.80) }, 
    itemRequest = 'weapon_hatchet',
    dict = "melee@hatchet@streamed_core",
    lib = "plyr_front_takedown",
    prop = "prop_w_me_hatchet",
    rotation = {x=0.05, y=0.02, z=0.02, rx=-44.04, ry=-9.78, rz=-1.43},
    qtymax = 5,
    qtymin = 0
},
```

In this example the 'mineral' element have three items 'iron', 'copper', 'gold' that will be randomly collected.
```sh
['mineral'] = {
    coords = {
        vector3(3004.68, 2775.56, 43.02),
        vector3(2989.35, 2808.58, 44.88),
        vector3(2910.06, 2782.95, 45.97),
        vector3(2915.25, 2805.04, 44.15),
    },
    dict = "melee@large_wpn@streamed_core",
    lib = "ground_attack_on_spot",
    prop = "prop_tool_pickaxe",
    rotation = {x=0.03, y=-0.09, z=-0.03, rx=-55.23, ry=0.0, rz=0.0},
    randomItem = true,
    item = {'iron', 'copper', 'gold'},
    qtymax = 5,
    qtymin = 1
},
```# uniscript_farming
