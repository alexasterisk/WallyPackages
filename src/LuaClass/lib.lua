type Class = {
    constructor: (Class, ...any) -> Class,
    [string]: any
}

local function bindSelf(self: Class, method: (Class, ...any) -> any): (Class?, ...any) -> any
    return function(firstArg: Class?, ...: any): any
        if firstArg == self then
            return method(self, ...)
        else
            return method(self, firstArg, ...)
        end
    end
end

-- allows classes to be immediately be used anywhere
local globalIndex: {[string]: Class} = {}

return function(publishToGlobalIndex: boolean?)
    local index: {[string]: Class} = {}

    local function _findIndex(className: string): Class
        return index[className] or globalIndex[className]
    end

    local function construct(final: Class, ...: any): Class
        local this = {}
        local mt = {}
        for key, value in pairs(final) do
            if key == "constructor" then
                continue
            elseif string.match(key, "^____Metamethod%$") then
                mt["__" .. string.split(key, "$")[2]] = value
            elseif type(value) == "function" then
                this[key] = bindSelf(this, value)
            else
                this[key] = value
            end
        end
        this = final.constructor(this, ...)
        return setmetatable(this, mt)
    end

    local function actualClass(className: string, data: Class, extension: Class?): Class
        local final: Class = extension or data
        if extension ~= nil then
            for key, value in pairs(data) do
                final[key] = value
            end
        end

        if not (final["constructor"] or final["____Constructor"]) or not type(final.constructor) == "function" then
            error("[CLASS] No constructor was given with class \"" .. className .. "\"!")
        end

		if publishToGlobalIndex then
            globalIndex[className] = final
        end
        index[className] = final
        return final
    end

    local function extends(className: string): string
        return className -- dont ask, using extends just looks cooler than class "Thing" ["Thing2"] {}
    end

    local function meta(methodName: string)
        return "____Metamethod$" .. methodName
    end

    local class = {}
    function class:__call(className: string): any
        local existing: Class? = _findIndex(className)
        if existing then
            error("[CLASS] \"" .. className .. "\" is already a defined class!")
        end

        local mt = {}

        -- regular class
        function mt:__call(data: Class): Class
            return actualClass(className, data)
        end

        -- extended class
        function mt:__index(extension: string): Class
            existing = _findIndex(extension)
            if not existing then
                error("[CLASS] \"" .. extension .. "\" is not a defined class, therefore it cannot be used as an extension!")
            end

            return function(data: Class): Class
                return actualClass(className, data, existing :: Class)
            end
        end

        return setmetatable({}, mt)
    end

    -- imported class
    function class:__newindex(className: string, importedClass: Class): Class
        local existing: Class? = _findIndex(className)
        if existing then
            error("[CLASS] \"" .. className .. "\" is already a defined class and can't be overwritten!")
        end

        if not type(importedClass) == "table" or not importedClass["constructor"] then
            error("[CLASS] Error importing class \"" .. className .. "\" as arg2 was a " .. typeof(importedClass) .. " and missing a .constructor method")
        end

        if publishToGlobalIndex then
            globalIndex[className] = importedClass
        end
        index[className] = importedClass
        return importedClass
    end

    class = setmetatable({}, class)

    local function new(classData: string | Class): (...any) -> any
        if type(classData) == "table" and classData["constructor"] then
            return function(...: any): any
                return construct(classData :: Class, ...)
            end
        end

        local found: Class? = _findIndex(classData :: string)
        if not found then
            error("[CLASS] \"" .. classData :: string .. "\" is not a defined class!")
        end

        return function(...: any): any
            return construct(found :: Class, ...)
        end
    end

    return new, class, extends, meta
end