# MySQL Redirect module

This module will lookup urls from MySQL tables and check if it needs to be redirected.

## Installation


## Configuration

```
http {
    init_by_lua_file 'nginx-lua-modules/rewrite-mysql/mysql_rewrite_init.lua';

    server {
        listen       80;
        server_name  _;

        set $rewrite_mysql_dsn "mysql://username:password@server/database";

        rewrite_by_lua_file 'nginx-lua-modules/rewrite-mysql/mysql_rewrite.lua';
    }
}
```


