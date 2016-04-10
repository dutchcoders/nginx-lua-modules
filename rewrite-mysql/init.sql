CREATE TABLE `rewrites` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `url` varchar(250) DEFAULT NULL,
  `redirect_url` varchar(250) DEFAULT NULL,
  `status_code` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
