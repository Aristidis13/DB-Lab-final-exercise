/*
 * 3.1 
 */
DROP PROCEDURE IF EXISTS codesAndTitles;
DELIMITER #
CREATE PROCEDURE codesAndTitles(
IN specifier CHAR,
IN quantity SMALLINT,
IN startDate date,
IN endDate date)
BEGIN
  IF(specifier = 'm') THEN
	SELECT
    film.film_id as "Film Id",
    film.title as "Title",
    rental.rental_date as "Date",
    COUNT(film.film_id) as "Number of Rentals"
  FROM film
  INNER JOIN inventory ON film.film_id = inventory.film_id
  INNER JOIN rental ON inventory.inventory_id = rental.inventory_id 
  WHERE rental.rental_date BETWEEN startDate
  AND rental.rental_date <= endDate
  AND film.is_part_of_season = FALSE
  GROUP BY film.film_id
  ORDER BY COUNT(film.film_id) DESC
  LIMIT quantity;
  ELSEIF (specifier = 's') THEN
    SELECT
    serie.serie_id as "Film Id",
    serie.title as "Title",
    rental.rental_date as "Date",
    COUNT(serie.serie_id) as "Number of Rentals"
  FROM serie
  INNER JOIN episode ON serie.serie_id = episode.serie_id
  INNER JOIN film ON episode.episode_id = film.film_id
  INNER JOIN inventory ON film.film_id = inventory.film_id
  INNER JOIN rental ON inventory.inventory_id = rental.inventory_id 
  WHERE rental.rental_date BETWEEN startDate AND endDate
  AND film.is_part_of_season = TRUE
  GROUP BY serie.serie_id
  ORDER BY COUNT(serie.serie_id) DESC
  LIMIT quantity;
  ELSE
    SELECT "Specifier is not m or s";
  END IF;
END #
DELIMITER ;

call codesAndTitles('m', 94, '2005-04-01', '2021-08-30');
call codesAndTitles('s', 3, '2005-04-01', '2021-08-30'); 

/*
 * 3.2 
 */
DROP PROCEDURE IF EXISTS rentalsForSpecificDate;
DELIMITER #
CREATE PROCEDURE rentalsForSpecificDate(
IN email VARCHAR(50),
IN date_arg DATE)
BEGIN
	SELECT rental.customer_id,first_name, last_name, email, rental_date, COUNT(*) AS "Rented Opuses" FROM customer
    INNER JOIN rental 
    ON customer.customer_id = rental.customer_id
	WHERE DATE(rental.rental_date) = date_arg AND customer.email = email
    GROUP BY(rental.customer_id);
END #
DELIMITER ;

select * from customer 
inner join rental on rental.customer_id = customer.customer_id
where subscription_type like 'both' OR subscription_type like 'series';

call rentalsForSpecificDate('LINDA.WILLIAMS@sakilacustomer.org','2015-06-15'); -- Expected is 5 rentals in that date
call rentalsForSpecificDate('LINDA.WILLIAMS@sakilacustomer.org','2017-06-15'); -- Expected result is rental date 2017-06-15 01:25:08
call rentalsForSpecificDate('LINDA.WILLIAMS@sakilacustomer.org','2005-04-01'); -- Expected result: Nothing because there are no dates in rental

/*3.3 Calculate Per month*/


DROP PROCEDURE IF EXISTS profits;
DELIMITER #
CREATE PROCEDURE profits()
BEGIN
SELECT *, CAST(amount AS DECIMAL(7,3)) FROM payment;

SELECT
 sum(distinct case when month(payment_date) = 1  then CAST(amount AS DECIMAL(6,3)) else 0 end) January,
 sum(distinct case when month(payment_date) = 2  then CAST(amount AS DECIMAL(6,3)) else 0 end) February,
 sum(distinct case when month(payment_date) = 3  then CAST(amount AS DECIMAL(6,3)) else 0 end) March,
 sum(distinct case when month(payment_date) = 4  then CAST(amount AS DECIMAL(6,3)) else 0 end) April,
 sum(distinct case when month(payment_date) = 5  then CAST(amount AS DECIMAL(6,3)) else 0 end) May,
 sum(distinct case when month(payment_date) = 6  then CAST(amount AS DECIMAL(6,3)) else 0 end) June,
 sum(distinct case when month(payment_date) = 7  then CAST(amount AS DECIMAL(6,3)) else 0 end) July,
 sum(distinct case when month(payment_date) = 8  then CAST(amount AS DECIMAL(6,3)) else 0 end) August,
 sum(distinct case when month(payment_date) = 9  then CAST(amount AS DECIMAL(6,3)) else 0 end) September,
 sum(distinct case when month(payment_date) = 10 then CAST(amount AS DECIMAL(6,3)) else 0 end) October,
 sum(distinct case when month(payment_date) = 11 then CAST(amount AS DECIMAL(6,3)) else 0 end) November,
 sum(distinct case when month(payment_date) = 12 then CAST(amount AS DECIMAL(6,3)) else 0 end) December
