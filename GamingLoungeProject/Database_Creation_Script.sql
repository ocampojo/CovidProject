-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`guests`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`guests` (
  `Guest_Name` VARCHAR(45) NOT NULL,
  `party_size` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Guest_Name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`employee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`employee` (
  `employee_id` INT NOT NULL,
  `employee_salary` VARCHAR(45) NOT NULL,
  `ESSN` VARCHAR(45) NOT NULL,
  `Employee_Name` VARCHAR(45) NOT NULL,
  `guests_Guest_Name` VARCHAR(45) NULL,
  PRIMARY KEY (`employee_id`),
  INDEX `fk_employee_guests1_idx` (`guests_Guest_Name` ASC) VISIBLE,
  CONSTRAINT `fk_employee_guests1`
    FOREIGN KEY (`guests_Guest_Name`)
    REFERENCES `mydb`.`guests` (`Guest_Name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`services`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`services` (
  `service_name` VARCHAR(45) NOT NULL,
  `service_cost` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`service_name`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`supplies`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`supplies` (
  `equipment_id` INT NOT NULL,
  `equipment_cost` INT NOT NULL,
  `food_products` VARCHAR(45) NOT NULL,
  `food_cost` VARCHAR(45) NOT NULL,
  `services_service_name` VARCHAR(45) NULL,
  PRIMARY KEY (`equipment_id`),
  INDEX `fk_supplies_services1_idx` (`services_service_name` ASC) VISIBLE,
  CONSTRAINT `fk_supplies_services1`
    FOREIGN KEY (`services_service_name`)
    REFERENCES `mydb`.`services` (`service_name`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`events`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`events` (
  `event_name` VARCHAR(45) NOT NULL,
  `date` VARCHAR(45) NOT NULL,
  `people` VARCHAR(45) NOT NULL,
  `supplies_equipment_id` INT NULL,
  PRIMARY KEY (`event_name`),
  INDEX `fk_events_supplies1_idx` (`supplies_equipment_id` ASC) VISIBLE,
  CONSTRAINT `fk_events_supplies1`
    FOREIGN KEY (`supplies_equipment_id`)
    REFERENCES `mydb`.`supplies` (`equipment_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`gaming_lounge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`gaming_lounge` (
  `store_id` INT NOT NULL,
  `address` VARCHAR(45) NULL DEFAULT NULL,
  `phone` VARCHAR(45) NULL DEFAULT NULL,
  `employee_employee_id` INT NULL,
  PRIMARY KEY (`store_id`),
  INDEX `fk_gaming_lounge_employee_idx` (`employee_employee_id` ASC) VISIBLE,
  CONSTRAINT `fk_gaming_lounge_employee`
    FOREIGN KEY (`employee_employee_id`)
    REFERENCES `mydb`.`employee` (`employee_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `mydb`.`menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`menu` (
  `drinks` VARCHAR(45) NOT NULL,
  `drink_price` INT NOT NULL,
  `food` VARCHAR(45) NOT NULL,
  `food_price` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`drinks`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
