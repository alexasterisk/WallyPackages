local TweenService = game:GetService("TweenService")

local function tweenNext(object: Instance, info: TweenInfo, dict: {[string]: any}, auto: boolean?, default: {[string]: any}?): Tween
    local toTween = TweenService:Create(object, info, dict)
    if default ~= nil then
        for prop, val in default :: {[string]: any} do
            object[prop] = val
        end
    end
    if auto then
        toTween:Play()
    end
    return toTween
end

--- Creates a new Tween with the passed variables
--- @param object Instance | table<number, Instance> -- The instance(s) being tweened
--- @param info TweenInfo
--- @param dict table<string, any> -- The given properties to be tweened to
--- @param auto? boolean -- Should the tween automatically play?
--- @param default? table<string, any> -- The properties to start with before tweening
--- @return Tween | table<number, Tween>
return function(object: Instance | {Instance}, info: TweenInfo, dict: {[string]: any}, auto: boolean?, default: {[string]: any}?): Tween | {Tween}
    if type(object) == "table" then
        local tweens: {Tween} = {}
        for _, nextObject  in object :: {Instance} do
            table.insert(tweens, tweenNext(nextObject, info, dict, auto, default))
        end
        return tweens
    end
    return tweenNext(object, info, dict, auto, default)
end
