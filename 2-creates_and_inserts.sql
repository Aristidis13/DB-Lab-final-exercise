ALTER TABLE film 
ADD is_part_of_season BOOLEAN DEFAULT FALSE,
MODIFY COLUMN language_id TINYINT UNSIGNED DEFAULT NULL;

ALTER TABLE customer 
ADD subscription_type ENUM("movies","series","both") DEFAULT null
AFTER active;

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

INSERT INTO `serie` (`title`, `description`, `rating`,`language_id`, `release_year`, `original_language_id`) VALUES
("The Witcher", "Geralt of Rivia, a solitary monster hunter, struggles to find his place in a world where people often prove more wicked than beasts.", "R", "1", 2013, 1),
("Narcos", "Netflix chronicles the rise of the cocaine trade in Colombia and the gripping real-life stories of drug kingpins of the late 80s in this raw, gritty original series. Also detailed are the actions taken by law enforcement as they battle in the war on drugs, targeting notorious and powerful figures that include drug lord Pablo Escobar. As efforts are made to control cocaine, one of the worlds most valuable commodities, the many entities involved -- legal, political, police, military and civilian -- find themselves in conflict.", "NC-17", "1", 2015, 1),
("House of the Dragon", "The story of the Targaryen civil war that took place about 300 years before events portrayed in `Game of Thrones.", "R", "1", 2022, 1);

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


