local new, class, _, meta = require(script.Parent.Parent.Parent.LuaClass)()

local function shallowCopy(original: table): table
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

local function deepCopy(original: table, copy: table?): table
	copy = copy or {}
	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = deepCopy(value)
		else
			copy[key] = value
		end
	end
	return copy
end

local function stringify(t: table): string
	local str = ""
	if type(t[1]) == "table" then
		str ..= stringify(t[1])
	else
		str ..= tostring(t[1])
	end
	for index = 2, #t do
		if type(t[index]) == "table" then
			str ..= ("," .. stringify(t[index]))
		else
			str ..= ("," .. tostring(t[index]))
		end
	end
	return str
end

--- @class Array
local array = class "Array" {
	length = 0;
	_maxLength = -1;

	constructor = function(this, arg: (number | table)?)
		if type(arg) == "number" then
			this._table = table.create(arg)
			this._maxLength = arg
		elseif type(arg) == "table" then
			this._table = deepCopy(arg)
			this.length = #this._table
		else
			this._table = {}
		end
		return this
	end,

	--- Returns a string representation of an array.
	--- @return string
	toString = function(this): string
		return stringify(this._table)
	end,

	--- Removes the last element from an array and returns it.
	--- If the array is empty, nil is returned and the array is not modified.
	--- @return any?
	pop = function(this): any?
		if #this._table == 0 then
			return nil
		end
		local last = this._table[#this._table]
		table.remove(this._table, #this._table)
		this.length -= 1
		return last
	end,

	--- Appends new elements to the end of an array, and returns the new length of the array.
	--- @vararg any -- New elements to add to the array.
	--- @return number
	push = function(this, ...: any): number
		for _, value in ipairs({...}) do
			table.insert(this._table, value)
			this.length += 1
		end
		return this.length
	end,

	--- Combines two or more arrays.
	--- This method returns a new array without modifying any existing arrays.
	--- @vararg Array | any -- Additional arrays and/or items to the end of the array.
	--- @return Array
	concat = function(this, ...): any
		local copy = deepCopy(this._table)
		for _, value in ipairs({...}) do
			if type(value) == "table" and value["_table"] then
				for _, value in ipairs(value._table) do
					table.insert(copy, value)
				end
			else
				table.insert(copy, value)
			end
		end
		return new "Array" (copy)
	end,

	--- Returns the this object after copying a section of the array identified by start and end to the same array starting at position target.
	--- @param target number -- If target is negative, it is treated as length+target where length is the length of the array.
	--- @param start number -- If start is negative, it is treated as length+start. If finish is negative, it is treated as length+finish.
	--- @param finish? number -- If not specified, length of the this object is used as its default value.
	--- @return Array
	copyWithin = function(this, target: number, start: number, finish: number?): any
		local copy = shallowCopy(this._table)
		target = if target < 0 then #copy + target + 1 else target
		start = if start < 0 then #copy + target + 1 else start
		finish = finish or #copy
		finish = if finish < 0 then #copy + finish + 1 else finish
		local counter = target
		for index = start, finish do
			this._table[counter] = copy[index]
			counter += 1
		end
		return this
	end,

	--- Adds all the elements of an array into a string, separated by the specified seperator string.
	--- @param separator string -- A string used to separate one element of the array from the next in the resulting string. If omitted, the array elements are separated with a coma.
	--- @return string
	join = function(this, separator: string?): string
		separator = separator or ","
		return table.concat(this._table, separator)
	end,

	--- Reverses the elements in an array in place.
	--- This method mutates the array and returns a reference to the same array.
	--- @return Array
	reverse = function(this): any
		local sorted = {}
		for index = #this._table, 1, -1 do
			table.insert(sorted, this._table[index])
		end
		this._table = sorted
		return this
	end,

	--- Removes the first element from an array and returns it.
	--- If the array is empty, nil is returned and the array is not modified.
	--- @return any?
	shift = function(this): any?
		if #this._table == 0 then
			return nil
		end
		local first = this._table[1]
		table.remove(this._table, 1)
		this.length -= 1
		return first
	end,

	--- Returns a copy of a section of an array.
	--- For both start and end, a negative index can be used to indicate an offset from the end of the array.
	--- For example, -2 refers to the second to last element of the array.
	--- @param start? number -- The beginning index of the specified portion of the array.
	--- If start is nil, then the slice begins at index 0.
	--- @param finish? number -- The end index of the specified portion of the array. This is exclusive of the element at at the index 'end'.
	--- If finish is nil, then the slice extends to the end of the array.
	--- @return Array
	slice = function(this, start: number?, finish: number?): any
		start = if start ~= nil then start else 1
		finish = finish or #this._table
		local copy = new "Array" (this._table)
		if start < 0 then
			for _ = #this._table, #this._table + start + 2, -1 do
				copy.pop()
			end
			for _ = 1, finish - 1 do
				copy.shift()
			end
		else
			for _ = 1, start - 1 do
				copy.shift()
			end
			for _ = #this._table, finish + 1, -1 do
				copy.pop()
			end
		end
		return copy
	end,

	--- Sorts an array in place.
	--- This method mutates the array and returns a reference to the same array.
	--- @param compareFn? function -- Function used to determine the order of the elements. It is expected to return a false if the first argument is less than the second argument and a true otherwise. If omitted, the elements are sorted in ascending, ASCII character order.
	--- @return Array
	sort = function(this, compareFn: ((any, any) -> boolean)?): any
		table.sort(this._table, compareFn or function(a, b)
			return a < b
		end)
		return this
	end,

	--- Removes elements from an array and, if necessary, inserts new elements in their place, returning the deleted elements.
	--- @param start number -- The one-based location in the array from which to start removing elements.
	--- @param deleteCount number -- The number of elements to remove.
	--- @vararg any -- Elements to insert into the array in place of the deleted elements.
	--- @return Array
	splice = function(this, start: number, deleteCount: number, ...: any): any
		local items = {...}
		local copy = {}
		local shifted = 0
		local counter = 1
		for index = start, deleteCount do
			local loc = this._table[index - shifted]
			if loc then
				table.insert(copy, loc)
				local replacement = items[counter]
				if replacement ~= nil then
					this._table[index - shifted] = replacement
				else
					table.remove(this._table, index - shifted)
					shifted += 1
					this.length -= 1
				end
			end
			counter += 1
		end
		return new "Array" (copy)
	end,

	--- Inserts new elements at the start of an array, and returns the new length of the array.
	--- @vararg any -- Elements to insert at the start of the array.
	--- @return Array
	unshift = function(this, ...: any): any
		local args = {...}
		for index = #args, 1, -1 do
			table.insert(this._table, 1, args[index])
			this.length += 1
		end
		return this.length
	end,

	--- Returns the index of the first occurence of a value in an array, or nil if it is not present.
	--- @param searchElement any -- The value to locate in the array.
	--- @param fromIndex? number -- The array index at which to begin the search. If fromIndex is omitted, the searc starts at index 0.
	--- @return number?
	indexOf = function(this, searchElement: any, fromIndex: number?): number?
		return table.find(this._table, searchElement, fromIndex)
	end,

	--- Returns the index of the last occurence of a specified value in an array, or nil if it is not present.
	--- @param searchElement any -- The value to locate in the array.
	--- @param fromIndex? number -- The array index at which to begin searching backward. If fromIndex is omitted, the search starts at the last index in the array.
	--- @return number?
	lastIndexOf = function(this, searchElement: any, fromIndex: number?): number?
		for index = fromIndex or #this._table, 1, -1 do
			if this._table[index] == searchElement then
				return index
			end
		end
		return nil
	end,

	--- Returns a new array with all sub-array elements concatenated into it recursively up to the specified depth.
	--- @param depth number? -- The maximum recursion depth.
	--- @return Array
	flat = function(this, depth: number): any
		local depth = depth or 1
		local copy = {}
		local function iterator(index: number, current: table)
			if type(current) == "table" and index < depth then
				for _, value in ipairs(current) do
					iterator(index + 1, value)
				end
			else
				return table.insert(copy, current)
			end
		end
		iterator(-1, this._table)
		return new "Array" (copy)
	end,

	--- Determines whether all the members of an array satisfy the specified test.
	--- @param predicate function -- A function that accepts up to three arguments. The every method calls the predicate function for each element in the array until the predicate returns a value which is coercible to the Boolean value false, or until the end of the array.
	--- @param thisArg? any -- An object to which the this keyword can refer in the predicate function. If thisArg is omitted, nil will be used as the this value.
	--- @return boolean
	every = function(this, predicate: (any, number?, any?) -> any, thisArg: any?): boolean
		for key, value in ipairs(this._table) do
			if not predicate(value, key, thisArg) then
				return false
			end
		end
		return true
	end,

	--- Determines whether the specified callback function returns true for any element of an array.
	--- @param predicate function -- A function that accepts up to three arguments. The every method calls the predicate function for each element in the array until the predicate returns a value which is coercible to the Boolean value false, or until the end of the array.
	--- @param thisArg? any -- An object to which the this keyword can refer in the predicate function. If thisArg is omitted, nil will be used as the this value.
	--- @return boolean
	some = function(this, predicate: (any, number?, any?) -> any, thisArg: any?): boolean
		for key, value in ipairs(this._table) do
			if predicate(value, key, thisArg) then
				return true
			end
		end
		return false
	end,

	--- Performs the specified action for each element in an array.
	--- @param callbackFn function -- A function that accepts up to three arguments. forEach calls the callbackfn function one time for each element in the array.
	--- @param thisArg? any -- An object to which the this keyword can refer in the callbackfn function. If thisArg is omitted, nil will be used as the this value.
	forEach = function(this, callbackFn: (any, number?, any?) -> nil, thisArg: any?)
		for key, value in ipairs(this._table) do
			callbackFn(value, key, thisArg)
		end
	end,

	--- Calls a defined callback function on each element of an array, and returns an array that contains the results.
	--- @param callbackFn function -- A function that accepts up to three arguments. The map method calls the callbackfn function one time for each element in the array.
	--- @param thisArg? any -- An object to which the this keyword can refer in the callbackfn function. If thisArg is omitted, nil will be used as the this value.
	--- @return Array
	map = function(this, callbackFn: (any, number?, any?) -> nil, thisArg: any?): any
		local copy = {}
		for key, value in ipairs(this._table) do
			local val = callbackFn(value, key, thisArg)
			if val ~= nil then
				table.insert(copy, val)
			end
		end
		return new "Array" (copy)
	end,

	--- Calls a defined callback function on each element of an array. Then, flattens the result into a new array.
	--- This is identical to a map followed by flat with depth 1.
	--- @param callback function -- A function that accepts up to three arguments. The flatMap method calls the callback function one time for each element in the array.
	--- @param thisArg? any -- An object to which the this keyword can refer in the callback function. If thisArg is omitted, nil is used as the this value.
	--- @return Array
	flatMap = function(this, callback: (any, number?, any?) -> nil, thisArg: any?): any
		this.map(callback, thisArg)
		return this.flat(1)
	end,

	--- Returns the elements of an array that meet the condition specified in a callback function.
	--- @param predicate function -- A function that accepts up to three arguments. The filter method calls the predicate function one time for each element in the array.
	--- @param thisArg? any -- An object to which the this keyword can refer in the predicate function. If thisArg is omitted, nil will be used as the this value.
	--- @return Array
	filter = function(this, predicate: (any, number?, any) -> any, thisArg: any?): any
		local copy = {}
		for key, value in ipairs(this._table) do
			if predicate(value, key, thisArg) then
				table.insert(copy, value)
			end
		end
		return new "Array" (copy)
	end,

	--- Calls the specified callback function for all the elements in an array. The return value of the callback function is the accumulated result, and is provided as an argument in the next call to the callback function.
	--- @param callbackFn function -- A function that accepts up to four arguments. The reduce method calls the callbackfn function one time for each element in the array.
	--- @param initialValue? any -- If initialValue is specified, it is used as the initial value to start the accumulation. The first call to the callbackfn function provides this value as an argument instead of an array value.
	--- @return any
	reduce = function(this, callbackFn: (any, any, number?, any?) -> any, initialValue: any?): any
		for key, value in ipairs(this._table) do
			initialValue = callbackFn(initialValue or 0, value, key, this)
		end
		return initialValue
	end,

	--- Calls the specified callback function for all the elements in the array, in descending order. The return value of the callback is the accumulated result, and is provided as an argument in the next call to the callback function.
	--- @param callbackFn function -- A function that accepts up to four arguments. The reduceRight method calls the callbackfn function one time for each element in the array.
	--- @param initialValue? any -- If initialValue is specified, it is used as the initial value to start the accumulation. The first call to the callbackfn function provides this value as an argument instead of an array value.
	--- @return any
	reduceRight = function(this, callbackFn: (any, any, number?, any?) -> any, initialValue: any?): any
		for index = #this._table, 1, -1 do
			initialValue = callbackFn(initialValue or 0, this._table[index], index, this)
		end
		return initialValue
	end,

	--- Determines whether an array includes a certain element, returning true or false as appropriate.
	--- @param searchElement any -- The element to search for.
	--- @param fromIndex? number -- The position in this array at which to begin searching for searchElement.
	--- @return boolean
	includes = function(this, searchElement: any, fromIndex: number?): boolean
		return this.indexOf(searchElement, fromIndex) ~= nil
	end,

	[meta "index"] = function(this, index: any): any
		print("indexed", index, this._table)
		return this._table[index]
	end,

	[meta "newindex"] = function()
		error("[ARRAY] Cannot use \"table[key] = value\" method on an Array!")
	end
}

return array






-- 400 lines