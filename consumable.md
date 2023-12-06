** Add Eat AS Item **
```lua
Config.ConsumablesEat = {
    [itemName: string] = {
        label? = `string`,  -- text showing on progressbar
        progress? = `number`, --ms
        prop? = {
            bone = `number`,
            coords? = `vec(x, y, z)`,
            rot? = `vec(x, y, z)`,
        },
        anim? = { -- TaskPllayAnim
            lib = `string`,
            name = `string`,
            flag = `number`,
        },
        scenario? = string, -- TaskStartScenarioInPlace
        emote? = string,  -- emote on animation script name
        relieveStress? = `number`, -- will relieve stress
        fill = `number`,  --- filling of hunger/thrist
        action? = function(itemName: string)  --- do some crazy stuff
            print('Function Running')
        end
    }
}
```

** Add Drink AS Item **
```lua
Config.ConsumablesDrink = {
    [itemName: string] = {
        label? = `string`,
        progress? = `number`,  --ms
        prop? = {
            bone = `number`,
            coords? = `vec(x, y, z)`,
            rot? = `vec(x, y, z)`,
        },
        anim? = {
            lib = `string`,
            name = `string`,
            flag = `number`,
        },
        scenario? = `string`,
        emote? = `string`,
        relieveStress? = `number`,
        fill = `number`,
        action? = function(itemName: string)
            print('Function Running')
        end
    }
}
```

** Add Addiction AS Item **
```lua
Config.ConsumablesAddiction = {
    [itemName: string] = {
        label? = `string`,
        progress? = `number`, --ms
        prop? = {
            bone = `number`,
            coords? = `vec(x, y, z)`,
            rot? = `vec(x, y, z)`,
        },
        anim? = {
            lib = `string`,
            name = `string`,
            flag = `number`,
        },
        scenario? = `string`,
        emote? = `string`,
        relieveStress? = `number`,
        filltype? = string (hunger|thirst),
        fill = `number`,
        action? = function(itemName: string)
            print('Function Running')
        end
    }
}
```


** Add Use Item **
```lua
Config.ConsumablesAddiction = {
    [itemName: string] = {
        event? = `string`, -- any one of them (event/serverEvent) , if declared below lines will override
        serverEvent? = `string`, -- any one of them (event/serverEvent) , if declared below lines will override
        args? = `any`,
        label? = `string`,
        progress? = `number`, --ms
        prop? = {
            bone = `number`,
            coords? = `vec(x, y, z)`,
            rot? = `vec(x, y, z)`,
        },
        anim? = {
            lib = `string`,
            name = `string`,
            flag = `number`,
        },
        scenario? = `string`,
        emote? = `string`,
        action? = function(itemName: string)
            print('Function Running')
        end

    }
}
```