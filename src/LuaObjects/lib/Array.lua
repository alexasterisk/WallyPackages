local Map = require(script.Parent.Map)
local util = require(script.Parent.Parent.util)

--- @class Array
local Array = {

    --- Reflects the number of elements in an array.
    length = 0,

    _maxLength = -1,
    _table = {},
    __type = "Array"
}

--- Creates a new `Array` object.
--- @param arg? number | IterableObject -- The initial value to use when constructing.
--- - If a number is supplied, this will set the max length to this number.
--- - If a table is supplied, this will "deep copy" the table into this `Array`.
--- @return Array
function Array.new(arg: (number | util.table | string)?)
    if type(arg) == "string" then
        arg = util.iterateString(arg)
    end
    local array = setmetatable({}, Array)
    if type(arg) == "number" then
        array._table = table.create(arg)
        array._maxLength = arg
    elseif type(arg) == "table" then
        if arg["__type"] == "Array" then
            array._table = util.deepCopy(arg._table)
        elseif arg["__type"] == "Map" then
            for k, v in arg._table do
                table.insert(array._table, {k, util.deepCopy(v)})
            end
        else
            array._table = util.deepCopy(arg)
        end
        array.length = #array._table
    end
    return array
end

--- Creates a new `Array` instance from an array-like object or iterable object.
--- @param arrayLike any -- An iterable or array-like object to convert to an array.
--- @param mapFn? fun(element: any, index: any, thisArg: any) -- Map function to call on every element of the array.
--- @param thisArg? any -- Value to use as `self` when executing `mapFn`.
--- @return Array
function Array.from(arrayLike, mapFn: (any?, any?, any?) -> any, thisArg: any?)
    local array = Array.new(arrayLike)
    return array:map(mapFn, thisArg)
end

--- Returns `true` if the argument is an array, or `false` otherwise.
--- @param value Array | any -- The value to be checked.
--- @return boolean
function Array.isArray(value): boolean
    return type(value) == "table" and value["__type"] == "Array"
end

--- Creates a new `Array` instance with a variable number of arguments, regardless of number or type of the arguments.
--- @vararg any -- Elements used to create the array.
--- @return Array
function Array.of(...)
    local array = Array.new()
    for _, v in {...} do
        array:push(v)
    end
    return array
end

--- Returns the array item at the given index. Accepts negative integers, which count back from the last item.
--- @param index number -- The index (position) of the array element to be returned.
--- - This supports relative indexing from the end of the array when passed a negative index.
--- @return any?
function Array:at(index: number): any?
    return self._table[index]
end

--- Fills all the elements on an array from a start index to an end index with a static value.
--- @param value any -- Value to fill the array with. (Note all elements in the array will be this exact value.)
--- @param start? number -- Start index (inclusive), default `0`.
--- @param endN? number -- End index (inclusive), default `array.length`.
--- @return Array
function Array:fill(value, start: number?, endN: number?)
    if start < 0 then
        start = self.length + start
    end
    if endN < 0 then
        endN = math.clamp(self.length + endN, 1, self.length)
    end
    for i = start or 0, endN or self.length do
        self._table[i] = value
    end
    return self
end

--- Returns the value of the first element in the array that satisfies the provided testing function, or `nil` if no appropriate element is found.
--- @param callbackFn fun(element: any, index: number, array: Array) -- Function to execute on each value in the array. The function is called with the following arguments:
--- - `element` -- The current element in the array.
--- - `index` -- The index (position) of the current element in the array.
--- - `array` -- The array that `find` was called on.
--- - The callback must return a truthy value to indicate a matching element has been found.
--- @param thisArg? any -- Object to use as `self` inside `callbackFn`.
--- @return any?
function Array:find(callbackFn: (any?, number, any) -> any, thisArg: any?): any?
    for k, v in self._table do
        if callbackFn(v, k, thisArg or self) then
            return v
        end
    end
    return nil
end

