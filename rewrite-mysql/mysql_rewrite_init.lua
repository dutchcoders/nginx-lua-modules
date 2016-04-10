local lrucache = require "resty.lrucache"

local c = lrucache.new(200)  -- allow up to 200 items in the cache
if not c then
  return error("failed to create the cache: " .. (err or "unknown"))
end

_G.cache = c
