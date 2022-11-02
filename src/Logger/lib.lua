return function (name: string)
	name = "[" .. string.upper(name) .. "] "

	local logger = {

		--- Formats a string python-like
		--- @param str string -- The string to be formatted, params using `{param}`
		--- @param t table<number, string> | boolean -- The variables to be used in formatting or if to use `getfenv()`
		--- @param add? number -- If using `getfenv()`, how many levels to add
		--- @return string
		format = function(str: string, t: {string} | boolean, add: number?): string
			if type(t) == "boolean" and t then
				local vars = getfenv(2 + (add or 0))
                local match = string.match(str, "{.+}")
                while match do
                    str = string.gsub(str, match, tostring(vars[string.match(match, "[^{}]+")]))
                    match = string.match(str, "{.+}")
                end
                return str
			else
				for _, val: string | any in t :: {string} do
                    str = string.gsub(str, "{.+}", tostring(val), 1)
                end
                return str
			end
		end,

		--- Throws an error
		--- @param msg string -- The message to throw an error with
		--- @vararg any
		--- - If the first vararg is a number, it will be used as the logging level, otherwise it will be treated as extra data to print
		err = function(msg: string, ...)
			local data = {...}
			if data[2] ~= nil then
				local temp = data
				table.remove(temp, 1)
				print(unpack(temp))
			end
			if type(data[1]) == "number" or data[1] == nil then
				error(name .. msg, data[1])
			end
		end,

		--- Prints a message
		--- @param msg string -- The message to be printed
		--- @vararg any
		--- - All varargs will be treated as extra data to print
		log = function(msg: string, ...)
			print(name .. msg, ...)
		end,

        --- Sends a warning
        --- @param msg string -- The message to be used as a warning
        --- @vararg any
        --- - All varargs will be treated as extra data to print
        warn = function(msg: string, ...)
            warn(name .. msg, ...)
        end
	}

	--- Formats a string python-like and then prints it
	--- @param msg string -- The message to be printed, params using `{param}`
	--- @param t table<number, string> -- The variables to be used in formatting
	--- @vararg any
	--- - All varargs will be treated as extra data to print
	function logger.logf(msg: string, t: {string}, ...)
		msg = logger.format(msg, t)
		logger.log(msg, ...)
	end

    --- Formats a string python-like and then sends it as a warning
	--- @param msg string -- The message to be warned, params using `{param}`
	--- @param t table<number, string> -- The variables to be used in formatting
	--- @vararg any
	--- - All varargs will be treated as extra data to print
	function logger.warnf(msg: string, t: {string}, ...)
		msg = logger.format(msg, t)
		logger.warn(msg, ...)
	end

	--- Formats a string python-like and then throws it as an error
	--- @param msg string -- The message to throw an error with, params using `{param}`
	--- @param t table<number, string> -- The variables to be used in formatting
	--- @vararg any
	--- - If the first vararg is a number, it will be used as the logging level, otherwise it will be treated as extra data to print
	function logger.errf(msg: string, t: {string}, ...)
		msg = logger.format(msg, t)
		logger.err(msg, ...)
	end

	logger.env = {

		--- Formats a string python-like and then prints it
		--- @param msg string -- The message to be printed, params using `{param}`
		--- @vararg any
		--- - All varargs will be treated as extra data to print
		--- - All params will be imported directly from the calling script using `getfenv()`. Do note this breaks Luau optimizations!
		logf = function(msg: string, ...)
			msg = logger.format(msg, true, 1)
			logger.log(msg, ...)
		end,

        --- Formats a string python-like and then sends it as a warning
		--- @param msg string -- The message to be warned, params using `{param}`
		--- @vararg any
		--- - All varargs will be treated as extra data to print
		--- - All params will be imported directly from the calling script using `getfenv()`. Do note this breaks Luau optimizations!
		warnf = function(msg: string, ...)
			msg = logger.format(msg, true, 1)
			logger.warn(msg, ...)
		end,

		--- Formats a string python-like and then throws it as an error
		--- @param msg string -- The message to throw an error with, params using `{param}`
		--- @vararg any
		--- - If the first vararg is a number, it will be used as the logging level, otherwise it will be treated as extra data to print
		--- - All params will be imported directly from the calling script using `getfenv()`. Do note this breaks Luau optimizations!
		errf = function(msg: string, ...)
			msg = logger.format(msg, true, 1)
			logger.err(msg, ...)
		end
	}

	return logger
end