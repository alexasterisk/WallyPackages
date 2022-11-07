local Players = game:GetService("Players")

local Promise = require(script.Parent.Promise)

export type Character = Model & {
    HumanoidRootPart: BasePart,
    PrimaryPart: BasePart,
    Humanoid: Humanoid
}

export type PlayerResolvable = Player | Character | number | string


local funcs = {}

function funcs.verifyUsername(username: string): boolean
    if type(username) == "string" or tostring(username) then
        local success, data = pcall(Players.GetUserIdFromNameAsync, Players, tostring(player))
        return success
    end
    return false
end

function funcs.verifyUserId(userId: number): boolean
    if type(userId) == "number" or tonumber(userId) then
        local success, data = pcall(Players.GetNameFromUserIdAsync, Players, tonumber(userId))
        return success
    end
    return false
end

function funcs.getUserId(player: PlayerResolvable)
    return Promise.new(function(resolve, reject)
        if funcs.verifyUserId(player) then
            return resolve(tonumber(player))
        elseif type(player) == "string" or tostring(player) then
            local success, data = pcall(Players.GetNameFromUserIdAsync, Players, tonumber(player))
            if not success then
                return reject("Could not get the userId of " .. player, data)
            end
            return resolve(data)
        elseif typeof(player) == "Instance" then
            if player:IsA("Player") then
                return resolve(player.UserId)
            elseif player:IsA("Model") and Players:FindFirstChild(player.Name) then
                return resolve(Players[player.Name].UserId)
            end
            return reject(player:GetFullName() .. " is not a Player or a Character and could not be coerced to a userId", player)
        else
            return reject("Could not coerce " .. typeof(player) .. " to userId", player)
        end
    end)
end

function funcs.getUsername(player: PlayerResolvable)
    return Promise.new(function(resolve, reject)
        if funcs.verifyUsername(player) then
            return resolve(tostring(player))
        elseif type(player) == "number" or tonumber(player) then
            local success, data = pcall(Players.GetUserIdFromNameAsync, Players, tostring(player))
            if not success then
                return reject("Could not get the username of " .. player, data)
            end
            return resolve(data)
        elseif typeof(player) == "Instance" then
            if player:IsA("Player") then
                return resolve(player.Name)
            elseif player:IsA("Model") and Players:FindFirstChild(player.Name) then
                return resolve(player.Name)
            end
            return reject(player:GetFullName() .. " is not a Player or a Character and could not be coerced to a username", player)
        else
            return reject("Could not coerce " .. typeof(player) .. " to username", player)
        end
    end)
end

function funcs.getPlayer(player: PlayerResolvable)
    return Promise.new(function(resolve, reject)
        if typeof(player) == "Instance" then
            if player:IsA("Player") then
                return resolve(player)
            elseif player:IsA("Model") and Players:FindFirstChild(player.Name) then
                return resolve(Players[player.Name])
            end
            return reject(player:GetFullName() .. " is not a Player or a Character and could not be coerced to a Player", player)
        elseif typeof(player) == "number" or tonumber(player) then
            for _, plr: Player in Players:GetPlayers() do
                if plr.UserId == tonumber(player) then
                    return resolve(plr)
                end
            end
            return reject("Could not find a Player with the userId of " .. player)
        elseif type(player) == "string" or tostring(player) then
            if player.Name == tostring(player) then
                return resolve(player)
            end
            return reject("Could not find a Player named " .. tostring(player))
        else
            return reject("Could not coerce " .. typeof(player) .. " to Player", player)
        end
    end)
end

function funcs.getCharacter(player: PlayerResolvable)
    return Promise.new(function(resolve, reject)
        if typeof(player) == "Instance" then
            if player:IsA("Player") then
                return resolve(player.Character or player:GetPropertyChangedSignal("Character"):Wait())
            elseif player:IsA("Model") and Players:FindFirstChild(player.Name) then
                return resolve(player)
            end
            return reject(player:GetFullName() .. " is not a Player or a Character and could not be coerced to a Character", player)
        elseif type(player) == "number" or tonumber(player) then
            for _, plr in player:GetPlayers() do
                if plr.UserId == tonumber(player) then
                    return resolve(plr.Character or plr:GetPropertyChangedSignal("Character"):Wait())
                end
            end
            return reject("Could not find a Character that the given userId belongs to", tonumber(player))
        elseif type(player) == "string" or tostring(player) then
            if Players:FindFirstChild(tostring(player)) then
                return resolve(Players[tostring(player)].Character or Players[tostring(player)]:GetPropertyChangedSignal("Character"):Wait())
            end
            return reject("Could not find a Character that the given username belongs to", tostring(player))
        else
            return reject("Could not coerce " .. typeof(player) .. " to Character")
        end
    end)
end

return funcs
