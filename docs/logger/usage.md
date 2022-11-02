# Usage

To get started, you will need to require the Logger package.

!!! warning "Usage of `GETFENV()`"
        Using `logger.env.` **will** use `getfenv()`! If you're afraid of breaking Luau optimizations, feel free to just use the default logger! This also applies to using `logger.format("string", true)`.

``` lua
local logger = require(game.ReplicatedStorage.Packages.Logger) "fileName"
```

!!! tip
        If you're using [my Import package](../import/), you can import it like this:
        
        ``` lua
        local import = require(game.ReplicatedStorage.Packages.Import)
        local logger = import "@wally/logger" "fileName"
        ```

-----

## Using the formatter

### `logger.format(string, any[]|boolean, number?)`

If you're just using the Logger for it's [Python-like string formatting](https://docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals), you can simply use `logger.format()`

=== "Luau"

    ``` lua
    local name = "Johnny"
    logger.format("Hello, {name}!", { name }) --- "Hello, Johnny!"
    ```

=== "Python"

    ``` py
    name = "Johnny"
    print(f'Hello, {name}!')
    ```

### Non-Localized Variables

!!! warning "Luau Optimizations"
    By using `logger.format(string, true)` it **will** use `getfenv()` which currently breaks Luau optimizations!

To make formatting almost identical to Python, I added a method which will use `getfenv()` to find your **non-local** variables.

``` lua
name = "Johnny"
logger.format("Hello, {name}!", true) -- "Hello, Johnny!"
```

These variables have to not be defined by `local` or else the formatter will not be able to find them.

``` lua
local name = "Johnny"
logger.format("Hello, {name}!", true) -- errors
```

-----

## Printing a message

### `logger.log(string, ...)`

This simply prints a message, accepting varadic arguments to print as extra data.

``` lua
logger.log("Hello from the Logger!")
logger.log("Hello from varargs!", "Hi!", "How are you?")
```

### `logger.logf(string, any[], ...)`

This prints a message but uses the built-in formatter. This will match Python formatting. Just like `logger.log` this will accept varadic arguments to print as extra data.

``` lua
logger.logf("Hello from {name}!", { "Alex" }) -- "Hello from Alex!"
logger.logf("Hello from {name} and {me}!", { "varargs", "Alex" }, "other data") -- "Hello from varargs and Alex!", "other data"
```

However, I find this formatting pretty ugly and instead just a general replacement of the ugly `string.format` built-in function.

### `logger.env.logf(string, ...)`

!!! warning "Luau Optimizations"
    By using `logger.env.logf(string, ...)` it **will** use `getfenv()` which currently breaks Luau optimizations!

To make logger almost identical to Python, this will use `getfenv()` to find the **non-local** variable you referenced. This also accepts varadic arguments like every other *log* method.

``` lua
name = "Johnny"
logger.env.logf("Hello, {name}!") -- "Hello, Johnny!"
logger.env.logf("Hello, {name}!", "other data") -- "Hello, Johnny!" "other data"

local location = "Workspace" -- has to be NOT local
logger.env.logf("Go to {location} please!") -- errors
```

-----

## Printing a warning

### `logger.warn(string, ...)`

This simply warns with a message, accepting varadic arguments to print as extra data.

``` lua
logger.warn("This is a warning!")
logger.warn("This is warning with extra data!", "More!", "So many warnings!")
```

### `logger.warnf(string, any[], ...)`

This warns a message but uses the built-in formatter. This will match Python formatting. Just like `logger.log` this will accept varadic arguments to print as extra data.

``` lua
logger.warnf("Warning from {name}!", { "Alex" }) -- "Warning from Alex!"
logger.warnf("Warning from {name} and {me}!", { "cause", "Alex" }, "other data") -- "Warning from cause and Alex!", "other data"
```

### `logger.env.warnf(string, ...)`

!!! warning "Luau Optimizations"
    By using `logger.env.warnf(string, ...)` it **will** use `getfenv()` which currently breaks Luau optimizations!

To make logger almost identical to Python, this will use `getfenv()` to find the **non-local** variable you referenced. This also accepts varadic arguments like every other *warn* method.

``` lua
reason = "it broke"
logger.env.warnf("Warning! {reason}!") -- "Warning! it broke!"
logger.env.warnf("Warning! {reason}!", "other data") -- "Warning! it broke!" "other data"

local location = "Workspace" -- has to be NOT local
logger.env.warnf("It was caused in {location}!") -- errors
```

-----

## Throwing an error

### `logger.err(string, number|any, ...)`

This simply will throw an error, accepting varadic arguments to print as extra data.

If the first varadic argument is `typeof number`, it will be used instead as the error logging level.

``` lua
logger.err("Oh no!")
logger.err("Oh no!", "This occurred") -- "This occurred" "Oh no!"
logger.err("Oh no!", 3, "This occurred") -- "This occurred" "Oh no!"
```

### `logger.errf(string, any[], number|any, ...)`

This will throw an error but will use the built-in formatter. This will match Python formatting. Just like `logger.err` this will accept varadic arguments to print as extra data and using the first varadic argument, if it is a number, as the error logging level.

``` lua
local cause = "bad B.O."
logger.errf("Oh no! {cause} broke the game!", { cause }) -- "Oh no! bad B.O. broke the game!"
```

### `logger.env.errf(string, number|any, ...)`

!!! warning "Luau Optimizations"
    By using `logger.env.errf(string, number|any, ...)` it **will** use `getfenv()` which currently breaks Luau optimizations!

To make logger almost identical to Python, this will use `getfenv()` to find the **non-local** variable you referenced. This also accepts varadic arguments and will use the first one as the error logging level if it as a number, just like every other *err* method.

``` lua
cause = "bad B.O."
logger.env.errf("Oh no! {cause} broke the game!") -- "Oh no! bad B.O. broke the game!"

local description = "He really smelled" -- has to be NOT local
logger.env.errf("Why did this happen? {description}") --- errors
```