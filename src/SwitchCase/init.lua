local function case(value: any)
    return function(func: () -> ())
        return {
            value = value,
            func = func
        }
    end
end

local function default(func: () -> ())
    return {
        value = "____SwitchCaseDefault",
        func = func
    }
end

local function switch(variable: any)
    return function(cases)
        local ran = false
        local _default
        for _, _case in pairs(cases) do
            if _case.value == "____SwitchCaseDefault" then
                _default = _case.func
            else
                if _case.value == variable then
                    _case.func()
                    ran = true
                    break
                end
            end
        end
        if not ran and type(_default) == "function" then
            _default()
        end
    end
end

return function()
    return switch, case, default
end