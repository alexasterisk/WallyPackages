local logger = require(script.Parent.Logger) "import"
local dirs = require(script.dirs)

local cache = {}

local function getCached(path: string): any?
    if cache[path] then
        return cache[path]
    end
    return nil
end

local function resolvePath(inst: Instance, path: string, initialPath: string, isFirst: boolean?): {Instance | string | boolean}
    local function dotReference()
        if not inst then
            logger.err("Caught dot reference when the value of dir is nil", initialPath)
        end
    end

    local name = string.split(path, "/")[1]
    local newPath = string.sub(path, #name + 2)
    local newInst

    if name == "." then
        dotReference()
        newInst = inst
    elseif name == ".." then
        dotReference()
        newInst = inst.Parent
    elseif isFirst then
        local data = dirs[name]
        if not data then
            dirs.modules[2](path)
            data = dirs.modules[1]:FindFirstChild(name)
            if not data then
                data = dirs.modules[1]:FindFirstChild(string.gsub(name, "^%l", string.lower))
                if not data then
                    logger.errf('Could not find "{name}" in {parent}', { name, inst:GetFullName() }, initialPath)
                end
            end
        else
            data[2](path)
            newInst = data[1]
        end
        cache[path] = false
    else
        newInst = inst:FindFirstChild(name)
        if not newInst then
            logger.errf('Could not find "{name}" in {parent}', { name, inst:GetFullName() }, initialPath)
        end
    end

    if string.len(newPath) > 0 then
        return {newInst, newPath, false}
    end
    return {newInst, newPath, true}
end

local function init(dir: Instance?, path: string, initialPath: string): any
    if string.match(path, "(?!^@{1,})[^%w+/?]") then
        logger.err("Immediate error thrown for illegal characters", initialPath)
    end

    local cached = getCached(path)
    if cached ~= nil then
        return cached
    end

    local data = resolvePath(dir, path, initialPath, true)
    while not data[3] do
        data = resolvePath(data[1], data[2], initialPath)
        task.wait()
    end

    local toReturn
    if typeof(data[1]) == "Instance" then
        if data[1]:IsA("ModuleScript") then
            toReturn = require(data[1])
        else
            toReturn = data[1]
        end
    elseif data[1] ~= nil then
        toReturn = data[1]
    end

    if cache[path] == false then
        cache[path] = toReturn
    end

    return toReturn
end

return function(val: Instance | string, val2: string?): (string) -> any | any
    if typeof(val) == "Instance" then
        if val2 then
            return init(val, val2, val2)
        else
            return function(path: string)
                return init(val, path, path)
            end
        end
    elseif type(val) == "string" then
        return init(nil, val, val)
    end
end