FROM payment 
INNER JOIN rental ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id 
INNER JOIN film ON film.film_id = inventory.film_id 
WHERE film.is_part_of_season = false
GROUP BY month(payment_date);

SELECT
 sum(distinct case when month(payment_date) = 1  then CAST(amount AS DECIMAL(6,3)) else 0 end) January,
 sum(distinct case when month(payment_date) = 2  then CAST(amount AS DECIMAL(6,3)) else 0 end) February,
 sum(distinct case when month(payment_date) = 3  then CAST(amount AS DECIMAL(6,3)) else 0 end) March,
 sum(distinct case when month(payment_date) = 4  then CAST(amount AS DECIMAL(6,3)) else 0 end) April,
 sum(distinct case when month(payment_date) = 5  then CAST(amount AS DECIMAL(6,3)) else 0 end) May,
 sum(distinct case when month(payment_date) = 6  then CAST(amount AS DECIMAL(6,3)) else 0 end) June,
 sum(distinct case when month(payment_date) = 7  then CAST(amount AS DECIMAL(6,3)) else 0 end) July,
 sum(distinct case when month(payment_date) = 8  then CAST(amount AS DECIMAL(6,3)) else 0 end) August,
 sum(distinct case when month(payment_date) = 9  then CAST(amount AS DECIMAL(6,3)) else 0 end) September,
 sum(distinct case when month(payment_date) = 10 then CAST(amount AS DECIMAL(6,3)) else 0 end) October,
 sum(distinct case when month(payment_date) = 11 then CAST(amount AS DECIMAL(6,3)) else 0 end) November,
 sum(distinct case when month(payment_date) = 12 then CAST(amount AS DECIMAL(6,3)) else 0 end) December
FROM payment 
INNER JOIN rental ON rental.rental_id = payment.rental_id
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id 
INNER JOIN film ON film.film_id = inventory.film_id 
WHERE film.is_part_of_season = true
GROUP BY month(payment_date);

END #
DELIMITER ;

call profits();

/*
 * 3.4
 * Δημιουργία index το οποίο θα περιλαμβάνει τα επώνυμα των ηθοποιών
 * Βάσει αυτού μπορούν να γίνονται αναζητήσεις πιο γρήγορα και αν οι χαρακτήρες ταιριάζουν να έρχονται μπροστά 
 */
-- DROP INDEX idx_lastNames ON actor;
CREATE INDEX idx_lastNames ON actor (last_name); -- These two will have to be indexed for finding the last_name quicker 
-- DROP INDEX idx_names ON actor;
CREATE INDEX idx_names ON actor(first_name,last_name); -- These two lines have to be indexed together for 3.4.a 

DROP INDEX idx_lastNames ON actor;
CREATE FULLTEXT INDEX idx_lastNames ON actor (last_name);

-- a
DROP PROCEDURE IF EXISTS findActors;
DELIMITER #
CREATE PROCEDURE findActors( IN startOfNames VARCHAR(45), IN endOfNames VARCHAR(45))
BEGIN
SET @lowerLimitLength = CHAR_LENGTH(startOfNames), @upperLimitLength = CHAR_LENGTH(endOfNames);
	SELECT first_name, last_name
    FROM actor
	WHERE STRCMP(lower(startOfNames), lower(left(last_name, @lowerLimitLength ))) <= 0
    AND   STRCMP(lower(endOfNames),   lower(left(last_Name, @upperLimitLength ))) >= 0
    UNION
    SELECT COUNT(*) as 'Returned rows', NULL
    FROM actor
	WHERE STRCMP(lower(startOfNames), lower(left(last_name, @lowerLimitLength ))) <= 0
    AND   STRCMP(lower(endOfNames),   lower(left(last_Name, @upperLimitLength ))) >= 0
    ORDER BY Last_name DESC;
END #
DELIMITER ;

CALL findActors('ACO','alm');

-- b
DROP PROCEDURE IF EXISTS findActor;
DELIMITER #
CREATE PROCEDURE findActor( IN actorName VARCHAR(45))
BEGIN
	SELECT first_name, last_name
    FROM actor
	WHERE actor.last_name = actorName
    OR actor.first_name = actorName
    UNION
		SELECT 
			IF(COUNT(*) > 1, COUNT(*), NULL) AS "Number of Returned Rows",
            NULL
        FROM actor
		WHERE actor.last_name = actorName
		OR actor.first_name = actorName;
END #
DELIMITER ;

CALL findActor('chase');