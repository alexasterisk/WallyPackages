# Installation

!!! danger "Impractical"
    This module was more as a concept and doesn't give ANY speed bonuses to using the default require(); however, I'd argue it still looks better. If you'd like to make this more efficient please [feel free to](https://github.com/alexinite/WallyPackages/fork).

Installing Import is as simple as simple as I could've ever made it. It's necessary to install it via your prefered method.

## Using Rojo

If you use Rojo, this is relatively easy by setting up your Rojo workflow like the following:

``` toml title="wally.toml" hl_lines="10"
[package]
name = "user/repo"
description = "some maybe cool project"
version = "1.0.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Import = "alexinite/import@0.1.8"
```

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

After that, you just have to run `wally install` in your project's directory.

## Using GitHub

For those that use GitHub, you will to download the `.zip` file on the ==[repository](https://github.com/alexinite/WallyPackages)== and copy the entire folder of `src/Import` into the `Packages` folder in ReplicatedStorage.
