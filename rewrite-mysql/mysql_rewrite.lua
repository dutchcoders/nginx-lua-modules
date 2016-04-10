local mysql = require "resty.mysql"
local url = require "net.url"
local c = _G.cache

v = c:get(ngx.var.uri)
if  v == nil then
    local db, err = mysql:new()
    db:set_timeout(1000) -- 1 sec

    local dsn = ngx.var.rewrite_mysql_dsn
    local u =  url.parse(dsn)
    ngx.log(ngx.ERR,"url parse", u.host, u.port, u.path, u.user, u.password)

    port = u.port or 3306
    
    local ok, err, errno, sqlstate = db:connect
    {
        host = u.host,
        port = port,
        database = string.gsub(u.path, "^/", ""),
        user = u.user,
        password = u.password,
        max_packet_size = 1024 * 1024
    }

    if not ok then
        ngx.log(ngx.ERR,"MySQL failed to connect: ", err, ": ", errno, " ", sqlstate)
        return
    end

    local quoted_name = ngx.quote_sql_str(ngx.var.uri)

    local sql = "select redirect_url, status_code from rewrites where url  = " .. quoted_name

    result,err,errno,sqlstate = db:query(sql,1)
    if not result then
        ngx.log(ngx.ERR,"MySQL bad result: ", err, ": ", errno, ": ", sqlstate, ".")
        return
    end

    local ok, err = db:set_keepalive(10000, 100)
    if not ok then
        ngx.log(ngx.ERR, "failed to set keepalive: ", err)
        return
    end

    v = { redirect = false }

    if result[1] ~= nil then
        v = { status_code = result[1].status_code, redirect_url = result[1].redirect_url, redirect = true }
    end

    c:set(ngx.var.uri, v, 30)
end

if not v.redirect then
    return
end

local url = v.redirect_url
local msecs = ngx.now() * 1000

url = string.gsub(url, "%%%%CACHEBUSTER%%%%", string.format("%u", msecs))

ngx.redirect(url, v.status_code);

