# Tween

Tween simply just extends on what Roblox defaultly provides with their TweenService.

-----

## Installation

### Using Wally

Tween is available via Wally + Rojo workflow, installing it is as easy as the following:

``` toml title="wally.toml" hl_lines="9"
[package]
name = "user/repo"
description = "some maybe cool project"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Logger = "alexinite/tween@0.1.0"
```

``` ps1
wally install
```

New to Wally? [Read more about it](https://wally.run/).

Requiring Tween will depend on your Rojo project format, I will assume you have Wally Packages going into ReplicatedStorage/Packages for usage examples.

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

``` lua
local tween = require(game.ReplicatedStorage.Packages.Tween)
```

!!! tip
        If you're using [my Import Package](../import/), you can import it like this:

        ``` lua
        local import = require(game.ReplicatedStorage.Packages.Import)
        local tween = import "@wally/tween"
        ```

-----

### tween()
* ***returns `Tween | Tween[]`***

* ***param* object *`Instance | Instance[]`*** -- The instance(s) being tweened
* ***param* info *`TweenInfo`***
* ***param* dict *`table<string, any>`*** -- The given properties to be tweened to
* ***param* auto? *`boolean`*** -- Should the tween automatically play?
* ***param* default? *`table<string, any>`*** -- The properties to start with before tweening

``` lua
local part = Instance.new("Part")
tween(part, TweenInfo.new(2), {
    Position = Vector3.new(0, 5, 0) -- elevates it 3 studs up
}, true, { -- automatically plays the tween
    Position = Vector3.new(0, 2, 0) -- start the tween at 2 studs up
}).Completed():Wait()
-- even if it automatically plays the tween, it still returns it

local otherPart = Instance.new("Part")
local bigParts = tween({part, otherPart}, TweenInfo.new(2), {
    Size = Vector3.new(3, 3, 3) -- makes both parts 3^3
})

bigParts:Play()
```