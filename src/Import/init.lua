local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")
local Promise = require(script.Parent.Promise)

local WallyImports = ReplicatedStorage:FindFirstChild("Packages")

local isClient = RunService:IsClient()
local isServer = RunService:IsServer()
local PlayerScripts

if not RunService:IsStudio() and isClient then
    PlayerScripts = game.Players.LocalPlayer.PlayerScripts
end

local function _getNextLocation(path: string, inst: Instance)
    return Promise.new(function(resolve, reject)
        local newPath: string? = string.match(path, "%w+")
        if newPath == nil or string.match(path, "^/") then
            return reject("[IMPORT] Unhandled error occured with resolving path \"" .. path .. "\" while indexing > " .. inst:GetFullName() .. " <")
        end
        local newInst: Instance? = inst:FindFirstChild(newPath)
        if not newInst then
            newInst = inst:FindFirstChild(string.sub(newPath, 1, 1):upper() .. string.sub(newPath, 2))
            if not newInst then
                return reject("[IMPORT] \"" .. newPath .. "\" is not parented to " .. inst:GetFullName() .. " <")
            end
        end
        if string.match(path, "/") then
            path = string.sub(path, string.len(newPath) + 2)
            return resolve(path, newInst, false)
        else
            return resolve(path, newInst, true)
        end
    end)
end

--[=[
    @class Import
]=]
local Import = {}

--[=[
    Setting `__index` to `script` is important for when you need to use dot reference like `import "./promise"`.
    @param selfReference Instance -- The Instance for your path reference
    @return Import
]=]
function Import:__index(selfReference: Instance)
    local mt = { _ref = selfReference }
    return setmetatable(mt, Import)
end

--[=[
    This is the main import method. This allows you to import modules.
    @param path string -- The directory-esque path to what you're importing.
    @return Instance | table | any
]=]
function Import:__call(path: string)
    local function _checkIfselfReference()
        if not self._ref or typeof(self._ref) ~= "Instance" then
            error("[IMPORT] Cannot use dot reference as it was not defined when required\nTo fix this: use require(import) [script]\n> " .. path .. " <")
        end
    end

    local unapprovedCharacter = string.match(path, "(?!%w+)[%./]")
    if unapprovedCharacter then -- found unapproved characters
        error("[IMPORT] Immediate error thrown for unapproved character(s) in import \"" .. unapprovedCharacter .. "\"\n> " .. path .. " <")
    end
    local inst: Instance
    if string.match(path, "@wally/") then
        if not WallyImports then
            error("[IMPORT] Cannot use \"@wally/\" as a search location\nTo fix this: direct shared wally packages into ReplicatedStorage.Packages\n> " .. path .. " <")
        end
        path = string.sub(path, 8)
        inst = WallyImports
    elseif string.match(path, "^%./") then
        _checkIfselfReference()
        path = string.sub(path, 3)
        inst = self._ref
    elseif string.match(path, "^%.%./") then
        _checkIfselfReference()
        path = string.sub(path, 4)
        inst = self._ref.Parent
    elseif string.match(path, "^shared/") then
        path = string.sub(path, 8)
        inst = ReplicatedStorage
    elseif string.match(path, "^client/") then
        if not isClient then
            error("[IMPORT] Importing with client is only permitted on the Client!\n> " .. path .. " <")
        end
        path = string.sub(path, 8)
        inst = PlayerScripts
    elseif string.match(path, "^server/") then
        if not isServer then
            error("[IMPORT] Importing with server is only permitted on the Server!\n> " .. path .. " <")
        end
        path = string.sub(path, 8)
        inst = ServerScriptService
    else
        error("[IMPORT] Received an invalid import of > " .. path .. " <")
    end

    local success, newPath, newInst, finished = _getNextLocation(path, inst):await()
    if not success then
        error(newPath)
    end
    while not finished do
        success, newPath, newInst, finished = _getNextLocation(newPath, newInst):await()
        if not success then
            error(newPath)
        end
        task.wait()
    end

    if newInst ~= nil then
        if newInst:IsA("ModuleScript") then
            local module = require(newInst)
            if type(module) == "table" then
                module.importBackRef = newInst -- allows usage of the modulescript as an Instance class
            elseif type(module) == "function" then
                return setmetatable({ importBackRef = newInst }, {
                    __call = function(_, ...) return module(...) end,
                    __index = newInst,
                    __newindex = newInst
                })
            end
            return module
        else
            return newInst
        end
    end
end

return setmetatable({}, Import)