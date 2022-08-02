ALTER TABLE `owned_vehicles`
	ADD COLUMN `garage_name` VARCHAR(50) NULL DEFAULT NULL AFTER `stored`,
	ADD COLUMN `vehiclename` VARCHAR(50) NULL DEFAULT NULL AFTER `garage_name`;