--- Returns the index of the last element in the array that satisfies the provided testing function, or `-1` if no appropriate element was found.
--- @param callbackFn fun(element: any, index: number, array: Array) -- A function used to test elements in the array. The function is called with the following arguments:
--- - `element` -- The current element in the array.
--- - `index` -- The index (position) of the current element in the array.
--- - `array` -- The array that `findLast()` was called on.
--- - The callback must return a truthy value to indicate an appropriate element has been found. The value of this element is returned by `findLast()`.
--- @param thisArg? any -- Object to use as `self` inside `callbackFn`.
--- @return any?
function Array:findLast(callbackFn: (any?, number, any) -> any, thisArg: any?): any?
    for i = #self._table, 1, -1 do
        if callbackFn(self._table[i], i, thisArg or self) then
            return self._table[i]
        end
    end
    return nil
end

--- Groups the elements of an array into a `Map` according to values returned by a test function.
--- @param callbackFn fun(element: any, index: number, array: Array) -- Function to execute on each element in the array. The function is called with the following arguments:
--- - `element` -- The current element in the array.
--- - `index` -- The index (position) of the current element in the array.
--- - `array` -- The array that `groupToMap()` was called on.
--- - The value (object or primitive) returned from the callback indicates the group of the current element.
--- @param thisArg? any -- Object to use as `self` inside `callbackFn`.
--- @return Map
function Array:groupToMap(callbackFn: (any?, number, any) -> any, thisArg: any?)
    local map = Map.new()
    for k, v in self._table do
        if callbackFn(v, k, thisArg or self) then
            if #v == 2 then
                map:set(v[1], v[2])
            else
                map:set(k, v)
            end
        end
    end
    return map
end

--- Returns a string representation of an array.
--- @return string
function Array:toString(): string
    return util.stringify(self._table)
end

