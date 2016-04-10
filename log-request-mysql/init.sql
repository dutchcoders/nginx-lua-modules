CREATE TABLE `requests` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `date` datetime DEFAULT NULL,
  `host` varchar(250) DEFAULT NULL,
  `path` varchar(250) DEFAULT NULL,
  `query` varchar(250) DEFAULT NULL,
  `status_code` int(11) DEFAULT NULL,
  `referer` varchar(250) DEFAULT NULL,
  `useragent` varchar(250) DEFAULT NULL,
  `remote_addr` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81625 DEFAULT CHARSET=utf8;
