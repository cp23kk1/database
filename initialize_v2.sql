-- MySQL Script generated by MySQL Workbench
-- Sat Feb 17 22:49:17 2024
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema vocaverse
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `vocaverse` ;

-- -----------------------------------------------------
-- Schema vocaverse
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `vocaverse` DEFAULT CHARACTER SET utf8 ;
USE `vocaverse` ;

-- -----------------------------------------------------
-- Table `vocaverse`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`user` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(320) NULL,
  `role` ENUM('admin', 'user', 'guest') NOT NULL,
  `display_name` VARCHAR(256) NULL,
  `is_active` TINYINT NOT NULL DEFAULT 1,
  `image` VARCHAR(256) NULL,
  `is_private` TINYINT NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`score_board`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`score_board` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`score_board` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `score` INT NOT NULL,
  `week` INT NOT NULL,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `game_id` VARCHAR(36) NOT NULL,
  `mode` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_score_board_users_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_score_board_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `vocaverse`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`difficulty`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`difficulty` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`difficulty` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `standard` VARCHAR(16) NOT NULL,
  `level` VARCHAR(16) NOT NULL,
  `description` VARCHAR(256) NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`vocabulary`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`vocabulary` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`vocabulary` (
  `id` VARCHAR(36) NOT NULL,
  `vocabulary` VARCHAR(256) NOT NULL,
  `meaning` VARCHAR(256) NOT NULL,
  `definition` VARCHAR(256) NOT NULL,
  `difficulty_id` INT NULL,
  `pos` VARCHAR(256) NOT NULL,
  `tag` VARCHAR(256) NOT NULL,
  `lemma` VARCHAR(256) NOT NULL,
  `dep` VARCHAR(256) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_vocabulary_difficulty1_idx` (`difficulty_id` ASC) VISIBLE,
  CONSTRAINT `fk_vocabulary_difficulty1`
    FOREIGN KEY (`difficulty_id`)
    REFERENCES `vocaverse`.`difficulty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`passage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`passage` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`passage` (
  `id` VARCHAR(36) NOT NULL,
  `title` VARCHAR(256) NOT NULL,
  `difficulty_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_passage_difficulty1_idx` (`difficulty_id` ASC) VISIBLE,
  CONSTRAINT `fk_passage_difficulty1`
    FOREIGN KEY (`difficulty_id`)
    REFERENCES `vocaverse`.`difficulty` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`sentence`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`sentence` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`sentence` (
  `id` VARCHAR(36) NOT NULL,
  `passage_id` VARCHAR(36) NULL,
  `sequence` INT NULL,
  `sentence` VARCHAR(512) NOT NULL,
  `meaning` VARCHAR(1024) NOT NULL,
  `tense` VARCHAR(512) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_sentence_passage1_idx` (`passage_id` ASC) VISIBLE,
  CONSTRAINT `fk_sentence_passage1`
    FOREIGN KEY (`passage_id`)
    REFERENCES `vocaverse`.`passage` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`vocabulary_related`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`vocabulary_related` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`vocabulary_related` (
  `vocabulary_id` VARCHAR(36) NOT NULL,
  `sentence_id` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`vocabulary_id`, `sentence_id`),
  INDEX `fk_vocabulary_has_sentence_sentence1_idx` (`sentence_id` ASC) VISIBLE,
  INDEX `fk_vocabulary_has_sentence_vocabulary1_idx` (`vocabulary_id` ASC) VISIBLE,
  CONSTRAINT `fk_vocabulary_has_sentence_vocabulary1`
    FOREIGN KEY (`vocabulary_id`)
    REFERENCES `vocaverse`.`vocabulary` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vocabulary_has_sentence_sentence1`
    FOREIGN KEY (`sentence_id`)
    REFERENCES `vocaverse`.`sentence` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`vocabulary_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`vocabulary_history` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`vocabulary_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `vocabulary_id` VARCHAR(36) NOT NULL,
  `user_id` INT NOT NULL,
  `game_id` VARCHAR(36) NOT NULL,
  `correctness` TINYINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_vocabulary_history_vocabulary1_idx` (`vocabulary_id` ASC) VISIBLE,
  INDEX `fk_vocabulary_history_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_vocabulary_history_vocabulary1`
    FOREIGN KEY (`vocabulary_id`)
    REFERENCES `vocaverse`.`vocabulary` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_vocabulary_history_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vocaverse`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`sentence_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`sentence_history` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`sentence_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `sentence_id` VARCHAR(36) NOT NULL,
  `user_id` INT NOT NULL,
  `game_id` VARCHAR(36) NOT NULL,
  `correctness` TINYINT NOT NULL,
  `vocabulary_id` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_sentence_history_sentence1_idx` (`sentence_id` ASC) VISIBLE,
  INDEX `fk_sentence_history_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_sentence_history_sentence1`
    FOREIGN KEY (`sentence_id`)
    REFERENCES `vocaverse`.`sentence` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_sentence_history_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vocaverse`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `vocaverse`.`passage_history`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `vocaverse`.`passage_history` ;

CREATE TABLE IF NOT EXISTS `vocaverse`.`passage_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `passage_id` VARCHAR(36) NOT NULL,
  `user_id` INT NOT NULL,
  `game_id` VARCHAR(36) NOT NULL,
  `correctness` TINYINT NOT NULL,
  `sentence_id` VARCHAR(36) NOT NULL,
  `vocabulary_id` VARCHAR(36) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_passage_history_passage1_idx` (`passage_id` ASC) VISIBLE,
  INDEX `fk_passage_history_user1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_passage_history_passage1`
    FOREIGN KEY (`passage_id`)
    REFERENCES `vocaverse`.`passage` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_passage_history_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `vocaverse`.`user` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


CREATE USER IF NOT EXISTS 'cp23kk1'@'%' IDENTIFIED BY 'cp23kk1!_BJY';
GRANT ALL ON *.* TO 'cp23kk1'@'%';