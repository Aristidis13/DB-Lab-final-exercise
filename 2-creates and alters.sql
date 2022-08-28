ALTER TABLE film 
ADD is_part_of_season BOOLEAN DEFAULT FALSE,
MODIFY COLUMN language_id TINYINT UNSIGNED DEFAULT NULL;

ALTER TABLE customer 
ADD subscription_type ENUM("movies","series","both") DEFAULT null
AFTER active;

SET SQL_SAFE_UPDATES = 0;
UPDATE customer
SET subscription_type = 'movies' WHERE customer.active = 1;

UPDATE customer
SET subscription_type = 'both'
WHERE  customer.active = 1 AND customer_id = 35 OR customer_id = 104 OR customer_id = 85 OR customer_id = 3;

UPDATE customer SET subscription_type = 'series' WHERE  customer.active = 0;
UPDATE customer SET customer.active = 1 WHERE customer.active = 0 AND subscription_type = 'series'; -- Για σκοπούς testing

SET SQL_SAFE_UPDATES = 1;


DROP TABLE IF EXISTS `serie`;
CREATE TABLE `serie` (
  `serie_id` SMALLINT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(128) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `rating` ENUM ("G", "PG", "PG-13", "R", "NC-17") DEFAULT "G",
  `language_id` TINYINT UNSIGNED NOT NULL,
  `release_year` YEAR DEFAULT NULL,
  `original_language_id` TINYINT UNSIGNED DEFAULT NULL,
  CONSTRAINT fk_serie_language_original FOREIGN KEY (language_id) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_serie_language FOREIGN KEY (original_language_id) REFERENCES `language` (`language_id`) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS `episode`;
CREATE TABLE `episode` (
  `serie_id` SMALLINT UNSIGNED NOT NULL,
  `episode_id` SMALLINT UNSIGNED PRIMARY KEY NOT NULL,
  `episode_number` SMALLINT DEFAULT NULL,
  `season_number` SMALLINT DEFAULT 1,
  CONSTRAINT `fk_serie_id`
  FOREIGN KEY (`serie_id`) REFERENCES `serie` (`serie_id`)
  ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `episode_film_id`
  FOREIGN KEY (`episode_id`) REFERENCES `film` (`film_id`)
  ON DELETE CASCADE ON UPDATE CASCADE
);


DROP TABLE IF EXISTS `log`;
CREATE TABLE `log` (
  `log_id` SMALLINT UNSIGNED AUTO_INCREMENT NOT NULL,
  `username` VARCHAR(19) NOT NULL,
  `date_time` DATETIME NOT NULL,
  `success_state` ENUM("Success", "Failure") NOT NULL,
  `type` ENUM("INSERT", "UPDATE", "DELETE") NOT NULL,
  `table_name` ENUM("serie", "episode", "rental", "payment") NOT NULL,
  PRIMARY KEY (`log_id`)
);