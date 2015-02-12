-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`user` ;

CREATE TABLE IF NOT EXISTS `mydb`.`user` (
  `user_id` INT(20) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `pwd` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC));


-- -----------------------------------------------------
-- Table `mydb`.`Quizz`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Quizz` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Quizz` (
  `quizz_id` INT(20) NOT NULL,
  `user_id` INT(20) NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`quizz_id`),
  INDEX `fk_Quizz_user1_idx` (`user_id` ASC),
  UNIQUE INDEX `title_UNIQUE` (`title` ASC),
  CONSTRAINT `fk_Quizz_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Question` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Question` (
  `question_id` INT(20) NOT NULL,
  `question_text` VARCHAR(255) NULL,
  PRIMARY KEY (`question_id`));


-- -----------------------------------------------------
-- Table `mydb`.`option`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`option` ;

CREATE TABLE IF NOT EXISTS `mydb`.`option` (
  `option_id` INT(20) NOT NULL,
  `question_id` INT(20) NOT NULL,
  `option_text` VARCHAR(255) NULL,
  `is_correct` TINYINT(1) NULL,
  PRIMARY KEY (`option_id`),
  INDEX `fk_Options_Question1_idx` (`question_id` ASC),
  CONSTRAINT `fk_Options_Question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `mydb`.`Question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Test` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Test` (
  `test_id` INT(20) NOT NULL,
  `quizz_id` INT(20) NOT NULL,
  `user_id` INT(20) NOT NULL,
  `start_time` DATETIME NULL DEFAULT now(),
  PRIMARY KEY (`test_id`),
  INDEX `fk_Test_Quizz1_idx` (`quizz_id` ASC),
  INDEX `fk_Test_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_Test_Quizz1`
    FOREIGN KEY (`quizz_id`)
    REFERENCES `mydb`.`Quizz` (`quizz_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Options_has_Question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Options_has_Question` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Options_has_Question` (
  `option_nbr` INT(20) NOT NULL,
  `question_no` INT(20) NOT NULL,
  PRIMARY KEY (`option_nbr`, `question_no`));


-- -----------------------------------------------------
-- Table `mydb`.`quizz_question`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`quizz_question` ;

CREATE TABLE IF NOT EXISTS `mydb`.`quizz_question` (
  `quizz_id` INT NOT NULL,
  `question_id` INT(20) NOT NULL,
  PRIMARY KEY (`quizz_id`, `question_id`),
  INDEX `fk_Quizz_has_Question_Question1_idx` (`question_id` ASC),
  INDEX `fk_Quizz_has_Question_Quizz1_idx` (`quizz_id` ASC),
  CONSTRAINT `fk_Quizz_has_Question_Quizz1`
    FOREIGN KEY (`quizz_id`)
    REFERENCES `mydb`.`Quizz` (`quizz_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Quizz_has_Question_Question1`
    FOREIGN KEY (`question_id`)
    REFERENCES `mydb`.`Question` (`question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`answer`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`answer` ;

CREATE TABLE IF NOT EXISTS `mydb`.`answer` (
  `test_id` INT(20) NOT NULL,
  `option_id` INT(20) NOT NULL,
  PRIMARY KEY (`test_id`, `option_id`),
  INDEX `fk_Test_has_Options_Options1_idx` (`option_id` ASC),
  INDEX `fk_Test_has_Options_Test1_idx` (`test_id` ASC),
  CONSTRAINT `fk_Test_has_Options_Test1`
    FOREIGN KEY (`test_id`)
    REFERENCES `mydb`.`Test` (`test_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_has_Options_Options1`
    FOREIGN KEY (`option_id`)
    REFERENCES `mydb`.`option` (`option_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
