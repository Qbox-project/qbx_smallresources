# Example Config

```lua
return {
    status = true, -- enables this module
    menu = {
        status = true,  -- enables the menu /staticemitters
        copyToClipboard = true, -- after teleporting to the emitter copy its pos to the clipboard
    },
    gameBuild = {
        [3751] = { -- checks by gamebuild to avoid setting no existing content
            ['example'] = {
                status = false, -- if true avoids setting any emitter in this group (if the emitters where already of setting this to true and restarting the script will not set them to true)
                emitters = {
                    ['example_emitter_loc_1'] = {
                        status = false, -- status for this specific emitter (restarting the script works here)
                        position = vec3(-2584.98, 1885.89, 163.01) -- pos to teleport for this specific emitter
                    },
                }
            }
        }
    }
}
```