INSERT INTO `film` (`film_id`, `title`, `description`, `release_year`, `language_id`, `original_language_id`, `length`, `rating`, `special_features`, `is_part_of_season`) VALUES
/*Witcher First season - 8 episodes*/ /*Witcher Second season - 8 episodes*/ /*Narcos First Season 10 episodes*/
(12601, "The Ends Beginning", "Hostile townspeople and a cunning mage greet Geralt in the town of Blaviken. Ciri finds her royal world up-ended when Nilfgaard sets its sights on Cintra.", 2019, 1, NULL, 124, "PG-13", "Commentaries,Behind the Scenes", TRUE),
(15838, "Four Marks", "Heedless of warnings, Yennefer seeks a cure to restore what she has lost; Geralt inadvertently puts Jaskier in peril; the search for Ciri intensifies.", 2019, 1, 1, 125, "G", "Deleted Scenes", TRUE),
(13948, "Betrayer Moon", "Geralt takes on another Witchers unfinished business in a kingdom that is stalked by a ferocious beast; at a brutal cost, Yennefer forges a magical new future.", 2019, 1, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(12401, "Of Banquets, Bastards and Burials", "Against his better judgement, Geralt accompanies Jaskier to a royal ball; Ciri wanders into an enchanted forest; Yennefer attempts to protect her charges.", 2019, 1, 1, 124, "PG-13", "Commentaries,Behind the Scenes", TRUE),
(15338, "Bottled Appetites", "Heedless of warnings, Yennefer seeks a cure to restore what she has lost; Geralt inadvertently puts Jaskier in peril; the search for Ciri intensifies.", 2019, 1, 1, 125, "G", "Deleted Scenes", TRUE),
(17148, "Rare Species", "A mysterious man tries to entice Geralt to join the hunt for a rampaging dragon, a quest that attracts a familiar face. Ciri questions whom she can trust.", 2019, 1, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(15148, "Before a Fall", "With the Continent at risk from Nilfgaard's rising power, Yennefer revisits her past; Grant reconsiders his obligation to the Law of Surprise.", 2019, 1, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(19148, "Much More", "A terrifying pack of foes lays Geralt low. Yennefer and her fellow mages prepare to fight back. A shaken Ciri depends on the kindness of a stranger.", 2019, 1, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(12001, "A Grain of Truth", "Geralt sets off with Ciri on a journey that leads him to an old friend; after the Battle of Sodden, Tissaia shows no mercy in her search for information.", 2021, 1, NULL, 124, "PG-13", "Commentaries,Behind the Scenes", TRUE),
(15138, "Kaer Morhen", "Seeking a safe place for Ciri, Geralt heads for home, but danger lurks everywhere, even at Kaer Morhen. Yennefer's dreams could be the key to her freedom.", 2021, 1, 1, 125, "G", "Deleted Scenes", TRUE),
(13348, "What Is Lost", "Impatient with Geralt's methods, Ciri braves major obstacles to prove her mettle; scheming and suspicion among the Brotherhood make Yennefer a target.", 2021, 1, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(19401, "Redanian Intelligence", "A guest at Kaer Morhen extends a guiding hand to Ciri and an invitation to Geralt; on the run in Redania, Yennefer seeks safety below ground.", 2021, 1, 1, 124, "PG-13", "Commentaries,Behind the Scenes", TRUE),
(1538, "Turn Your Back", "As a powerful mage joins the hunt for Ciri, she cuts a deal with Vesemir over his extraordinary discovery; Geralt explores the mystery of the monoliths.", 2021, 1, 1, 125, "G", "Deleted Scenes", TRUE),
(13148, "Dear Friend...", "A close friend is lost -- and another found -- as Geralt helps Ciri learn more about her power; Cahir warns Fringilla to focus on their primary mission.", 2021, 1, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(03178, "Voleth Meir", "Geralt turns to a humble bard for help; Yennefer realizes that Ciri is very special; tensions rise on the eve of Emperor Emhyr's visit to Cintra.", 2021, 1, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(03141, "Family", "Geralt faces off with a demon targeting his nearest and dearest while the most powerful players on the continent ramp up their pursuit of Ciri.", 2021, 1, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(02201, "Descenso", "A Chilean drug chemist brings his product to Colombian smuggler Pablo Escobar; Agent Steve Murphy of the DEA joins the fight against drugs in Bogota.", 2015, 2, NULL, 124, "PG-13", "Commentaries,Behind the Scenes", TRUE),
(05358, "The Sword Of Simon Bolivar", "A radical communist group makes a move against the narcos; Murphy's new partner gives him an education in Colombian law enforcement.", 2015, 2, 1, 125, "G", "Deleted Scenes", TRUE),
(03448, "The men of always", "Murphy and Peña try to derail Escobar's political ambitions by exposing his drug involvement.", 2015, 2, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(12701, "The palace in flames", "More U.S. money in the fight against communism creates new challenges for Murphy and Peña as they try to capture Escobar.", 2015, 2, 1, 124, "PG-13", "Commentaries,Behind the Scenes", TRUE),
(15638, "There will be a future", "Pablo leads the narcos to the brink of war with Carillo and the government; Peña tries to protect his witness.", 2015, 2, 1, 125, "G", "Deleted Scenes", TRUE),
(17448, "Explosivos", "Peña and Carillo get closer to Gacha; Murphy tries to protect the pro-extradition candidate Gavrina from Pablo's assassins.", 2015, 2, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(15548, "You will cry tears of blood", "The turning political tide forces Pablo into hiding, but he still manages to strike back; Murphy and Peña finally get help from the CIA.", 2015, 2, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(19648, "La Gran Mentira", "The government is forced to change its tactics in the fight against Escobar; Pablo faces threats from within his empire.", 2015, 2, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(19748, "La Catedral", "Pablo makes a deal with the government, which seems to put an end to the chase, but Murphy and Peña have other plans.", 2015, 2, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE),
(19848, "Despegue", "Pablo's activities in prison provoke the government to extreme action; Murphy and Peña face a situation of their own.", 2015, 2, 1, 152, "NC-17", "Trailers,Commentaries,Behind the Scenes",TRUE);
/*House of the Dragon has not aired yet when this was written so it will have 0 at everything*/

INSERT INTO `episode`(`serie_id`, `episode_id`, `episode_number`, `season_number`) VALUES
/*Witcher Season 1*/
(1, 12601, 1, 1),
(1, 15838, 2, 1),
(1, 13948, 3, 1),
(1, 12401, 4, 1),
(1, 15338, 5, 1),
(1, 17148, 6, 1),
(1, 15148, 7, 1),
(1, 19148, 8, 1),
/*Witcher Season 2*/
(1, 12001, 1, 2),
(1, 15138, 2, 2),
(1, 13348, 3, 2),
(1, 19401, 4, 2),
(1, 1538,  5, 2),
(1, 13148, 6, 2),
(1, 03178, 7, 2),
(1, 03141, 8, 2),
/* Narcos Season 1*/
(3, 02201, 1, 1),
(3, 05358, 2, 1),
(3, 03448, 3, 1),
(3, 12701, 4, 1),
(3, 15638, 5, 1),
(3, 17448, 6, 1),
(3, 15548, 7, 1),
(3, 19648, 8, 1),
(3, 19748, 9, 1),
(3, 19848,10, 1);

INSERT INTO `inventory`(`inventory_id`, `film_id`) VALUES
(1234, 12601),
(1235, 15838),
(1236, 13948),
(1237, 12401),
(1238, 15338),
(1239, 17148),
(1244, 15148),
(1245, 19148),
(1246, 12001),
(1248, 15138),
(1274, 13348),
(1247, 19401),
(1221, 1538 ),
(1220, 13148),
(1209, 03178),
(1207, 03141),
(1212, 02201),
(1213, 05358),
(1200, 03448),
(1233, 12701),
(1298, 15638),
(1288, 17448),
(1277, 15548),
(1266, 19648),
(1255, 19748),
(1222, 19848);

-- Δημιουργία customers για να περιλαμβάνεται και η περίπτωση των series

INSERT INTO `tvondemand`.`customer` (`customer_id`, `first_name`, `last_name`, `email`, `address_id`, `active`, `subscription_type`, `create_date`)
VALUES ('31', 'THANASIS', 'SPIL', 'THANASIS.SPIL@EMAIL.COM', '20', '1', 'series', '2006-02-03 22:04:37'),
       ('32', 'THANASIS1', 'SPIL1', 'THANASIS1.SPIL@EMAIL.COM', '20', '1', 'series', '2006-02-03 22:04:37');

INSERT INTO `rental`(`rental_date`,`inventory_id`, `customer_id`) VALUES
("2015-06-15 01:25:08",1239, 3),
("2015-06-15 01:25:08",1234, 3),
("2015-06-15 01:25:08",1298, 3),
("2015-06-15 01:25:08",1288, 3),
("2017-06-15 01:25:08",1277, 3),
("2017-06-15 01:25:08",1266, 3),
("2017-06-15 01:25:08",1255, 3),
("2015-06-15 01:25:08",1222, 31), -- series
("2017-06-15 01:25:08",1255, 31), -- series
("2017-06-15 01:25:08",1255, 32), -- series
("2019-06-15 01:25:08",1235, 35),
("2015-06-15 01:25:08",1236, 35),
("2021-06-15 01:25:08",1237, 35),
("2015-06-15 01:25:08",1238, 35),
("2005-06-15 01:25:08",1212, 35),
("2017-06-15 01:25:08",1248, 85),
("2017-06-15 01:25:08",1274, 85),
("2017-06-15 01:25:08",1247, 85),
("2017-06-15 01:25:08",1220, 85),
("2015-06-15 01:25:08",1207, 85),
("2015-06-15 01:25:08",1213, 85),
("2017-06-15 01:25:08",1221, 104),
("2015-06-15 01:25:08",1209, 104),
("2015-06-15 01:25:08",1200, 104),
("2015-06-15 01:25:08",1233, 104),
("2017-06-15 01:25:08",1244, 104),
("2017-06-15 01:25:08",1245, 104),
("2017-06-15 01:25:08",1246, 104);

-- With specific values in rental_id - Used to insert two series only customers
INSERT INTO `rental`(`rental_id`,`rental_date`,`inventory_id`, `customer_id`) VALUES
(10070, "2017-06-15 01:25:08",1244, 31),
(10071, "2017-06-15 01:25:08",1245, 31),
(10072, "2017-06-15 01:25:08",1246, 32);

INSERT INTO `payment` (`customer_id`, `rental_id`, `amount`, `payment_date`) VALUES
(   3, 16046, 0.1, "2015-06-15 01:25:08" ),
(   3, 16041, 0.1, "2015-06-15 01:25:08" ),
(   3, 16061, 0.1, "2015-06-15 01:25:08" ),
(   3, 16062, 0.1, "2015-06-15 01:25:08" ),
(   3, 16063, 0.1, "2017-06-15 01:25:08" ),
(   3, 16064, 0.1, "2017-06-15 01:25:08" ),
(   3, 16065, 0.1, "2017-06-15 01:25:08" ),
(   3, 16066, 0.1, "2017-06-15 01:25:08" ),
(  31, 10070, 0.2, "2015-06-15 01:25:08" ), -- series only
(  31, 10071, 0.2, "2017-06-15 01:25:08" ), -- series only
(  32, 10072, 0.2, "2017-06-15 01:25:08" ), -- series only
(  35, 424,   0.1, "2005-05-27 01:25:08" ),
(  35, 16043, 0.1, "2015-06-15 01:25:08" ),
(  35, 16045, 0.1, "2015-06-15 01:25:08" ),
(  35, 16057, 0.1, "2005-06-15 01:25:08" ),
(  85, 16051, 0.1, "2017-06-15 01:25:08" ),
(  85, 16052, 0.1, "2017-06-15 01:25:08" ),
(  85, 16058, 0.1, "2015-06-15 01:25:08" ),
( 104, 16053, 0.1, "2017-06-15 01:25:08" ),
( 104, 16055, 0.1, "2015-06-15 01:25:08" ),
( 104, 16059, 0.1, "2015-06-15 01:25:08" ),
( 104, 16060, 0.1, "2015-06-15 01:25:08" ),
( 104, 16047, 0.1, "2017-06-15 01:25:08" ),
( 104, 16048, 0.1, "2017-06-15 01:25:08" ),
( 104, 16049, 0.1, "2017-06-15 01:25:08" );
