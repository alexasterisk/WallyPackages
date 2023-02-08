local PropsHelper = {}
PropsHelper.__index = PropsHelper

type PropsHelper<A, B> = {
    define: <A, B>(defaultProps: {[A]: B}, strictTyping: boolean?) -> {[A]: B},
    addMiddleware: (middleware: (value: B) -> B) -> {PropsHelper<A, B> & number},
    merge: (props: {[A]: B}) -> {[A]: B},
    _isStrict: boolean,
    _defaultProps: {[A]: B},
    _middleware: {[number]: (props: {[A]: B}) -> {[A]: B}}
}

function PropsHelper.define<A, B>(defaultProps: {[A]: B}, strictTyping: boolean?): PropsHelper<A, B>
    local self = setmetatable({}, PropsHelper)
    self._isStrict = strictTyping or false
    self._defaultProps = defaultProps
    self._middleware = {}
    return self
end

function PropsHelper:addMiddleware<A, B>(middleware: (value: B) -> B): {PropsHelper<A, B> & number}
    table.insert(self._middleware, middleware)
    return self, #self._middleware
end

function PropsHelper:merge<A, B>(props: {[A]: B}): {[A]: B}
    local newProps = {}
    for key, value in self._defaultProps do
        if props[key] == nil then
            newProps[key] = value
        else
            if self._isStrict and typeof(props[key]) ~= typeof(value) then
                warn(("PropsHelper: Expected %s to be of type %s, got %s. Defaulting to default value."):format(key, typeof(value), typeof(props[key])))
                newProps[key] = value
            else
                newProps[key] = props[key]
            end
        end

        for _, middleware in self._middleware do
            newProps[key] = middleware(newProps[key])
        end
    end

    return newProps
end

return PropsHelper