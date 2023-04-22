# `alexinite/import` **v0.1.8**

<span style="text-decoration:bold,color:white,background-color:green,border-radius:5px,padding:2px,margin-right:3px">ADD</span><p style="color:green">Added a changelog to keep up-to-date with changes and versioning.</p>
<span style="text-decoration:bold,color:white,background-color:green,border-radius:5px,padding:2px,margin-right:3px">ADD</span><p style="color:green">Added import caching making imports like `@wally/promise` only require the package once and not have to go through the resolver, immediately returning the import. This also applies to `server`, `client`, `shared` packages..</p>
<span style="text-decoration:bold,color:white,background-color:green,border-radius:5px,padding:2px,margin-right:3px">ADD</span><p style="color:green">Made a shortcut for `shared/modules` by simply starting off with the module name. ex:.</p><br>
```lua
local shapes = import "shapes" -- shorthand for "shared/modules/shapes"
local rectangles = import "shapes/rectangle" -- shorthand for "shared/modules/shapes/rectangle"
```<br>
<span style="text-decoration:bold,color:white,background-color:green,border-radius:5px,padding:2px,margin-right:3px">CHANGE</span><p style="color:green">Changed the internal `logger.err` from using `string.format` to using the Python-like formatting provided by `logger.errf`.</p><br>
<span style="text-decoration:bold,color:white,background-color:orange,border-radius:5px,padding:2px,margin-right:3px">BREAKING</span><p style="color:orange">Fixed bug with `dirs` returning **(Instance? | (string) => void)[]** instead of **Instance**.</p>
