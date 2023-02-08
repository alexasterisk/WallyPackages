local util = require(script.Parent.Parent.util)

--- @class Map

local Map = {

    --- Returns the number of key/value pairs in the `Map` object.
    size = 0,

    _table = {},
    __type = "Map"
}

--- Creates a new `Map` object.
--- @param arg? table | Array -- The initial value to use when constructing
--- - If a table is supplied, this will "deep copy" the table into this `Map`.
--- - Passing an `Array` with `key-value` pairs is also acceptable.
--- @return Map
function Map.new(arg: (util.table<any, any>)?)
    local map = setmetatable({}, Map)
    if type(arg) == "table" then
        if arg["__type"] == "Array" then
            if not arg:every(function(v)
                return #v == 2
            end) then
                error("[MAP] Got an Array and expected a key-value Array to be passed!")
            end
            arg:forEach(function(v)
                map._table[v[1]] = util.deepCopy(v[2])
            end)
        else
            map._table = util.deepCopy(arg)
        end
        map.size = #map._table
    end
    return map
end

--- Removes all key-value pairs from the `Map` object.
function Map:clear()
    self._table = {}
    self.size = 0
end

--- Returns `true` if an element in the `Map` object existed and has been removed, or `false` if the element does not exist.
--- `map.has(key)` will return `false` afterwards.
--- @param key any -- The key of the element to remove from the `Map` object.
--- @return boolean
function Map:delete(key): boolean
    if self:has(key) then
        self._table[key] = nil
        self.size -= 1
        return true
    end
    return false
end

--- Returns the value associated to the passed key, or `nil` if there is none.
--- @param key any -- The key of the element to return from the `Map` object.
--- @return any?
function Map:get(key): any?
    return self._table[key]
end

--- Returns a boolean indicating whether a value has been associated with the passed key in the `Map` object or not.
--- @param key any -- The key of the element to test for presence in the `Map` object.
--- @return boolean
function Map:has(key): boolean
    return self._table[key] ~= nil
end

--- Sets the value for the passed key in the `Map` object. Returns the `Map` object.
--- @param key any -- The key of the element to add to the `Map` object. The key may be of any type.
--- @param value any -- The value of the element to add to the `Map` object. The value may be of any type
--- @return Map
function Map:set(key, value)
    if not self:has(key) and value ~= nil then
        self.size += 1
    end
    self._table[key] = value
    return self
end

--- Calls `callbackFn` once for each key-value pair present in the `Map` object, in insertion order.
--- If `thisArg` parameter is provided to `forEach`, it will be used as the `self` value for each callback.
--- @param callbackFn fun(value: any, key: any, map: any) -- Function to execute for each entry in the map. It takes the following arguments:
--- - `value` (optional) -- Value of each iteration.
--- - `key` (optional) -- Key of each iteration.
--- - `map` (optional) -- The `Map` being iterated.
--- @param thisArg? any -- Value to use as `self` when excuting `callback`.
function Map:forEach(callbackFn: (any?, any?, any?) -> nil, thisArg: any?)
    for k, v in self._table do
        callbackFn(v, k, thisArg or self)
    end
end

function Map:__index(i)
    if self[i] then
        return self[i]
    else
        return self:get(i)
    end
end

function Map:__newindex(i, v)
    return self:set(i, v)
end

return Map