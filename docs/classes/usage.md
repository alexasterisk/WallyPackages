# Usage

Firstly, you will need to require the LuaClass Package. By the way, I might be taking snippets directly from the JavaScript classes reference from Mozilla. dwi

!!! warning "About class extending"
        If you're afraid that class extending isn't a thing here, it is: I just wont talk about it right away. Use the menu on the right to skip down to it if you'd like to!

``` lua
local new, class, extends, meta = require(game.ReplicatedStorage.Packages.LuaClass)()
```

!!! tip
        If you're using [my Import package](../import/), you can import it like this:

        ``` lua
        local import = require(game.ReplicatedStorage.Packages.Import)
        local new, class, extends, meta = import "@wally/luaClass" ()
        ```

-----

## Defining Classes

You define a class by using the built-in `class` function.

=== "LuaClass"

    ``` lua
    class "Rectangle" {
        constructor = function(this, height: number, width: number)
            this.height = height
            this.width = width
            return this
        end
    }

    local rectangle = new "Rectangle" (3, 5)
    ```

=== "TS"

    ``` ts
    class Rectangle {
        constructor(height: number, width: number) {
            this.height = height;
            this.width = width;
        }
    }

    const rectangle = new Rectangle(3, 5)
    ```

### Making a part with your rectangle

Now let's add a new method to your `Rectangle` class, being able to turn it into an actually usable Part might just be what you want.

``` lua
class "Rectangle" {
    constructor = function(this, height: number, width: number)
        this.height = height
        this.width = width
        return this
    end,

    generate = function(this): Part
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, this.height, this.width)
        part.Parent = workspace
        return part
    end,
}

local rectangle = new "Rectangle" (3, 5)
rectangle.generate().Name = "a cool part"
```

Just like that now you're a professional at using classes! (just don't think about touching Java, don't do that to yourself.)

-----

## Subclasses with `extends`

You can also create children of another class, aka. forcing it into another class.

=== "LuaClass"

    ``` lua
    class "Animal" {
        constructor = function(this, name: string)
            this.name = name
            return this
        end,

        speak = function(this)
            print(this.name .. " makes a noise.")
        end,
    }

    class "Dog" [extends "Animal"] {
        speak = function(this)
            print(this.name .. " barks.")
        end,

        growl = function(this)
            print(this.name .. "growls.")
        end,
    }

    local dog = new "Dog" ("Mitzie")
    dog.speak()
    dog.growl()
    ```

=== "TS"

    ``` ts
    class Animal {
        constructor(name: string) {
            this.name = name;
        }

        speak() {
            console.log(this.name + " makes a noise.");
        }
    }

    class Dog extends Animal {
        constructor(name: string) {
            super(name);
        }

        speak() {
            console.log(this.name + " barks.");
        }

        growl() {
            console.log(this.name + " growls.");
        }
    }

    const dog = new Dog("Mitzie");
    dog.speak();
    dog.growl();
    ```

-----

## Global Index

A special feature that was added to this is a global index. This is mainly here because so you don't have to constantly import a class from a different module all of the time. Do note this is bad practice for idiomacy.

!!! warning
        Classes will only be pushed to the global index if you require LuaClass like this:

        ``` lua
        local new, class, extends = require(game.ReplicatedStorage.Packages.LuaClass)(true)
        ```

        Or, if use my import module:

        ``` lua
        local new, class, extends = import "@wally/luaClass" (true)
        ```

        However, they will be available in all scripts requiring LuaClass, no matter if they pass this flag or not.

``` lua title="someClass.lua"
local _, class = require(game.ReplicatedStorage.Packages.LuaClass)(true)

class "Circle" {
    constructor = function(this, radius: number)
        this.radius = radius
        return this
    end,

    getArea = function(this)
        return math.pi * this.radius^2
    end,
}
```

``` lua title="script.server.lua"
local new = require(game.ReplicatedStorage.Packages.LuaClass)()

local circle = new "Circle" (5)
print(circle.getArea()) -- 78.5398163
```

!!! tip "Good Practice - Idiomacy"

        ``` lua title="someClass.lua"
        local _, class = require(game.ReplicatedStorage.Packages.LuaClass)()

        return class "Circle" {
            constructor = function(this, radius: number)
                this.radius = radius
                return this
            end,

            getArea = function(this)
                return math.pi * this.radius^2
            end,
        }
        ```

        ``` lua title="script.server.lua"
        local new, class = require(game.ReplicatedStorage.Packages.LuaClass)()
        class ["Circle"] = require(script.SomeClass)

        local circle = new "Circle" (5)
        print(circle.getArea()) -- 78.5398163
        ```

-----

## Metamethods

Defining metamethods with LuaClass may become important for if you want a custom way of interfacing `__index` and `__newindex`, heres an example of metamethoding with LuaClass:

``` lua
local new, class, extends, meta = require(game.ReplicatedStorage.Package.LuaClass)()

class "Animal" {
    constructor = function(this, name: string)
        this.name = name
        return this
    end,

    [meta "index"] = function(this, index)
        return this.name .. " " .. index .. "s."
    end,
}

local animal = new "Animal" ("Mitzie")
print(animal["bark"]) -- "Mitzie barks."
```