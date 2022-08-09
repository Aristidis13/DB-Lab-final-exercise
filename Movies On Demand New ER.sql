CREATE TABLE `actor` (
  `actor_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL
);

CREATE TABLE `country` (
  `country_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `country` VARCHAR(50) NOT NULL
);

CREATE TABLE `city` (
  `city_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `city` VARCHAR(50) NOT NULL,
  `country_id` SMALLINT NOT NULL
);

CREATE TABLE `address` (
  `address_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(50) NOT NULL,
  `district` VARCHAR(20) DEFAULT NULL,
  `city_id` SMALLINT NOT NULL,
  `postal_code` VARCHAR(10) DEFAULT NULL,
  `phone` VARCHAR(20) NOT NULL
);

CREATE TABLE `category` (
  `category_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(25) NOT NULL
);

CREATE TABLE `language` (
  `language_id` TINYINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `name` CHAR(20) NOT NULL
);

CREATE TABLE `customer` (
  `customer_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(50) DEFAULT NULL,
  `address_id` SMALLINT NOT NULL,
  `active` BOOLEAN NOT NULL DEFAULT TRUE,
  `create_date` DATETIME NOT NULL,
  `subscription_type` ENUM ('movies', 'series', 'all')
);

CREATE TABLE `film` (
  `film_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(128) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `release_year` YEAR DEFAULT NULL,
  `language_id` TINYINT NOT NULL,
  `original_language_id` TINYINT DEFAULT NULL,
  `length` SMALLINT DEFAULT NULL,
  `rating` ENUM ('G', 'PG', 'PG-13', 'R', 'NC-17') DEFAULT "G",
  `special_features` SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  `is_part_of_season` ENUM ('yes', 'no') DEFAULT "no"
);

CREATE TABLE `serie` (
  `serie_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(128) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `rating` ENUM ('G', 'PG', 'PG-13', 'R', 'NC-17') DEFAULT "G"
);

CREATE TABLE `season` (
  `serie_id` SMALLINT,
  `season_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `season_number` SMALLINT DEFAULT 1,
  `description` TEXT DEFAULT NULL,
  `release_year` YEAR DEFAULT NULL,
  `rating` ENUM ('G', 'PG', 'PG-13', 'R', 'NC-17') DEFAULT "G",
  `special_features` SET('Trailers','Commentaries','Deleted Scenes','Behind the Scenes') DEFAULT NULL,
  `episode_numbers` SMALLINT DEFAULT NULL
);

CREATE TABLE `episode` (
  `season_id` SMALLINT,
  `episode_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `episode_number` SMALLINT DEFAULT NULL
);

CREATE TABLE `film_actor` (
  `actor_id` SMALLINT NOT NULL,
  `film_id` SMALLINT NOT NULL,
  PRIMARY KEY (`actor_id`, `film_id`)
);

CREATE TABLE `film_category` (
  `film_id` SMALLINT NOT NULL,
  `category_id` TINYINT NOT NULL,
  PRIMARY KEY (`film_id`, `category_id`)
);

CREATE TABLE `inventory` (
  `inventory_id` MEDIUMINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `film_id` SMALLINT NOT NULL
);

CREATE TABLE `rental` (
  `rental_id` INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `rental_date` DATETIME NOT NULL,
  `inventory_id` MEDIUMINT NOT NULL,
  `customer_id` SMALLINT NOT NULL
);

CREATE TABLE `payment` (
  `payment_id` SMALLINT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `customer_id` SMALLINT NOT NULL,
  `rental_id` INT DEFAULT NULL,
  `amount` DECIMAL(5,2) NOT NULL,
  `payment_date` DATETIME NOT NULL
);

CREATE UNIQUE INDEX `rental_index_0` ON `rental` (`rental_date`, `inventory_id`, `customer_id`);

ALTER TABLE `season` ADD CONSTRAINT `fk_serie_id` FOREIGN KEY (`serie_id`) REFERENCES `serie` (`serie_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `episode` ADD CONSTRAINT `fk_season_id` FOREIGN KEY (`season_id`) REFERENCES `season` (`season_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film` ADD CONSTRAINT `fk_film_id` FOREIGN KEY (`film_id`) REFERENCES `episode` (`episode_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `city` ADD CONSTRAINT `fk_city_country` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `address` ADD CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `customer` ADD CONSTRAINT `fk_customer_address` FOREIGN KEY (`address_id`) REFERENCES `address` (`address_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film` ADD CONSTRAINT `fk_film_language` FOREIGN KEY (`language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film` ADD CONSTRAINT `fk_film_language_original` FOREIGN KEY (`original_language_id`) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_actor` ADD CONSTRAINT `fk_film_actor_actor` FOREIGN KEY (`actor_id`) REFERENCES `actor` (`actor_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_actor` ADD CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_category` ADD CONSTRAINT `fk_film_category_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `film_category` ADD CONSTRAINT `fk_film_category_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `inventory` ADD CONSTRAINT `fk_inventory_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `rental` ADD CONSTRAINT `fk_rental_inventory` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `rental` ADD CONSTRAINT `fk_rental_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE `payment` ADD CONSTRAINT `fk_payment_rental` FOREIGN KEY (`rental_id`) REFERENCES `rental` (`rental_id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `payment` ADD CONSTRAINT `fk_payment_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`customer_id`) ON DELETE RESTRICT ON UPDATE CASCADE;
