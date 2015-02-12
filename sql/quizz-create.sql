-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`user` (
  `user_id` INT(20) NOT NULL,
  PRIMARY KEY (`user_id`));


-- -----------------------------------------------------
-- Table `mydb`.`Quizz`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Quizz` (
  `Quizz_id` INT(20) NOT NULL,
  `user_id` INT(20) NOT NULL,
  PRIMARY KEY (`Quizz_id`),
  INDEX `fk_Quizz_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_Quizz_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `mydb`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Question` (
  `Question_id` INT(20) NOT NULL,
  PRIMARY KEY (`Question_id`));


-- -----------------------------------------------------
-- Table `mydb`.`option`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`option` (
  `Options_id` INT(20) NOT NULL,
  `Question_id` INT(20) NOT NULL,
  PRIMARY KEY (`Options_id`),
  INDEX `fk_Options_Question1_idx` (`Question_id` ASC),
  CONSTRAINT `fk_Options_Question1`
    FOREIGN KEY (`Question_id`)
    REFERENCES `mydb`.`Question` (`Question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Test`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Test` (
  `test_id` INT(20) NOT NULL,
  `Quizz_id` INT(20) NOT NULL,
  `user_id` INT(20) NOT NULL,
  PRIMARY KEY (`test_id`),
  INDEX `fk_Test_Quizz1_idx` (`Quizz_id` ASC),
  INDEX `fk_Test_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_Test_Quizz1`
    FOREIGN KEY (`Quizz_id`)
    REFERENCES `mydb`.`Quizz` (`Quizz_id`)
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
CREATE TABLE IF NOT EXISTS `mydb`.`Options_has_Question` (
  `option_nbr` INT(20) NOT NULL,
  `question_no` INT(20) NOT NULL,
  PRIMARY KEY (`option_nbr`, `question_no`));


-- -----------------------------------------------------
-- Table `mydb`.`quizz_question`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`quizz_question` (
  `Quizz_id` INT(20) NOT NULL,
  `Question_id` INT(20) NOT NULL,
  PRIMARY KEY (`Quizz_id`, `Question_id`),
  INDEX `fk_Quizz_has_Question_Question1_idx` (`Question_id` ASC),
  INDEX `fk_Quizz_has_Question_Quizz1_idx` (`Quizz_id` ASC),
  CONSTRAINT `fk_Quizz_has_Question_Quizz1`
    FOREIGN KEY (`Quizz_id`)
    REFERENCES `mydb`.`Quizz` (`Quizz_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Quizz_has_Question_Question1`
    FOREIGN KEY (`Question_id`)
    REFERENCES `mydb`.`Question` (`Question_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`answer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`answer` (
  `test_id` INT(20) NOT NULL,
  `Options_id` INT(20) NOT NULL,
  PRIMARY KEY (`test_id`, `Options_id`),
  INDEX `fk_Test_has_Options_Options1_idx` (`Options_id` ASC),
  INDEX `fk_Test_has_Options_Test1_idx` (`test_id` ASC),
  CONSTRAINT `fk_Test_has_Options_Test1`
    FOREIGN KEY (`test_id`)
    REFERENCES `mydb`.`Test` (`test_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Test_has_Options_Options1`
    FOREIGN KEY (`Options_id`)
    REFERENCES `mydb`.`option` (`Options_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
