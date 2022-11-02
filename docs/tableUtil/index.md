# TableUtil

TableUtil is an extremely simple utility package for tables.

-----

## Installation

### Using Wally

TableUtil is available via Wally + Rojo workflow, installing it is as easy as the following:

``` toml title="wally.toml" hl_lines="9"
[package]
name = "user/repo"
description = "some maybe cool project"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Logger = "alexinite/table-util@0.1.0"
```

``` ps1
wally install
```

New to Wally? [Read more about it](https://wally.run/).

Requiring TableUtil will depend on your Rojo project format, I will assume you have Wally Packages going into ReplicatedStorage/Packages for usage examples.

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
local util = require(game.ReplicatedStorage.Packages.TableUtil)
```

!!! tip
        If you're using [my Import Package](../import/), you can import it like this:

        ``` lua
        local import = require(game.ReplicatedStorage.Packages.Import)
        local util = import "@wally/tableUtil"
        ```

-----

### `.shallowCopy(table, table?)`
* ***returns `table`***

Shallow copies a table into a new table, returning the copy.
Shallow copying is to copy a table only one level deep, any tables nested inside of the table will not be copied.

Providing a second argument `copy` will allow you to start with an *initial table*. This essentially concats/merges it with the copy.

``` lua
local original = {1, 2, 3, 4, {5, 6, 7}}
local copy = util.shallowCopy(original) -- {1, 2, 3, 4, [table]}

local initial_copy = {10, 11}
local copy = util.shallowCopy(original, initial_copy) -- {10, 11, 1, 2, 3, 4, [table]}
```

### `.deepCopy(table, table?)`
* ***returns `table`***

Deep copies a table into a new table, returning the copy.
Deep copying is to copy a table at every single level, any and all tables nested inside of each other and this table will be copied.

Providing a second argument `copy` will allow you to start with an *initial table*. This essentially concats/merges it with the copy.

``` lua
local original = {1, 2, 3, 4, {5, 6, 7}}
local copy = util.deepCopy(original) -- {1, 2, 3, 4, {5, 6, 7}}

local initial_copy = {10, 11}
local copy = util.deepCopy(original, initial_copy) -- {10, 11, 1, 2, 3, 4, {5, 6, 7}}
```

### `.stringify(table)`
* ***returns `string`***

Turns a deep table into a parseable string, seperated by commas.

``` lua
local t = {1, 2, 3, 4, {5, 6, 7}}
print(util.stringify(t)) -- "1,2,3,4,{5,6,7}"
```

### `.iterateString(string)`
* ***returns `string[]`***

Turns a string into an iterable array.

``` lua
local str = "hi!"
local t = util.iterateString(str) -- {"h", "i", "!"}
```