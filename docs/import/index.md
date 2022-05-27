# Introduction

!!! danger "Impractical"
    This module was more as a concept and doesn't give ANY speed bonuses to using the default require(); however, I'd argue it still looks better. If you'd like to make this more efficient please [feel free to](https://github.com/alexinite/WallyPackages/fork).

For starters, you'll need to know how to use Roblox Studio... ~and Luau~... Anyways, Import is a Require module like TypeScript's `import`.

=== "Sugar"

    ``` lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local import = require(ReplicatedStorage.Packages.Import)

    local SomeClass = import "shared/someClass"
    ```

=== "No Sugar"

    ``` lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local import = require(ReplicatedStorage.Packages.Import)

    local SomeClass = import("shared/someClass")
    ```

## Sugar Syntax

Due to Lua's weird sugar syntax rules when it comes to encapsulation: You can create this weird syntax which drives some people insane but I personally think it looks cool. This is inspired off of [Elttob's Fusion module](https://elttob.github.io/Fusion).