--- Removes the last element from an array and returns it.
--- If the array is empty, nil is returned and the array is not modified.
--- @return any | nil
function Array:pop(): any?
    if #self._table == 0 then
        return nil
    end
    local last = self._table[#self._table]
    table.remove(self._table, #self._table)
    self.length = -1
    return last
end

--- Appends new elements to the end of an array, and returns the new length of the array.
--- @vararg any -- New elements to add to the array.
--- @return number
function Array:push(...: any): number
    for _, v in {...} do
        table.insert(self._table, v)
        self.length += 1
    end
    return self.length
end

--- Returns a new array that is the calling array joined with other array(s) and/or value(s).
--- @vararg Array | any -- Arrays and/or values to concatenate into a new array.
--- - If all `valueN` parameters are omitted, `concat` returns a "shallow copy" of the existing array on which it is called.
--- @return Array
function Array:concat(...)
    local copy = util.shallowCopy(self._table)
    for _, v in {...} do
        if type(v) == "table" and v["_table"] then
            for _, v2 in v._table do
                table.insert(copy, v2)
            end
        else
            table.insert(copy, v)
        end
    end
    return Array.new(copy)
end

--- Copies a sequence of array elements within an array.
--- @param target number -- If target is negative, it is treated as `length+target` where length is the length of the array.
--- @param start number -- If start is negative, it is treated as `length+start`.
--- @param finish? number -- If finish is negative, it is treated as `length+finish`. If not specified, length of the self object is used as its default value.
--- @return Array
function Array:copyWithin(target: number, start: number, finish: number?)
    local copy = util.shallowCopy(self._table)
    target = if target < 0 then #copy + target + 1 else target
    start = if start < 0 then #copy + start + 1 else start
    finish = finish or #copy
    finish = if finish < 0 then #copy + (finish or self.length) + 1 else finish
    local counter = target
    for i = start, finish or self.length do
        self._table[counter] = copy[i]
        counter += 1
    end
    return self
end

-- Adds all the elements of an array into a string, separated by the specified separator string.
--- @param separator? string -- A string used to separate one element of the array from the next in the resulting string.
--- - If omitted, the array elements are separated with a comma.
--- @return string
function Array:join(separator: string?): string
    separator = separator or ","
    return table.concat(self._table, separator)
end

--- Reverses the elements in an array in place.
--- This method mutates the array and returns a reference to the same array.
--- @return Array
function Array:reverse()
    local sorted = {}
    for i = #self._table, 1, -1 do
        table.insert(sorted, self._table[i])
    end
    self._table = sorted
    return self
end

--- Returns a copy of a section of an array.
--- For both start and end, a negative index can be used to indicate an offset from the end of the array.
--- For example, -2 refers to the second to last element of the array.
--- @param start? number -- The beginning index of the specified portion of the array.
--- - If start is nil, then the slice begins at index 1.
--- @param finish? number -- The end index of the specified portion of the array. This is exclusive of the element at the index "end".
--- - If finish is nil, then the slice extends to the end of the array.
--- @return Array
function Array:slice(start: number?, finish: number?)
    start = start or 1
    finish = finish or #self._table
    local copy = Array.new(self._table)
    if start < 0 then
        for _ = #self._table, #self._table + start + 2, -1 do
            copy:pop()
        end
        for _ = 1, finish - 1 do
            copy:shift()
        end
    else
        for _ = 1, start - 1 do
            copy:shift()
        end
        for _ = #self._table, finish + 1, -1 do
            copy:pop()
        end
    end
    return copy
end

--- Sorts an array in place.
--- This method mutates the array and returns a reference to the same array.
--- @param compareFn? fun(a: any, b: any) -- Function used to determine the order of the elements. It is expected to return false if the first argument is less than the second argument and a true otherwise.
--- - If omitted, the elements are sorted in ascending, ASCII character order.
--- @return Array
function Array:sort(compareFn: ((any, any) -> boolean)?)
    table.sort(self._table, compareFn or function(a, b)
        return a < b
    end)
    return self._table
end

--- Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.
--- @param start number -- The one-based location in the array from which to start removing elements.
--- @param deleteCount number -- The number of elements to remove.
--- @vararg any -- Elements to insert into the array in place of the deleted elements.
--- @return Array
function Array:splice(start: number, deleteCount: number, ...)
    local items = {...}
    local copy = {}
    local shifted = 0
    local counter = 1
    for i = start, deleteCount do
        local loc = self._table[i - shifted]
        if loc then
            table.insert(copy, loc)
            local replacement = items[counter]
            if replacement ~= nil then
                self._table[i - shifted] = replacement
            else
                table.remove(self._table, i - shifted)
                shifted += 1
                self.length -= 1
            end
        end
        counter += 1
    end
    return Array.new(copy)
end

-- Inserts new elements at the start of an array, and returns the new length of the array.
--- @vararg any -- Elements to inster at the start of the array.
--- @return Array
function Array:unshift(...)
    local args = {...}
    for i = #args, 1, -1 do
        table.insert(self._table, 1, args[i])
        self.length += 1
    end
    return self.length
end

--- Returns the index of the first occurence of a value in an array, or nil if it is not present.
--- @param searchElement any -- The value to locate in the array.
--- @param fromIndex? number -- The array index at which to begin the search.
--- - If fromIndex is omitted, the search starts at index 1.
--- @return number?
function Array:indexOf(searchElement, fromIndex: number?): number?
    return table.find(self._table, searchElement, fromIndex)
end

--- Returns the index of the last occurence of a value in an array, or nil if it is not present.
--- @param searchElement any -- The value to locate in the array.
--- @param fromIndex? number -- The array index at which to begin the search.
--- - If fromIndex is omitted, the search starts at the last index in the array.
--- @return number?
function Array:lastIndexOf(searchElement, fromIndex: number?): number?
    for i = fromIndex or #self._table, 1, -1 do
        if self._table[i] == searchElement then
            return i
        end
    end
    return nil
end

--- Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.
--- @param depth? number -- The maximum recursion depth
--- @return Array
function Array:flat(depth: number?)
    local copy = util.depthCopy(self._table, depth)
    return Array.new(copy)
end

--- Determines whether all the members of an array satisfy the specified test.
--- @param predicate fun(element: any, index: number, array: Array) -- A function that accepts up to three arguments.
--- - `element` -- The current element being processed in the array.
--- - `index` -- The index of the current element being processed in the array.
--- - `array` -- The array `every` was called upon.
--- - The every method calls the predicate function for each element in the array until the predicate returns a value which is coercible to the Boolean value false, or until the end of the array.
--- @param thisArg? any -- An object to which the self keyword can refer in the predicate function.
--- - If thisArg is omitted, nil will be used as the self value.
--- @return boolean
function Array:every(predicate: (any, number, any) -> any, thisArg: any?): boolean
    for k, v in self._table do
        if not predicate(v, k, thisArg) then
            return false
        end
    end
    return true
end

--- Determines whether the specified callback function returns true for any element of an array.
--- @param predicate fun(element: any, index: number, array: Array) -- A function that accepts up to three arguments.
--- - `element` -- The current element being processed in the array.
--- - `index` -- The index of the current element being processed in the array.
--- - `array` -- The array `some` was called upon.
--- - The every method calls the predicate function for each element in the array until the predicate returns a value which is coercible to the Boolean value true, or until the end of the array.
--- @param thisArg? any -- An object to which the self keyword can refer in the predicate function.
--- - If thisArg is omitted, nil will be used as the self value.
--- @return boolean
function Array:some(predicate: (any, number, any) -> any, thisArg: any?): boolean
    for k, v in self._table do
        if predicate(v, k, thisArg) then
            return true
        end
    end
    return false
end

--- Performs the specified action for each element in an array.
--- @param callbackFn fun(element: any, index: number, array: Array) -- A function that accepts up to three arguments.
--- - `element` -- The current element being processed in the array.
--- - `index` -- The index of the current element being processed in the array.
--- - `array` -- The array `forEach` was called upon.
--- - forEach calls the callbackFn function one time for each element in the array.
--- @param thisArg? any -- An object to which the self keyword can refer in the callbackFn function.
--- - If thisArg is omitted, nil will be used as the self keyword.
--- @return nil
function Array:forEach(callbackFn: (any, number, any) -> any, thisArg: any?)
    for k, v in self._table do
        callbackFn(v, k, thisArg)
    end
end

--- Calls a defined callback function on each element of an array and returns an array that contains the results.
--- @param callbackFn fun(element: any, index: number, array: Array) -- A function that accepts up to three arguments.
--- - `element` -- The current element being processed in the array.
--- - `index` -- The index of the current element being processed in the array.
--- - `array` -- The array `map` was called upon.
--- - The map method calls the callbackFn function one time for each element in the array.
--- @param thisArg? any -- An object to which the self keyword can refer in the callbackFn function.
--- - If thisArg is omitted, nil will be used as the self keyword.
--- @return Array
function Array:map(callbackFn: (any, number, any) -> any, thisArg: any?)
    local copy = {}
    for k, v in self._table do
        local val = callbackFn(v, k, thisArg)
        if val ~= nil then
            table.insert(copy, val)
        end
    end
    return Array.new(copy)
end

--- Calls a defined callback function on each element of an array. Then, flattens the result into a new array.
--- This is identical to a map followed by flat with depth 1.
--- @param callback fun(element: any, index: number, array: Array) -- A function that accepts up to three arguments.
--- - `element` -- The current element being processed in the array.
--- - `index` -- The index of the current element being processed in the array.
--- - `array` -- The array `every` was called upon.
--- - The flatMap method calls the callback function one time for each element in the array.
--- @param thisArg? any -- An object to which the self keyword can refer in the callback function.
--- - If thisArg is omitted, nil will be used as the self keyword.
--- @return Array
function Array:flatMap(callback: (any, number, any) -> any, thisArg: any?)
    local mapped = self:map(callback, thisArg)
    return mapped:flat(1)
end

--- Returns the elements of an array that meet the condition specified in a predicate function.
--- @param predicate fun(element: any, index: number, array: Array) -- A function that accepts up to three arguments.
--- - `element` -- The current element being processed in the array.
--- - `index` -- The index of the current element being processed in the array.
--- - `array` -- The array `filter` was called upon.
--- - The filter method calls the predicate function one time for each element in the array.
--- @param thisArg? any -- An object to which the self keyword can refer in the predicate function.
--- - If thisArg is omitted, nil will be used as the self keyword.
--- @return Array
function Array:filter(predicate: (any, number, any) -> any, thisArg: any?)
    local copy = {}
    for k, v in self._table do
        if predicate(v, k, thisArg) then
            table.insert(copy, v)
        end
    end
    return Array.new(copy)
end

--- Calls the specified callback function for all the elements in an array.
--- - The return value of the callbackFn function is the accumulated result, and is provided in the next call to the callbackFn function.
--- @param callbackFn fun(element: any, index: number, array: Array) -- A function that accepts up to three arguments.
--- - `previousValue` -- The value resulting from the previous call to `callbackFn`. On first call, `initialValue` if specified, otherwise the value of `array[0]`.
--- - `currentValue` -- The value of the current index. On first call, the value of `index[0]` if an `initialValue` was specified, otherwise the value of `array[1]`.
--- - `currentIndex` -- The index position of `currentValue` in the array. On first call, `0` if `initialValue` was specified, otherwise `1`.
--- - `array` -- The array being traversed.
--- - The reduce method calls the callbackFn function one time for each element in the array.
--- @param initialValue? any -- If initialValue is specified, it is used as the initial value to start the accumulation.
--- - If omitted, the first call to the callbackFn function provides this value as an argument instead of an array value.
--- @return Array
function Array:reduce(callbackFn: (any, any, number?, any?) -> any, initialValue: any?)
    for k, v in self._table do
        initialValue = callbackFn(initialValue or nil, v, k, self)
    end
    return initialValue
end

--- Calls the specified callback function for all the elements in the array, in descending order.
--- - The return value of the callbackFn function is the accumulated result, and is provided in the next call to the callbackFn function.
--- @param callbackFn fun(element: any, index: number, array: Array) -- A function that accepts up to three arguments.
--- - `previousValue` -- The value resulting from the previous call to `callbackFn`. On first call, `initialValue` if specified, otherwise the value of `array[0]`.
--- - `currentValue` -- The value of the current index. On first call, the value of `index[0]` if an `initialValue` was specified, otherwise the value of `array[1]`.
--- - `currentIndex` -- The index position of `currentValue` in the array. On first call, `0` if `initialValue` was specified, otherwise `1`.
--- - `array` -- The array being traversed.--- - The reduceRight method calls the callbackFn function one time for each element in the array.
--- @param initialValue? any -- If initialValue is specified, it is used as the initial value to start the accumulation.
--- - If omitted, the first call to the callbackFn function provides this value as an argument instead of an array value.
--- @return Array
function Array:reduceRight(callbackFn: (any, any, number?, any?) -> any, initialValue: any?)
    for i = #self._table, 1, -1 do
        initialValue = callbackFn(initialValue or nil, self._table[i], i, self)
    end
    return initialValue
end

--- Determines whether an array includes a certain element, returning true or false as appropriate.
--- @param searchElement any -- The element to search for.
--- @param fromIndex? number -- The position in this array at which to beign searching for searchElement.
--- @return boolean
function Array:includes(searchElement, fromIndex: number?): boolean
    return self:indexOf(searchElement, fromIndex) ~= nil
end

function Array:__index(i)
    if self[i] then
        return self[i]
    else
        return self._table[i]
    end
end

function Array:__newindex()
    error("[ARRAY] Cannot use \"array[key] = value\" method on an array!")
end

Array.__call = Array.new
return Array