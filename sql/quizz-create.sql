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
CREATE SCHEMA IF NOT EXISTS `quiz` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `quiz` ;

-- -----------------------------------------------------
-- Table `quiz`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`user` ;

CREATE TABLE IF NOT EXISTS `quiz`.`user` (
  `user_id` INT(20) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `pwd` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC));


-- -----------------------------------------------------
-- Table `quiz`.`quiz`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`quiz` ;

CREATE TABLE IF NOT EXISTS `quiz`.`quiz` (
  `quiz_id` INT(20) NOT NULL,
  `user_id` INT(20) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`quiz_id`),
  INDEX `fk_Quizz_user1_idx` (`user_id` ASC),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC),
  CONSTRAINT `fk_Quizz_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `quiz`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `quiz`.`question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`question` ;

CREATE TABLE IF NOT EXISTS `quiz`.`question` (
  `question_id` INT(20) NOT NULL,
  `question_text` VARCHAR(255) NULL,
  PRIMARY KEY (`question_id`));


-- -----------------------------------------------------
-- Table `quiz`.`option`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`option` ;

CREATE TABLE IF NOT EXISTS `quiz`.`option` (
  `option_id` INT(20) NOT NULL,
  `question_id` INT(20) NOT NULL,
  `option_text` VARCHAR(255) NULL,
  `is_correct` TINYINT(1) NULL,
  PRIMARY KEY (`option_id`),
  INDEX `fk_Options_Question1_idx` (`question_id` ASC),
  CONSTRAINT `fk_Options_Question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `quiz`.`question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `quiz`.`test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`test` ;

CREATE TABLE IF NOT EXISTS `quiz`.`test` (
  `test_id` INT(20) NOT NULL,
  `quiz_id` INT(20) NOT NULL,
  `user_id` INT(20) NOT NULL,
  `start_time` DATETIME NULL DEFAULT now(),
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
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `quiz`.`quiz_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `quiz`.`quiz_question` ;

CREATE TABLE IF NOT EXISTS `quiz`.`quiz_question` (
  `quiz_id` INT NOT NULL,
  `question_id` INT(20) NOT NULL,
  PRIMARY KEY (`quiz_id`, `question_id`),
  INDEX `fk_Quizz_has_Question_Question1_idx` (`question_id` ASC),
  INDEX `fk_Quizz_has_Question_Quizz1_idx` (`quiz_id` ASC),
  CONSTRAINT `fk_Quizz_has_Question_Quizz1`
    FOREIGN KEY (`quiz_id`)
    REFERENCES `quiz`.`quiz` (`quiz_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Quizz_has_Question_Question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `quiz`.`question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


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
  CONSTRAINT `fk_Test_has_Options_Test1`
    FOREIGN KEY (`test_id`)
    REFERENCES `quiz`.`test` (`test_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_has_Options_Options1`
    FOREIGN KEY (`option_id`)
    REFERENCES `quiz`.`option` (`option_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


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