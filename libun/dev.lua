local dev = {}

dev.pretty = function (var)
  print(dev.fmt(var))
end

dev.fmt = function (var, depth)
  local t = type(var)
  if t == "table" then
    depth = depth or 1
    local s = "{\n"
    for k, v in pairs(var) do
      -- print(k, type(k), v, type(v))
      if type(k) ~= "number" then k = "\""..k.."\"" end
      s = s
        ..string.rep(" ",depth*2)
        .."["..k.."] = "
        ..dev.fmt(v, depth+1)
        ..",\n"
    end
    return s
      ..string.rep(" ",(depth-1)*2)
      .."}"
  elseif t == "function" then return tostring(var)
  elseif t ~= "number" then return "\""..var.."\""
  else return tostring(var)
  end
end

return dev

-- @TODO spec
-- local mock = {}
-- table.insert(mock, "Fisrt")
-- table.insert(mock, "Second")
-- table.insert(mock, 52)
-- mock.key = "val"
-- mock.sub = {"sub-key", "sub-val"}
-- table.insert(mock, "tables are unordered")
-- @TODO test with function, userdata, etc.
-- print(debug.fmt(mock))
-- print(debug.fmt("a string"))
-- print(debug.fmt(4337))