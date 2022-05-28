# SwitchCase

SwitchCase is an implementation of [switch/case from JavaScript](https://www.w3schools.com/js/js_switch.asp) and other popular languages (like Java). It attempts to recreate it syntactically similar. However, doing this in Roblox is not easy due to how variables are encapsulated.

-----

## Installation

### Using Wally

SwitchCase is available via Wally + Rojo workflow, installing it is as easy as the following:

``` toml title="wally.toml" hl_lines="9"
[package]
name = "user/repo"
description = "some maybe cool project"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
SwitchCase = "alexinite/switch-case@0.1.0"
```

``` ps1
wally install
```

New to Wally? [Read more about it](https://wally.run/).

Requiring SwitchCase will depend on your Rojo project format, I will assume you have Wally Packages going into ReplicatedStorage/Packages for usage examples.

``` json title="default.project.json"
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

``` lua linenums="1" hl_lines="2"
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local switch, case, default = require(ReplicatedStorage.Packages.SwitchCase)()
```

!!! tip
        If you're using [my Import Package](../import/), you can import it like this:

        ``` lua linenums="1"
        local import = require(ReplicatedStorage.Packages.Import)
        local switch, case, default = import "@wally/switchCase" ()
        ```

-----

Using SwitchCase functions relatively like JavaScript's Switch-Case. Here's an example of them side-by-side:

=== "Luau"

    ``` lua linenums="1"
    local num = 6

    switch (num) {
        case (2) (function()
            print("number was 2!")
        end),

        case (5) (function()
            print("number was 5!")
        end),

        default (function()
            print("number was actually " .. num)
        end)
    }
    ```

=== "JS"

    ``` js linenums="1"
    let num = 6

    switch (num) {
        case 2: console.log("number was 2!")
        case 5: console.log("number was 5!")
        default: console.log("number was actually " + num)
    }
    ```
