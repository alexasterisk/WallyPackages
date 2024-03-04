local server = game:GetService("ServerScriptService")
local shared = game:GetService("ReplicatedStorage")
local run = game:GetService("RunService")

local modules = shared:FindFirstChild("Modules") or shared:FindFirstChild("modules")
local wally = shared:FindFirstChild("Packages") or shared:FindFirstChild("packages")
local wallyDev = shared:FindFirstChild("DevPackages") or shared:FindFirstChild("devPackages")
local wallyServer
local client

local logger = require(script.Parent.Parent.Logger) "import"

local IS_CLIENT = run:IsClient()
local IS_SERVER = run:IsServer()

if IS_CLIENT then
    local player = game.Players.LocalPlayer or game.Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    client = player.PlayerScripts
end

if IS_SERVER then
    wallyServer = server:FindFirstChild("Packages") or server:FindFirstChild("packages")
end

local dirs = {
    ["modules"] = {
        modules,
        function (path)
            if not modules then
                logger.err('Could not find "ReplicatedStorage.Modules"!', path)
            end
        end
    },

    ["@wally"] = {
        wally,
        function (path)
            if not wally then
                logger.err('Could not find "ReplicatedStorage.Packages"!', path)
            end
        end
    },

    ["@wally-server"] = {
        wallyServer,
        function (path)
            if not IS_SERVER then
                logger.err('Accessing Wally server imports is only available on the Server!', path)
            elseif not wallyServer then
                logger.err('Could not find "ServerScriptService.Packages"!', path)
            end
        end
    },

    ["@wally-dev"] = {
        wallyDev,
        function (path)
            if not wallyDev then
                logger.err('Could not find "ReplicatedStorage.DevPackages"!', path)
            end
        end
    },

    ["shared"] = {
        shared
    },

    ["client"] = {
        client,
        function (path)
            if IS_SERVER then
                logger.err('Accessing PlayerScripts is only available on the Client!', path)
            end
        end
    },

    ["server"] = {
        server,
        function (path)
            if IS_SERVER then
                logger.err('Accessing ServerScriptService is only available on the Server!', path)
            end
        end
    }
}

dirs["@pkgs"] = dirs["@wally"]
dirs["@spkgs"] = dirs["@wally-server"]
dirs["@dpkgs"] = dirs["@wally-dev"]

return dirs
