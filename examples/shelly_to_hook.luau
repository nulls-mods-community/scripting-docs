local players = match.get_players()
for _, p in ipairs(players) do
    if p.character == "Hook" then
        p.skin = 0
        p.attack.damage = 0
        p.attack.projectile.damage = 0
        p.attack.super_charge_multiplier = 0.10
        p.attack.projectile.super_charge_multiplier = 0.10
        p.attack.hyper_charge_multiplier = 0.05
        p.attack.projectile.hyper_charge_multiplier = 0.05
        p:every(2.0, function()
            p:charge_super(0.20)
        end)
    end
end

if player.character == "Shelly" then
    if player.emote_used == 1 then
        local original_attack = player.attack:clone()
        local original_super = player.super:clone()
        player:set_model("Hook")
        player.skin = 0
        player.attack = original_attack
        player.super = original_super
        player:wait(10.0)
        player:reset_model()
        player.skin = 0
    end
end

match:every(0.5, function()
    local alive_players = match.get_alive_players()
    if #alive_players == 2 then
        local shelly_player = nil
        local winner_player = nil
        for _, p in ipairs(alive_players) do
            if p.character == "Shelly" then
                shelly_player = p
            else
                winner_player = p
            end
        end
        if shelly_player ~= nil and winner_player ~= nil then
            shelly_player:kill()
            match:broadcast_chat(winner_player.name .. " Выиграл , он будет Шелли")
            match:broadcast_chat("Привет из прошлого если кто то это видит в нулс бравле то бета тест наконец то открыли или меня услышал бета тестер")
        end
    end
end)
