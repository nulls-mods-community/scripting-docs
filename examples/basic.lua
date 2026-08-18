origins = enumAsTable("AttackOrigin")
unknownOrigin = origins["UNKNOWN"]

registered = 0

function tick()
    for i, character in server.objectManager:getCharacters() do
        if character.id > registered then
            local callback = function(target, projectile, damage, someData, origin)
                if target.hitPoints < damage then
                    character:takeHeal(character.index, 4000, true, nil, unknownOrigin)
                    log(`Персонаж {character.data} убил {target.data} и получает хил в 4000 ХП!`)
                end
            end

            local callbackImpl = createCallback("DamageEventListener", callback)
            character.dealingDamageListeners:add(callbackImpl)

            -- Remember last registered character object ID, so we cannot add the callback twice
            registered = character.id
        end

        if server.tick > 0 and (server.tick % 40) == 0 then
            -- Deal 100 damage to each character each 2 seconds
            character:takeDamage(character.index, 100, 0, nil, nil, true, false, character.x, character.y, nil, false, unknownOrigin, false, false, false, 0)
        end
    end
end
