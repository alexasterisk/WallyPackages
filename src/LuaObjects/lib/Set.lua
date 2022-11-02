local util = require(script.Parent.Parent.Parent.util)

--- @class Set

--- @prop size number
--- @readonly
--- @within Set
--- Returns the number of values in the `Set` object.

--- @prop _table table<any, any>
--- @private
--- @within Set

--- @prop __type "Map"
--- @private
--- @within Set

local Set = {

    --- Returns the number of values in the `Set` object.
    size = 0,

    _table = {},
    __type = "Set"
}

--- Creates a new `Set` object.
--- @param iterable? IterableObject -- If an iterable obejct is passed, all of its elements will be added to the new `Set`.
--- - If you don't specify this parameter, or its value is `null`, the new `Set` is empty.
function Set.new(iterable)
    local set = setmetatable({}, Set)
    if type(iterable) == "string" then
        iterable = util.iterateString(iterable)
    end
    if type(iterable) == "table" then
        if iterable["__type"] == "Array" then
            local copy = util.deepCopy(iterable._table)
            set._table[copy] = copy
        elseif iterable["__type"] == "Map" then
            for _, v in iterable._table do
                set._table[v] = v
            end
        else
            local copy = util.deepCopy(iterable)
            set._table[copy] = copy
        end
    end
    set.size = #set._table
    return set
end

--- Inserts a new element with a specified value in to a `Set` object, if there isn't an element with the same value already in the `Set`.
--- @param value any -- The value of the element to add to the `Set` object.
--- @return Set
function Set:add(value)
    if not self:has(value) then
        self._table[value] = value
        self.size += 1
    end
    return self
end

--- Removes all elements from the `Set` object.
function Set:clear()
    self._table = {}
    self.size = 0
end

--- Removes the element associated to the `value` and returns a boolean asserting whether an element was successfully removed or not.
--- - `Set.has(value)` will return `false` afterwards.
--- @param value any -- The value to remove from `Set`.
--- @return boolean
function Set:delete(value): boolean
    if self:has(value) then
        self._table[value] = nil
        self.size -= 1
        return true
    end
    return false
end

--- Returns a boolean asserting whether an element is present with the given value in the `Set` object or not.
--- @param value any -- The value to test for presence in the `Set` object.
--- @return boolean
function Set:has(value): boolean
    return self._table[value] ~= nil
end

--- Calls `callbackFn` once for each value present in the `Set` object, in insertion order.
--- - If a `thisArg` parameter is provided, it will be used as the `self` value for each invocation of `callbackFn`.
--- @param callback fun(value: any, key: any, set: Set) -- Function to execute for each element, taking three arguments:
--- - `value`, `key` (optional) -- The current element being processed in the `Set`. As there are no keys in `Set`, the value is passed for both arguments.
--- - `set` (optional) -- The `Set` object which `forEach()` was called upon.
--- @param thisArg? any -- Value to use as `self` when executing `callbackFn`.
function Set:forEach(callback: (any?, any?, any?) -> nil, thisArg: any?)
    for _, v in self._table do
        callback(v, v, thisArg or self)
    end
end

function Set:__index(i)
    if self[i] then
        return self[i]
    else
        return self._table[i]
    end
end

Set.__call = Set.new
return Set