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

-- test that throws an error if function is not a function
err = assert.throws(function()
    xpcall({})
end)
assert.match(err, '#1 .+ %(function expected, got ', false)

-- test that throws an error if __call metamethod is not a function
obj = setmetatable(obj, {
    __call = {},
})
err = assert.throws(function()
    xpcall(obj, debug.traceback)
end)
assert.match(err, '#1 .+ %(function expected, got ', false)

-- test that throws an error if error handler is not a function
err = assert.throws(function()
    xpcall(function()
    end, {})
end)
assert.match(err, '#2 .+ %(function expected, got ', false)
