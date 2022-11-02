# Usage

!!! danger "Impractical"
    This module was more as a concept and doesn't give ANY speed bonuses to using the default require(); however, I'd argue it still looks better. If you'd like to make this more efficient please [feel free to](https://github.com/alexinite/WallyPackages/fork).

## Reference Points

Referencing using `import` is in close parity with TypeScript's `import from` and formatted around Rojo's traditional workflow. It's also worth to note that the first letter of what you're requiring is interchangeable with uppercase and lowercase.

-----

### Wally Packages

When Importing packages from Wally, you will need your Rojo workflow to look like the following:

``` json title="default.project.json" linenums="1" hl_lines="7 8 9 10 11 12 16 17 18"
{
    "name": "project-name",
    "tree": {
        "$className": "DataModel",
        "ReplicatedStorage": {
            "$path": "src/shared",
            "Packages": {
                "$path": "Packages"
            },
            "DevPackages": {
                "$path": "DevPackages"
            }
        },
        "ServerScriptService": {
            "$path": "src/server",
            "Packages": {
                "$path": "ServerPackages"
            }
        }
        ...
    }
}
```

Then, after installing with `wally install`, you can require a Wally package like this:

!!! example

        ``` lua linenums="1"
        local import = require(game.ReplicatedStorage.Packages.Import)

        local Maid = import "@wally/maid"
        ```

!!! tip

        If you're importing a dev-package or server-package, it can be done like this:

        ``` lua
        local devPackage = import "@wally-dev/someDevPackage"
        local serverPackage = import "@wally-server/someServerPackage"
        ```

-----

### ReplicatedStorage

!!! example

        ``` lua
        local SomeClass = import "shared/classModule"
        ```

-----

### StarterPlayerScripts

!!! example

        ``` lua title="*.client.lua"
        local SomeClass = import "client/classModule"
        ```

!!! warning "Client-Only"
        Using `client/` can only be done in a client-sided context. Attempting to access it from a server-sided context will result in an error.

-----

### ServerScriptService

!!! example

        ``` lua title="*.server.lua"
        local SomeClass = import "server/classModule"
        ```

!!! warning "Server-Only"
        Using `server/` can only be done in a server-sided context. Attempting to access it from a client-sided context will result in an error.

-----

## Dot References

One thing to tackle with this project was allowing TypeScript's `./` and `../` to be available from all contexts. Mostly for use with submodules.

!!! example

        ``` lua linenums="1"
        local import = require(game.ReplicatedStorage.Packages.Import) (script)

        local SomeSubclass = import "./subclass"
        local ClassInSameDir = import "../otherClass"
        ```

!!! warning "Don't forget to run `(script)`"
        Forgetting `(script)` when requiring import in times where a dot reference is used will result in an error.
