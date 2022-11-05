# LuaObjects (arrays-maps-sets)

LuaObjects is an extended version of [LuaArray](../arrays/), implementing almost every feature from Arrays, Maps, and Sets from JavaScript.

-----

## Installation

### Using Wally

LuaObjects is available via Wally + Rojo workflow, installing it is as easy as the following:

``` toml title="wally.toml" hl_lines="9"
[package]
name = "user/repo"
description = "some maybe cool project"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Logger = "alexinite/arrays-maps-sets@0.1.4"
```

``` ps1
wally install
```

New to Wally? [Read more about it](https://wally.run/).

Requiring LuaObjects will depend on your Rojo project format, I will assume you have Wally Packages going into ReplicatedStorage/Packages for usage examples.

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