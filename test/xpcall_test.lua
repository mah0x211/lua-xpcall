require('luacov')
local assert = require('assert')
local xpcall = require('xpcall')

-- test that xpcall works
local result = {
    xpcall(function(a, b)
        return a + b, a, b
    end, debug.traceback, 1, 2),
}
assert.equal(result, {
    true,
    3,
    1,
    2,
})

-- test that handling errors works
local ok, err = xpcall(function(a, b)
    -- luacheck: ignore foo
    return foo + b, a, b
end, debug.traceback, 1, 2)
assert.is_false(ok)
assert.match(err, 'traceback')

-- test that __call metamethod will be called
local obj = {}
setmetatable(obj, {
    __call = function(self, a, b)
        assert.equal(self, obj)
        return a + b, a, b
    end,
})
result = {
    xpcall(obj, debug.traceback, 1, 2),
}
assert.equal(result, {
    true,
    3,
    1,
    2,
})

-- test that returns an error if function is not callable
obj = setmetatable(obj, {
    __call = {},
})
ok, err = xpcall(obj, debug.traceback)
assert.is_false(ok)
assert.match(err, 'attempt to call a table value')

-- test that throws an error if error handler is not a function
if not _G.jit and string.find(_VERSION, '5%.1') then
    ok, err = xpcall({})
    assert.is_false(ok)
    assert.match(err, 'error handling')
else
    err = assert.throws(function()
        xpcall({})
    end)
    assert.match(err, '#2 .+ %(.+ expected', false)
end
