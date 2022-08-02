CREATE TABLE `owned_vehicles` (
	`owner` VARCHAR(46) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`plate` VARCHAR(12) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`vehicle` LONGTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`type` VARCHAR(20) NOT NULL DEFAULT 'car' COLLATE 'utf8mb4_unicode_ci',
	`job` VARCHAR(20) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`stored` TINYINT(1) NOT NULL DEFAULT '0',
	`garage_name` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`vehiclename` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`plate`) USING BTREE,
	INDEX `owner` (`owner`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
;
