# lua-xpcall

[![test](https://github.com/mah0x211/lua-xpcall/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-xpcall/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mah0x211/lua-xpcall/branch/master/graph/badge.svg)](https://codecov.io/gh/mah0x211/lua-xpcall)

this is a polyfill module that provides an xpcall API that allows passing arguments to functions in lua versions less than 5.2.

## Installation

```
luarocks install xpcall
```

## ok, res, ... = xpcall( func, err, ... )

same as `xpcall` function in lua 5.2 or later.

**Example**

```lua
local xpcall = require('xpcall')

local function foo(a, b)
    return a + b, a, b
end

local ok, res, a, b = xpcall(foo, debug.traceback, 1, 2)
print(ok, res, a, b) -- true, 3, 1, 2
```

