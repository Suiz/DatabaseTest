-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema quiz
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `quiz` ;

-- -----------------------------------------------------
-- Schema quiz
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `quiz` DEFAULT CHARACTER SET utf8 ;
USE `quiz` ;

-- -----------------------------------------------------
-- Table `quiz`.`question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`question` ;

CREATE TABLE IF NOT EXISTS `quiz`.`question` (
  `question_id` INT(20) NOT NULL AUTO_INCREMENT,
  `question_text` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`question_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `quiz`.`option`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`option` ;

CREATE TABLE IF NOT EXISTS `quiz`.`option` (
  `option_id` INT(20) NOT NULL AUTO_INCREMENT,
  `question_id` INT(20) NOT NULL,
  `option_text` VARCHAR(255) NULL DEFAULT NULL,
  `is_correct` TINYINT(1) NULL DEFAULT NULL,
  PRIMARY KEY (`option_id`),
  INDEX `fk_Options_Question1_idx` (`question_id` ASC),
  CONSTRAINT `fk_Options_Question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `quiz`.`question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `quiz`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`user` ;

CREATE TABLE IF NOT EXISTS `quiz`.`user` (
  `user_id` INT(20) NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(45) NOT NULL,
  `pwd` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `quiz`.`quiz`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`quiz` ;

CREATE TABLE IF NOT EXISTS `quiz`.`quiz` (
  `quiz_id` INT(20) NOT NULL AUTO_INCREMENT,
  `user_id` INT(20) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`quiz_id`),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC),
  INDEX `fk_Quizz_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_Quizz_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `quiz`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `quiz`.`test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`test` ;

CREATE TABLE IF NOT EXISTS `quiz`.`test` (
  `test_id` INT(20) NOT NULL AUTO_INCREMENT,
  `quiz_id` INT(20) NOT NULL,
  `user_id` INT(20) NOT NULL,
  `start_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`test_id`),
  INDEX `fk_Test_Quizz1_idx` (`quiz_id` ASC),
  INDEX `fk_Test_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_Test_Quizz1`
    FOREIGN KEY (`quiz_id`)
    REFERENCES `quiz`.`quiz` (`quiz_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `quiz`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `quiz`.`answer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`answer` ;

CREATE TABLE IF NOT EXISTS `quiz`.`answer` (
  `test_id` INT(20) NOT NULL,
  `option_id` INT(20) NOT NULL,
  PRIMARY KEY (`test_id`, `option_id`),
  INDEX `fk_Test_has_Options_Options1_idx` (`option_id` ASC),
  INDEX `fk_Test_has_Options_Test1_idx` (`test_id` ASC),
  CONSTRAINT `fk_Test_has_Options_Options1`
    FOREIGN KEY (`option_id`)
    REFERENCES `quiz`.`option` (`option_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_has_Options_Test1`
    FOREIGN KEY (`test_id`)
    REFERENCES `quiz`.`test` (`test_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `quiz`.`quiz_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`quiz_question` ;

CREATE TABLE IF NOT EXISTS `quiz`.`quiz_question` (
  `quiz_id` INT(11) NOT NULL AUTO_INCREMENT,
  `question_id` INT(20) NOT NULL,
  PRIMARY KEY (`quiz_id`, `question_id`),
  INDEX `fk_Quizz_has_Question_Question1_idx` (`question_id` ASC),
  INDEX `fk_Quizz_has_Question_Quizz1_idx` (`quiz_id` ASC),
  CONSTRAINT `fk_Quizz_has_Question_Question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `quiz`.`question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Quizz_has_Question_Quizz1`
    FOREIGN KEY (`quiz_id`)
    REFERENCES `quiz`.`quiz` (`quiz_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

USE `quiz` ;

-- -----------------------------------------------------
-- procedure quiz_reset
-- -----------------------------------------------------

USE `quiz`;
DROP procedure IF EXISTS `quiz`.`quiz_reset`;

DELIMITER $$
USE `quiz`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `quiz_reset`()
BEGIN
	SET FOREIGN_KEY_CHECKS=0;

	TRUNCATE TABLE answer;
	TRUNCATE TABLE test;
	TRUNCATE TABLE `option`;
	TRUNCATE TABLE quiz_question;
	TRUNCATE TABLE question;
	TRUNCATE TABLE quiz;
	TRUNCATE TABLE user;
    
 	SET FOREIGN_KEY_CHECKS=1;
   
    ALTER TABLE test AUTO_INCREMENT 1;
    ALTER TABLE `option` AUTO_INCREMENT 1;
    ALTER TABLE question AUTO_INCREMENT 1;
    ALTER TABLE quiz AUTO_INCREMENT 1;
    ALTER TABLE user AUTO_INCREMENT 1;

	START TRANSACTION;
	INSERT INTO user (user_id, email, pwd) VALUES
	(1, 'dev.sinha@gmail.com', 'india');

	INSERT INTO quiz (quiz_id, user_id, title) VALUES
	(1, 1, 'test1'),
	(2, 1, 'test2'),
	(3, 1, 'test3');

	INSERT INTO question (question_id, question_text) VALUES
	(1, 'What is the capital of France?'),
	(2, 'Which is the largest country in world?'),
	(3, 'Who is the Prime Minister of India?');

	INSERT INTO `option` (option_id, question_id, option_text, is_correct) VALUES
	(1, 1, 'Madrid', 0),
	(2, 1, 'Paris', 1),
	(3, 1, 'Amsterdam', 0),
	(4, 1, 'Berlin', 0),
	(5, 2, 'Russia', 1),
	(6, 2, 'USA', 0),
	(7, 2, 'India', 0),
	(8, 2, 'China', 0),
	(9, 3, 'Debdutta Dey', 0),
	(10, 3, 'Manmohan Sing', 0),
	(11, 3, 'Narendra Modi', 1),
	(12, 3, 'Pranab Mukharjee', 0);

	INSERT INTO quiz_question (quiz_id, question_id) VALUES
	(1, 1),
	(1, 2),
	(1, 3);

	INSERT INTO test (test_id, quiz_id, user_id, start_time) VALUES
	(1, 1, 1, '2015-02-13 10:01:10'),
	(2, 2, 1, '2015-02-13 10:01:10'),
	(3, 3, 1, '2015-02-13 10:01:10');

	INSERT INTO answer (test_id, option_id) VALUES
	(1, 1),
	(1, 5),
	(1, 12);
    
    COMMIT;
END$$

DELIMITER ;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/* Create a user to be used in PHP for the connection,
 * and give him all grants on the DB.
 */
-- Delete the user ...
DELETE FROM mysql.user WHERE user='quiz_user' ;
-- and his grants
DELETE FROM mysql.db WHERE user='quiz_user' ;
DELETE FROM mysql.tables_priv WHERE user='quiz_user' ;
FLUSH PRIVILEGES ;
-- Create him
CREATE USER quiz_user@localhost IDENTIFIED by 'quiz_password' ;
-- Grant him rights on the DB ...
GRANT ALL ON quiz.* TO quiz_user@localhost ;
-- and on the stored procedure
GRANT SELECT ON mysql.proc TO quiz_user@localhost ;


call quiz_reset()$$