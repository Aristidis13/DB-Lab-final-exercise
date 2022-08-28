/*  insert*/
DELIMITER #
CREATE TRIGGER in_payment
AFTER INSERT ON tvondemand.payment
FOR EACH ROW
BEGIN
INSERT INTO tvondemand.log(username,date_time,success_state,`type`,`table_name`)
VALUES
(current_user(),now(),"Success","INSERT",'payment');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS in_rental;
DELIMITER #
CREATE TRIGGER in_rental
AFTER INSERT ON tvondemand.rental
FOR EACH ROW
BEGIN
INSERT INTO tvondemand.log(username,date_time,success_state,`type`,`table_name`)
VALUES
(current_user(),now(),"Success","INSERT",'rental');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS in_episode;
DELIMITER #
CREATE TRIGGER in_episode
AFTER INSERT ON tvondemand.episode
FOR EACH ROW
BEGIN
INSERT INTO tvondemand.log(username,date_time,success_state,`type`,`table_name`)
VALUES
(current_user(),now(),"Success","INSERT",'episode');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS in_serie;
DELIMITER #
CREATE TRIGGER in_serie
AFTER INSERT ON tvondemand.serie
FOR EACH ROW
BEGIN
INSERT INTO tvondemand.log(username,date_time,success_state,`type`,`table_name`)
VALUES
(current_user(),now(),"Success","INSERT",'serie');
END #
DELIMITER ;

/* Delete */
DROP TRIGGER IF EXISTS del_payment;
DELIMITER #
CREATE TRIGGER del_payment
AFTER DELETE ON tvondemand.payment
FOR EACH ROW
BEGIN
INSERT INTO tvondemand.log(username,date_time,success_state,`type`,`table_name`)
VALUES
(current_user(),now(),"Success","DELETE",'payment');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS del_rental;
DELIMITER #
CREATE TRIGGER del_rental
AFTER DELETE ON tvondemand.rental
FOR EACH ROW
BEGIN
INSERT INTO tvondemand.`log`(username,date_time,success_state,`type`,`table_name`)
VALUES
(current_user(),now(),"Success","DELETE",'rental');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS del_episode;
DELIMITER #
CREATE TRIGGER del_episode
AFTER DELETE ON tvondemand.episode
FOR EACH ROW
BEGIN
INSERT INTO tvondemand.log(username,date_time,success_state,`type`,`table_name`)
VALUES
(current_user(),now(),"Success","DELETE",'episode');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS del_serie;
DELIMITER #
CREATE TRIGGER del_serie
AFTER DELETE ON tvondemand.serie
FOR EACH ROW
BEGIN
INSERT INTO tvondemand.log(username,date_time,success_state,`type`,`table_name`)
VALUES
(current_user(),now(),"Success","DELETE",'serie');
END #
DELIMITER ;

/* Update*/
DROP TRIGGER IF EXISTS update_payment;
DELIMITER #
CREATE TRIGGER update_payment
AFTER UPDATE ON tvondemand.payment
FOR EACH ROW BEGIN
INSERT INTO tvondemand.`log`(username,date_time,success_state,`type`,`table_name`)
VALUES(current_user(),now(),"Success","UPDATE",'payment');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS update_rental;
DELIMITER #
CREATE TRIGGER update_rental
AFTER UPDATE ON tvondemand.rental
FOR EACH ROW BEGIN
INSERT INTO tvondemand.`log`(username,date_time,success_state,`type`,`table_name`)
VALUES(current_user(),now(),"Success","UPDATE",'rental');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS update_episode;
DELIMITER #
CREATE TRIGGER update_episode
AFTER UPDATE ON tvondemand.episode
FOR EACH ROW BEGIN
INSERT INTO tvondemand.`log`(username,date_time,success_state,`type`,`table_name`)
VALUES(current_user(),now(),"Success","UPDATE",'episode');
END #
DELIMITER ;

DROP TRIGGER IF EXISTS update_serie;
DELIMITER #
CREATE TRIGGER update_serie
AFTER UPDATE ON tvondemand.serie
FOR EACH ROW BEGIN
INSERT INTO tvondemand.`log`(username,date_time,success_state,`type`,`table_name`)
VALUES(current_user(),now(),"Success","UPDATE",'serie');
END #
DELIMITER ;

/*4.2 */
DROP TRIGGER IF EXISTS discount_rental;
DELIMITER #
CREATE TRIGGER discount_rental
BEFORE INSERT ON tvondemand.rental
FOR EACH ROW BEGIN
	-- Find how many opuses aka movies or series the customer has rented for the day
    SELECT COUNT(customer_id) INTO @numberOfRented FROM rental 
	WHERE DATE(rental.rental_date) = curdate() AND customer.customer_id = current_user()
    GROUP BY(rental.customer_id);
    
    -- Find the subscription_type of the current user 
    SELECT subscription_type INTO @subscription_type from customer where customer_id = current_user();
    
    -- Lacks the case for the subscription_type='both' case
    IF (@numberOfRented>3 AND @subscription_type='series') THEN
      INSERT INTO `rental`(`rental_date`,`inventory_id`, `customer_id`) VALUES(current_date(),NEW.inventory_id, current_user());
      INSERT INTO `payment` (`customer_id`, `rental_id`, `amount`, `payment_date`) VALUES( current_user(), new.rental_id, '0.1', current_date());
    ELSEIF (@numberOfRented>3 AND @subscription_type='movies') THEN
	  INSERT INTO `rental`(`rental_date`,`inventory_id`, `customer_id`) VALUES(current_date(),NEW.inventory_id, current_user());
      INSERT INTO `payment` (`customer_id`, `rental_id`, `amount`, `payment_date`) VALUES( current_user(), new.rental_id, '0.2', current_date());
    END IF;
END #
DELIMITER ;


/*4.3 Preserve Customer fields*/
/*Το update πραγματοποιείται αλλά το trigger αλλάζει όλα τα πεδία του customer στα προυπάρχοντα πριν το Update.
Αυτό έχει ως αποτελέσμα μη ενημέρωση του πίνακα πρακτικά.
*/
DROP TRIGGER IF EXISTS update_customer ;
DELIMITER #
CREATE TRIGGER update_customer
BEFORE UPDATE ON tvondemand.customer
FOR EACH ROW BEGIN
IF ( current_user()= old.customer_id AND
old.customer_id != new.customer_id
OR OLD.first_name != NEW.first_name
OR OLD.last_name != NEW.last_name
OR old.email != new.email
OR OLD.address_id != NEW.address_id
OR NEW.`active` != OLD.`active`
OR old.subscription_type != new.subscription_type
OR OLD.create_date != NEW.create_date
) THEN
SET
NEW.`customer_id` = OLD.`customer_id`,
NEW.`first_name`= OLD.`first_name`,
NEW.`last_name` = OLD.`last_name`,
NEW.`email`= OLD.`email`,
NEW.`address_id` = OLD.`address_id`,
NEW.`active`= OLD.`active`,
NEW.`subscription_type` = OLD.`subscription_type`,
NEW.`create_date`= OLD.`create_date`;

INSERT INTO `tvondemand`.`customer` (`customer_id`, `first_name`, `last_name`, `email`, `address_id`, `active`, `subscription_type`, `create_date`)
VALUES (NEW.`customer_id`,NEW.`first_name`,NEW.`last_name`,NEW.`email`,NEW.`address_id`,NEW.`active`,NEW.`subscription_type`,NEW.`create_date`);
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'cUSTOMER IS NOTE EDITABLE'; 
END IF;
END #
DELIMITER ;