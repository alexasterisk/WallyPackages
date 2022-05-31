# Usage

!!! warning
    Using Arrays with LuaArray is extremely on-par with [JavaScript classes](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array). Minus some things that are different with arrays with LuaArray, I will not be going over the methods/properties of Arrays. If you would like to read about those: [Please read the official JavaScript references](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array).

-----

## Importing LuaArray

LuaArray has it's own module when installing it with Wally, however **I do not recommend requiring it from its module**. It loses a lot of sugar clarity if it's not being intertwined with the `new` method for classes.

``` lua
local new = require(game.ReplicatedStorage.Packages.LuaClass)()

local array = new "Array" (5, 12) -- [5, 12]
print(array.length) -- 2
```

!!! tip
    If you're using [my Import package](../import/), you can import it like this:

    ``` lua
    local import = require(game.ReplicatedStorage.Packages.Import)
    local new = import "@wally/luaClass" ()

    local array = new "Array" (5, 12) -- [5, 12]
    print(array.length) -- 2
    ```

!!! danger "Direct Require"
    If you would still like to require it directly, here's what that may look like for you; however this format seems to get repetitive extremely quickly which is why i bundled it with LuaClass:

    ``` lua
    local LuaArray = require(game.ReplicatedStorage.Packages.LuaArray)

    local array = LuaArray(5, 12) -- [5, 12]
    print(array.length) -- 2
    ```

-----

## Logging the Array

Unlike JavaScript arrays you cannot simply do `print(array)` due to some inconvienences of Lua metatables; however, you can get the private table directly from the Array class like the following:

``` lua
local array = new "Array" (5, 12) -- [5, 12]
print(array._table) -- {[1]: 5, [2]: 12}
```

-----

## One-indexed

Unlike JavaScript, Arrays in Lua are not [zero-indexed](https://en.wikipedia.org/wiki/Zero-based_numbering) and start at 1. This is exactly how Roblox handles tables by default, so nothing new from moving from Roblox tables.

-----

## Missing Properties

### [Array[@@unscopables]](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/@@unscopables)

## Missing Methods

### [Array[@@iterator]](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/@@iterator)()

### [get Array[@@species]](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/@@species)

### [Array.entries()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/entries)

### [Array.from()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/from)

### [Array.groupBy()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/groupBy)

### [Array.groupByToMap()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/groupByToMap)

### [Array.isArray()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/isArray)

### [Array.keys()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/keys)

### [Array.of()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/of)

### [Array.toLocaleString()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/toLocaleString)

### [Array.toSource()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/toSource)

### [Array.values()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/values)