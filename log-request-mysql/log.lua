local url = require "net.url"

--if ngx.status == 200 then
--      return
-- end

local dsn = ngx.var.rewrite_mysql_dsn

local function log_status(_, dsn, req)
        local mysql = require "resty.mysql"
        local db, err = mysql:new()
        db:set_timeout(1000) -- 1 sec

        local u =  url.parse(dsn)

        port = (u.port or 3306)

        local ok, err, errno, sqlstate = db:connect {
                host = u.host,
                port = port,
                database = string.gsub(u.path, "^/", ""),
                user = u.user,
                password = u.password,
                max_packet_size = 1024 * 1024
        }


        local sql = string.format("insert into requests (date, host, path, query, status_code, remote_addr, referer, useragent) VALUES (NOW(), %s, %s, %s, %d, %s, %s, %s)", ngx.quote_sql_str(req.host or ""), ngx.quote_sql_str(req.path or ""), ngx.quote_sql_str(req.query or ""), req.status, ngx.quote_sql_str(req.remote_addr), ngx.quote_sql_str(req.referer or ""), ngx.quote_sql_str(req.useragent or ""))

        result,err,errno,sqlstate = db:query(sql,1)
        if not result then
                ngx.log(ngx.ERR,"MySQL bad result: ", err, ": ", errno, ": ", sqlstate, ".")
                return
        end
end

ngx.timer.at(1, log_status, dsn, { host = ngx.var.host, path = ngx.var.request_uri, query = ngx.var.query_string, status = ngx.status, remote_addr = (ngx.var.http_x_forwarded_for or  ngx.var.remote_addr), referer=ngx.var.http_referer, useragent=ngx.var.http_user_agent } )

