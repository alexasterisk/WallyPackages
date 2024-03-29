PropsHelper will help you manage your property tables in a more organized way, and will also help you with strict type checking your props. You can also add middlewares to your PropsHelper to modify the values that are set when you merge your default properties with the given properties.

## Installation

### Using Wally

PropsHelper is available via Wally + Rojo workflow, installing it is as easy as the following:

``` toml title="wally.toml" hl_lines="9"
[package]
name = "user/repo"
description = "some maybe cool project"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
PropsHelper = "alexinite/props-helper@0.2.1"
```

``` ps1
wally install
```

New to Wally? [Read more about it](https://wally.run/).

Requiring PropsHelper will depend on your Rojo project format, I will assume you have Wally Packages going into ReplicatedStorage/Packages for usage examples.

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
local propsHelper = require(game.ReplicatedStorage.Packages.PropsHelper)
```

-----

### `.define(table, boolean?)`
* ***returns `PropsHelper`***

Creates a new PropsHelper instance with the given default props. If `strictTyping` is true, the PropsHelper will print a warning if you try to set a prop that is of a different type than the default prop, and then set the prop to the default prop.

``` lua
local helper = propsHelper.define({
    name = "Cool dude",
    money = 5
}, true)
```

### `.addMiddleware((value) -> value)`
* ***returns `PropsHelper`***

Adds a middleware to the PropsHelper. Middlewares are functions that are called before a prop is set, and can modify the value that is set. Middlewares are called in the order they are added.

``` lua
local helper = propsHelper.define({
    x = 3,
    z = 5
})

helper.addMiddleware(function(value)
    return value + 1
end)

-- helper.x = 4
-- helper.z = 6
```

### `.merge(table, boolean?)`
* ***returns `table`***

Merges the given props with the default props, and returns the merged table.
This will also run the middlewares on the merged table.
If `mergeUnknown` is true, it will merge props that are present in the given table but not in the default props.

``` lua
local helper = propsHelper.define({
    x = 3,
    z = 5
})

helper.addMiddleware(function(value)
    return value + 1
end)

local merged = helper.merge({
    x = 7
})

-- merged.x = 8
-- merged.z = 6
```

``` lua
local merged = helper.merge({
    x = 7,
    y = 1
}, true)

-- merged.x = 8
-- merged.y = 2
-- merged.z = 6
```