local Players = game:GetService("Players")
local logger = require(script.Parent.Parent.Logger) "plr-resolver"

export type PlayerResolvable = Player | number | string

return {
    getUserId = function(player: PlayerResolvable): number?
        if type(player) == "string" or tostring(player) then
            return player
        elseif typeof(player) == "Instance" and player:IsA("Player") then
            return player.Name
        elseif type(player) == "number" or tonumber(player) then
            local success, data = pcall(Players.GetNameFromUserIdAsync, Players, tonumber(player))
            if not success then
                return logger.warn("Could not get the username of " .. player, data)
            end
            return data
        else
            return logger.warnf("Could not coerce {player} to username", { typeof(player) }, player)
        end
    end,

    getUsername = function(player: PlayerResolvable): string?
        if type(player) == "number" or tonumber(player) then
            return player
        elseif typeof(player) == "Instance" and player:IsA("Player") then
            return player.UserId
        elseif type(player) == "string" or tostring(player) then
            local success, data = pcall(Players.GetUserIdFromNameAsync, Players, tostring(player))
            if not success then
                return logger.warn("Could not get the username of " .. player, data)
            end
            return data
        else
            return logger.warnf("Could not coerece {player} to userId", { typeof(player) }, player)
        end
    end,

    getPlayer = function(player: PlayerResolvable): Player?
        if typeof(player) == "Instance" and player:IsA("Player") then
            return player
        elseif type(player) == "number" or tonumber(player) then
            for _, plr: Player in Players:GetPlayers() do
                if plr.UserId == tonumber(player) then
                    return plr
                end
            end
            return logger.warn("Could not find a Player with the userId of " .. player)
        elseif type(player) == "string" or tostring(player) then
            if Players:FindFirstChild(tostring(player)) then
                return Players[tostring(player)]
            end
            return logger.warn("Could not find a Player with the username of " .. player)
        else
            return logger.warnf("Could not coerce {player} to Player", { typeof(player) }, player)
        end
    end
}
