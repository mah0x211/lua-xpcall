/**
 * Copyright (C) 2023 Masatoshi Fukunaga
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
#include <lauxlib.h>
#include <lua.h>

static inline void checkcallable_lua(lua_State *L, int idx)
{
    if (!lua_isfunction(L, idx) && !lua_iscfunction(L, idx)) {
        if (!lua_getmetatable(L, idx)) {
            // throw error
            luaL_checktype(L, idx, LUA_TFUNCTION);
        }
        lua_pushliteral(L, "__call");
        lua_rawget(L, -2);
        if (!lua_isfunction(L, -1) && !lua_iscfunction(L, -1)) {
            // throw error
            luaL_checktype(L, idx, LUA_TFUNCTION);
        }
        lua_pop(L, 2);
    }
}

static int xpcall_lua(lua_State *L)
{
    checkcallable_lua(L, 1);
    luaL_checktype(L, 2, LUA_TFUNCTION);
    // swap error handler and function
    lua_pushvalue(L, 1);
    lua_pushvalue(L, 2);
    lua_replace(L, 1);
    lua_replace(L, 2);

    // call function with error handler
    lua_pushboolean(L, lua_pcall(L, lua_gettop(L) - 2, LUA_MULTRET, 1) == 0);
    // replace error handler with result
    lua_replace(L, 1);
    return lua_gettop(L);
}

LUALIB_API int luaopen_xpcall(lua_State *L)
{
    lua_pushcfunction(L, xpcall_lua);
    return 1;
}
