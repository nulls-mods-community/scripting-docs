-- This script makes showdown loot boxes to BOOM just after they opened!

local marked = {}

function tick()
    for i, character in server.objectManager:getCharacters() do
        if marked[character.id] == nil and character.data:getName() == "LootBox" then
            marked[character.id] = true

            local callback = function()
                local data = lookup(17, "HeistBombExplosion")
                character:spawnCirclingAreaEffect(0, data, AttackOrigin.UNKNOWN, false, false)
                log("Boom!")
            end

            local callbackImpl = createCallback("BasicEventListener", callback)
            character.deathListeners:add(callbackImpl)
        end
    end
end
