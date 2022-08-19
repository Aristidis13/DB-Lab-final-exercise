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