# Logger

Logger is typically an internal package I use with my other packages; however, I find it really useful to use.

-----

## Installation

### Using Wally

Logger is available via Wally + Rojo workflow, installing it is as easy as the following:

``` toml title="wally.toml" hl_lines="9"
[package]
name = "user/repo"
description = "some maybe cool project"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Logger = "alexinite/logger@0.1.0"
```

``` ps1
wally install
```

New to Wally? [Read more about it](https://wally.run/).

Requiring Logger will depend on your Rojo project format, I will assume you have Wally Packages going into ReplicatedStorage/Packages for usage examples.

``` json title="default.project.json" hl_lines="7 8 9"
{
    "name": "project-name",
    "tree": {
        "$className": "DataModel",
        "ReplicatedStorage": {
            "$path": "src/shared",
            "Packages": {
                "$path": "Packages"
            }
        },
        ...
    }
}
```

-----

## Usage

First, requiring it depends on your Rojo project format, I will assume you have Wally Packages go into ReplicatedStorage/Packages.

When requiring the Logger, the first function will provide the name of the file you're initiating the Logger with. This is useful so you know which file is logging what.

``` lua
local logger = require(game.ReplicatedStorage.Packages.Logger) "fileName"
```

!!! tip
        If you're using [my Import Package](../import/), you can import it like this:

        ``` lua
        local import = require(game.ReplicatedStorage.Packages.Import)
        local logger = import "@wally/logger" "fileName"
        ```

-----

Trying to keep the Logger relatively similiar to Roblox's built-in, it functions almost identical. There is a key difference however: I introduced [Python-like string formatting](https://docs.python.org/3/tutorial/inputoutput.html#formatted-string-literals).

=== "Luau"

    ``` lua linenums="1"
    local name = "Johnny"

    logger.logf("Hello, {name}!", { name })

    logger.errf("There was an error! Due to {name}!", { name })
    ```

=== "Python"

    ``` py linenums="1"
    name = "Johnny"
    print(f'Hello, {name}!')
    ```

Obviously, doing the variable encapsulation in Lua would only be possible if the variable was not localized. This will be touched on more in the Usage.

=== "Luau Non-Localized"

    ``` lua linenums="1"
    local logger = require("path/to/logger") "fileName"
    name = "Johnny"

    logger.env.logf("Hello, {name}!")
    ```