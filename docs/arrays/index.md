# LuaArray

LuaArray is a full* implementation of [arrays from JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array). This is only missing `[@@Symbol]` iterators and certain prototype methods.

-----

## Installation

### Using Wally

!!! warning
    LuaArray depends on [LuaClass](../classes/), another project of mine. This is not just an internal requirement but also a requirement on your end as you'll need to be able to accesss the `new` method.

LuaArray is available via Wally + Rojo workflow, if you're new to Wally or never heard of it, [read more about it here](https://wally.run/)!

``` toml title="wally.toml"
[package]
name = "user/repo"
description = "is this a cool project? yes it is"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
LuaArray = "alexinite/lua-array@0.1.0"
```

After doing this, run `wally install` on your command line while in your project's repository.

Requiring LuaArray will depend on your Rojo project format, for the following examples I will assume you have it like the following, if you've used Wally before you're probably already familiar with this format.

``` json title="*.project.json"
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

## Comparison

To start of, it's a good idea to show how these would behave in comparison to JavaScript arrays:

=== "LuaArray"

    ``` lua linenums="1"
    local new = require(game.ReplicatedStorage.Packages.LuaClass)()

    local array = new "Array" (5, 12) -- [5, 12]
    local newAmount = array.push(7) -- 3

    local mappedArray = array.map(function(num: number)
        return num * 2
    end) -- [10, 24, 14]

    print(mappedArray[2]) -- 24
    if mappedArray.includes(10) then
        print(mappedArray.indexOf(10)) -- 2
    end
    ```

=== "TS"

    ``` ts linenums="1"
    const array = new Array<number>(5, 12); // [5, 12]
    const newAmount = array.push(7); // 3

    const mappedArray = array.map(num => num * 2); // [10, 24, 14]

    console.log(mappedArray[2]); // 24
    if (mappedArray.includes(10)) {
        console.log(mappedArray.indexOf(10)) // 2
    }
    ```
