# PlayerResolvable

PlayerResolvable simply allows you to get the username, userId, or Player Instance by any of the previous data.

-----

## Installation

### Using Wally

PlayerResolvable is available via Wally + Rojo workflow, installing it is as easy as the following:

``` toml title="wally.toml" hl_lines="9"
[package]
name = "user/repo"
description = "some maybe cool project"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Logger = "alexinite/playerResolvable@0.1.0"
```

``` ps1
wally install
```

New to Wally? [Read more about it](https://wally.run/).

Requiring PlayerResolvable will depend on your Rojo project format, I will assume you have Wally Packages going into ReplicatedStorage/Packages for usage examples.

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
local resolver = require(game.ReplicatedStorage.Packages.PlayerResolvable)
```

!!! tip
        If you're using [my Import Package](../import/), you can import it like this:

        ``` lua
        local import = require(game.ReplicatedStorage.Packages.Import)
        local resolver = import "@wally/playerResolvable"
        ```

-----

The usage is pretty simple, only providing a total of three methods. Currently, the types of data it can resolve is limited to things that can be coerced into `string` or `number` and `Player`.

``` lua linenums="1"
local username = resolver.getUsername(74909795) -- "alexinite"
local userId = resolver.getUserId("alexinite") -- 74909795
local player = resolver.getPlayer("alexinite") -- if in-game, <Player>
local player = resolver.getPlayer(74909795) -- if in-game, <Player>
```