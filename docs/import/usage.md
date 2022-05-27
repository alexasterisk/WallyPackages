# Usage

!!! danger "Impractical"
    This module was more as a concept and doesn't give ANY speed bonuses to using the default require(); however, I'd argue it still looks better. If you'd like to make this more efficient please [feel free to](https://github.com/alexinite/WallyPackages/fork).

## Reference Points

Referencing using `import` is in close parity with TypeScript's `import from` and formatted around Rojo's traditional workflow. It's also worth to note that the first letter of what you're requiring is interchangeable with uppercase and lowercase.

### ReplicatedStorage

!!! example

        ``` lua linenums="1" hl_lines="4"
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local import = require(ReplicatedStorage.Packages.Import)

        local SomeClass = import "shared/classModule"
        ```

-----

### StarterPlayerScripts

!!! example

        ``` lua title="*.client.lua" linenums="1" hl_lines="4"
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local import = require(ReplicatedStorage.Packages.Import)

        local SomeClass = import "client/classModule"
        ```

!!! warning "Client-Only"
        Using `client/` can only be done in a client-sided context. Attempting to access it from a server-sided context will result in an error.

-----

### ServerScriptService

!!! example

        ``` lua title="*.server.lua" linenums="1" hl_lines="4"
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local import = require(ReplicatedStorage.Packages.Import)

        local SomeClass = import "server/classModule"
        ```

!!! warning "Server-Only"
        Using `server/` can only be done in a server-sided context. Attempting to access it from a client-sided context will result in an error.

-----

## Dot References

One thing to tackle with this project was allowing TypeScript's `./` and `../` to be available from all contexts. Mostly for use with submodules.

!!! example

        ``` lua linenums="1" hl_lines="2 4"
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local import = require(ReplicatedStorage.Packages.Import) [script]

        local SomeSubclass = import "./subclass"
        ```

        ``` lua linenums="1" hl_lines="2 4"
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local import = require(ReplicatedStorage.Packages.Import) [script]

        local ClassInSameDir = import "../otherClass"
        ```

!!! warning "Don't forget to set `[script]`"
        Forgetting `[script]` when requiring `import` in times where a dot reference is used will result in an error.

-----

## Table and Function Back Referencing

Whenever you require a Module you lose the ability to access the ModuleScript as an Instance without reusing the same location. Here is an example ModuleScript:

!!! example

        ``` lua title="shared/Multiply.lua" linenums="1"
        return function(x: number, y: number)
            return x * y
        end
        ```

        Now, this is a comparison of how you would back reference in Import and Roblox's default Require:

        === "Import"

            ``` lua linenums="1" hl_lines="6"
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local import = require(ReplicatedStorage.Packages.Import)

            local multiply = import "shared/multiply" -- first letter can be lowercase for consistency
            print(multiply(5 * 3)) -- prints 15
            print(multiply:GetFullName()) -- "game.ReplicatedStorage.Multipy"
            ```

        === "Require"

            ``` lua linenums="1"
            local ReplicatedStorage = game:GetService("ReplicatedStorage")

            local multiplyInstance = ReplicatedStorage.Mulitply
            local multiply = require(multiplyInstance)
            print(multiply(5 * 3)) -- prints 15
            print(multiplyInstance:GetFullName()) -- "game.ReplicatedStorage.Multiply"
            ```

This is also similar for tables/metatables *kind of*.

!!! example

        ``` lua title="shared/RandomClass.lua" linenums="1"
        local class = {}
        class.__index = class

        function class.new(x: number)
            return setmetatable({
                number = x
            }, class)
        end

        function class:multiplyBy(y: number)
            return self.number * y
        end

        return class
        ```

        ``` lua linenums="1" hl_lines="8"
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local import = require(ReplicatedStorage.Packages.Import)

        local RandomClass = import "shared/randomClass"
        local randomClass = RandomClass.new(5)

        print(randomClass:multiplyBy(3)) -- prints 15
        print(randomClass.importBackRef:GetFullName()) -- "game.ReplicatedStorage.RandomClass"
        ```

-----

## Referencing Instances

Sometimes what you're searching for doesn't *need* to be a script. Like the following:

!!! example

        ``` json title="shared/part.model.json"
        {
            "ClassName": "Part",
            "Children:" [{
                "Name": "Head",
                "ClassName": "Part"
            }],
            "Properties": {
                "Anchored": true
            }
        }
        ```

        ``` lua linenums="1" hl_lines="5"
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local import = require(ReplicatedStorage.Packages.Import)

        local part = import "shared/part"
        print(part.Head:GetFullName()) -- "game.ReplicatedStorage.part.Head"
        ```

!!! danger "Severely Impractical"
        The implications of using Import like this is more impractical than using Import itself: which is impractical. You really needed me to tell you that?
