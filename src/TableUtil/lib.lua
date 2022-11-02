--- @alias IterableObject Array | string | Map | Set
export type table = {[any]: any}

local util = {}

--- "Shallow copies" a table into a new table, returing the copy.
--- Shallow copying is to copy a table only one level deep, any tables nested inside of the table will not be copied.
--- @param original table -- The table to copy
--- @param copy? table -- The initial table to use as the copy
--- @return table
function util.shallowCopy(original: table, copy: table?)
    copy = copy or {}
    for k, v in original do
        copy[k] = v
    end
    return copy
end

--- "Deep copies" a table into a new table, returing the copy.
--- Deep copying is to copy a table at every single level, any and all tables nested inside of each other and this table will be copied.
--- @param original table -- The table to copy
--- @param copy? table -- The initial table to use as the copy
--- @return table
function util.deepCopy(original: table, copy: table?)
    copy = copy or {}
    for k, v in original do
        if type(v) == "table" then
            copy[k] = util.deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

--- Turns a deep table into a parseable string, seperated by commas.
--- @param t table -- The table to stringify
--- @return string
function util.stringify(t: table): string
    local str = ""
    if type(t[1]) == "table" then
        str ..= "{" .. util.stringify(t[1]) .. "}"
    else
        str ..= tostring(t[1])
    end
    for i = 2, #t do
        if type(t[i]) == "table" then
            str ..= ",{" .. util.stringify(t[i]) .. "}"
        else
            str ..= "," .. tostring(t[i])
        end
    end
    return str
end

--- Turns a string into an iterable array.
--- @param str string -- The string to turn into an iterable table.
--- @return table<number, string>?
function util.iterateString(str: string): {string}?
    if #str > 0 then
        return string.sub(str, 1, 1):split(string.sub(str, 2))
    end
    return nil
end

return util