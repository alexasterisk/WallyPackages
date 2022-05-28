local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService = game:GetService("RunService")

local WallyImports = ReplicatedStorage:FindFirstChild("Packages")
local WallyDevImports = ReplicatedStorage:FindFirstChild("DevPackages")

local isClient = RunService:IsClient()
local isServer = RunService:IsServer()
local WallyServerImports
local PlayerScripts

if isClient then
    PlayerScripts = game.Players.LocalPlayer.PlayerScripts
end

if isServer then
    WallyServerImports = ServerScriptService:FindFirstChild("Packages")
end

local function _getNextLocation(path: string, inst: Instance)
    local newPath: string? = string.match(path, "%w+")
    if newPath == nil or string.match(path, "^/") then
        error("[IMPORT] Unhandled error occured with resolving path \"" .. path .. "\" while indexing > " .. inst:GetFullName() .. " <")
    end
    local newInst: Instance? = inst:FindFirstChild(newPath)
    if not newInst then
        newInst = inst:FindFirstChild(string.sub(newPath, 1, 1):upper() .. string.sub(newPath, 2))
        if not newInst then
            error("[IMPORT] \"" .. newPath .. "\" is not parented to " .. inst:GetFullName() .. " <")
        end
    end
    if string.match(path, "/") then
        path = string.sub(path, string.len(newPath) + 2)
        return path, newInst, false
    else
        return path, newInst, true
    end
end

local directories = {
    ["@wally"] = {
        WallyImports,
        function(path)
            if not WallyImports then
                error("[IMPORT] Cannot use \"@wally/\" as a search location\nTo fix this: direct shared wally packages into ReplicatedStorage.Packages\n> " .. path .. " <")
            end
        end
    },

    ["@wally-dev"] = {
        WallyDevImports,
        function(path)
            if not WallyDevImports then
                error("[IMPORT] Cannot use \"@wally-dev/\" as a search location\nTo fix this: direct dev wally packages into ReplicatedStorage.DevPackages\n> " .. path .. " <")
            end
        end
    },

    ["@wally-server"] = {
        WallyServerImports,
        function(path)
            if not WallyServerImports then
                error("[IMPORT] Cannot use \"@wally-server/\" as a search location\nTo fix this: direct server wally packages into ServerScriptService.Packages\n> " .. path .. " <")
            end
        end
    },

    shared = { ReplicatedStorage },

    client = {
        PlayerScripts,
        function(path)
            if not isClient then
                error("[IMPORT] Importing with client is only permitted on the Client!\n> " .. path .. " <")
            end
        end
    },

    server = {
        ServerScriptService,
        function(path)
            if not isServer then
                error("[IMPORT] Importing with server is only permitted on the Server!\n> " .. path .. " <")
            end
        end
    }
}

local function _getDirectory(path: string)
    local name = string.split(path, "/")[1]
    local path_after = string.sub(path, #name + 2)
    local dir = directories[name]
    if not dir then
        error("[IMPORT] Received an invalid import of > " .. path .. " <")
    end
    if dir[2] then
        dir[2](path)
    end
    return path_after, dir[1]
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
    path, inst = _getDirectory(path)

    local newPath, newInst, finished = _getNextLocation(path, inst)
    while not finished do
        newPath, newInst, finished = _getNextLocation(newPath, newInst)
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