# MySQL logging module

This module will log each request into a MySQL database

## Installation


## Configuration

```
http {
    server {
        listen       80;
        server_name  _;

        set $rewrite_mysql_dsn "mysql://username:password@server/database";

        log_by_lua_file 'nginx-lua-modules/log-request-mysql/log.lua';
    }
}
```

## Author

* Remco Verhoef (@remco_verhoef)
