# LuaClass

LuaClass is an implementation of [classes from JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes) to an extent. This does not include private variables due to Lua's environment.

-----

## Installation

### Using Wally

LuaClass is available via Wally + Rojo workflow, if you're new to Wally or never heard of it, [read about it here](https://wally.run/)!

```toml title="wally.toml"
[package]
name = "user/repo"
description = "some cool project, probably"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Classes = "alexinite/lua-class@0.1.0"
```

After doing this (and learning Rojo + Wally, it's worth it I promise!) run `wally install` on your command line while in your project's repository.

Requiring LuaClass will depend on your Rojo project format, for the following examples I will assume you have it like the following, if you've used Wally before you're probably already familiar with this format.

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

You might be wondering just how much this compares in looks to JavaScript classes or even just regular Roblox metatables, here's your answer:

=== "LuaClass"

    ``` lua linenums="1"
    local new, class, extends, meta = require(game.ReplicatedStorage.Packages.LuaClass)()

    class "MathStruct" {
        firstValue = 0;
        lastValue = nil;

        constructor = function(this, num: number)
            this.firstValue = num
            return this
        end,

        multiply = function(this, by: number): number
            this.lastValue = this.firstValue * by
            return this.lastValue
        end,
    }

    local mathStruct = new "MathStruct" (5)
    print(mathStruct.multiply(3)) -- 15

    class "WithAddition" [extends "MathStruct"] {
        add = function(this, amount: number): number
            this.lastValue = this.firstValue + amount
            return this.lastValue
        end,
    }

    local withAddition = new "WithAddition" (7)
    print(withAddition.multiply(3)) -- 21
    print(withAddition.add(13)) -- 20
    ```

=== "Luau Metatables"

    ``` lua linenums="1"
    local MathStruct = {}
    MathStruct.__index = MathStruct

    function MathStruct.new(num: number)
        local mt = {}
        mt.firstValue = num
        mt.lastValue = nil
        setmetatable(mt, MathStruct)
        return mt
    end

    function MathStruct:multiply(by: number): number
        self.lastValue = self.firstValue * by
        return self.lastValue
    end

    local mathStruct = MathStruct.new(5)
    print(mathStruct:multiply(3)) -- 15

    local WithAddition = {}

    function WithAddition:__index(index)
        return WithAddition[index] or MathStruct[index]
    end

    function WithAddition.new(num: number)
        local mt = {}
        mt.firstValue = num
        mt.lastValue = nil
        setmetatable(mt, WithAddition)
        return mt
    end

    function WithAddition:add(amount: number): number
        self.lastValue = self.firstValue + amount
        return self.lastValue
    end

    local withAddition = WithAddition.new(7)
    print(withAddition:multiply(3)) -- 21
    print(withAddition:add(13)) -- 20
    ```

=== "TS"

    ``` ts linenums="1"
    class MathStruct {
        firstValue: number
        lastValue: number

        constructor(num: number) {
            this.firstValue = num;
        }

        multiply(by: number): number {
            this.lastValue = this.firstValue * by;
            return this.lastValue;
        }
    }

    const mathStruct = new MathStruct(5);
    console.log(mathStruct.multiply(3)); // 15

    class WithAddition extends MathStruct {
        constructor(num: number) {
            super(num);
        }

        add(amount: number): number {
            this.lastValue = this.firstValue + amount;
            return this.firstValue;
        }
    }

    const withAddition = new WithAddition();
    console.log(withAddition.multiply(3)); // 21
    console.log(withAddition.add(13)) // 20
    ```
