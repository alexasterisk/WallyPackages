type Methods<Default> = {
    addMiddleware: (middlewareFn: (value: any) -> any) -> {Methods<Default> & number},
    merge: <Incoming>(props: Incoming, mergeUnknown: boolean?) -> Default | (Default & Incoming),
}


--- @class PropsHelper
--- PropsHelper will help you define and merge default and incoming props.
--- Useful for when you want to define default props for a component,
--- but also want to allow the user to override them.
local module = {}


--- Allows you to define the default props for your component.
--- If you want to use strict typing to only allow the incoming props to be of the same type as the default props,
--- you can pass in `true` as the second argument.
--- @param defaultProps table -- The default props for your component.
--- @param strictTyping? boolean -- Whether or not to use strict typing.
--- @return PropsHelper -- The PropsHelper object.
function module.define<Default>(defaultProps: Default, strictTyping: boolean?): Methods<Default>
    local isStrict = strictTyping or false -- if not provided, just assume it's false.
    local middleware = {}

    local PropsHelper = {}


    --- Allows you to add middleware that will be ran when merging props.
    --- Useful for when you want to do some extra processing on the props.
    --- @param middlewareFn function<any, any> -- The middleware function.
    --- @return PropsHelper, number -- The PropsHelper object and the index of the middleware function.
    --- @within PropsHelper
    function PropsHelper.addMiddleware(middlewareFn: (value: any) -> any): {Methods<Default> & number}
        table.insert(middleware, middlewareFn) -- Adds a new middleware function to the table. Honestly this can be removed.
        return PropsHelper, #middleware
    end


    --- Merges the default props with the incoming props.
    --- This will also run the middleware functions after the table is merged.
    --- If you want to also merge the incoming props that are not defined in the default props,
    --- you can pass in `true` as the second argument.
    --- @param props table -- The incoming props.
    --- @param mergeUnknown? boolean -- Whether or not to merge the incoming props that are not defined in the default props.
    --- @return table -- The final props.
    --- @within PropsHelper
    function PropsHelper.merge<Incoming>(props: Incoming, mergeUnknown: boolean?): Default | (Default & Incoming)
        local newProps = {}

        for key, value in defaultProps do
            if props[key] == nil then
                newProps[key] = value -- If the value did not exist, use the default value.
            else
                if isStrict and typeof(props[key]) ~= typeof(value) then
                    warn(("PropsHelper: Expected %s to be of type %s, got %s. Defaulting to default value."):format(
                        key,
                        typeof(value),
                        typeof(props[key])
                    ))
                    newProps[key] = value -- If the value was not of the same type, use the default value.
                else
                    newProps[key] = props[key] -- If the value was of the same type, use the incoming value. Or if strict typing is disabled.
                end
            end
        end

        -- If we want to merge the incoming that are not defined in the default props.
        if mergeUnknown then
            for key, value in props do
                if newProps[key] == nil then
                    newProps[key] = value
                end
            end
        end

        -- Run the middleware functions and update their values.
        for key, value in newProps do
            for _, middlewareFn in middleware do
                newProps[key] = middlewareFn(value)
            end
        end

        -- Simply for type checking purposes.
        if isStrict then
            return newProps :: Default
        end

        return newProps :: Default & Incoming
    end

    return PropsHelper
end

return module
