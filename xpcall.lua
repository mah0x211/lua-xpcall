--
-- Copyright (C) 2023 Masatoshi Fukunaga
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.
--
do
    local v = type(_VERSION) == 'string' and
                  tonumber(string.match(_VERSION, '%d%.%d'))
    if not v or v >= 5.2 then
        -- Lua 5.2 or later can use xpcall with arguments
        return xpcall
    end
end

local xpcall = xpcall
local select = select
local unpack = unpack or table.unpack
return function(fn, errfn, ...)
    local narg = select('#', ...)
    if narg == 0 then
        return xpcall(fn, errfn)
    end

    local argv = {
        ...,
    }
    return xpcall(function()
        return fn(unpack(argv, 1, narg))
    end, errfn)
end

