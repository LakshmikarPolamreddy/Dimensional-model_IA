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
-- -----------------------------------------------------
-- Schema dav6100_db_2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema dav6100_db_2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `dav6100_db_2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`product_dim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`product_dim` (
  `product_dim_key` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NULL,
  `item_id` INT NULL,
  `product_description` VARCHAR(500) NULL,
  `product_sub_category` INT NULL,
  PRIMARY KEY (`product_dim_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`order_dim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`order_dim` (
  `order_dim_key` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NULL,
  `order_status` VARCHAR(45) NULL,
  PRIMARY KEY (`order_dim_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`supplier_dim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`supplier_dim` (
  `supplier_dim_key` INT NOT NULL AUTO_INCREMENT,
  `supplier_id` INT NULL,
  `supplier_name` VARCHAR(100) NULL,
  `supplier_status` VARCHAR(10) NULL,
  `Supplier_country` VARCHAR(100) NULL,
  PRIMARY KEY (`supplier_dim_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Date_dim`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Date_dim` (
  `date_dim_key` INT NOT NULL AUTO_INCREMENT,
  `order_id` INT NULL,
  `Delivery_date` VARCHAR(20) NULL,
  `Date_day` INT NULL,
  `Date_week` INT NULL,
  `date_month` INT NULL,
  `date_quarter` INT NULL,
  `Date_year` INT NULL,
  PRIMARY KEY (`date_dim_key`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`order_fact`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`order_fact` (
  `order_key` INT NULL,
  `product_key` INT NULL,
  `supplier_key` INT NULL,
  `date_key` INT NULL,
  `Item_quantity` INT NULL,
  `item_amount` FLOAT NULL,
  INDEX `product_item_key_idx` (`product_key` ASC) VISIBLE,
  INDEX `order_id_key_idx` (`order_key` ASC) VISIBLE,
  INDEX `supplier_sup_id_idx` (`supplier_key` ASC) VISIBLE,
  INDEX `invoice_date_key_idx` (`date_key` ASC) VISIBLE,
  CONSTRAINT `product_item_key`
    FOREIGN KEY (`product_key`)
    REFERENCES `mydb`.`product_dim` (`product_dim_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_id_key`
    FOREIGN KEY (`order_key`)
    REFERENCES `mydb`.`order_dim` (`order_dim_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `supplier_sup_id`
    FOREIGN KEY (`supplier_key`)
    REFERENCES `mydb`.`supplier_dim` (`supplier_dim_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `invoice_date_key`
    FOREIGN KEY (`date_key`)
    REFERENCES `mydb`.`Date_dim` (`date_dim_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `dav6100_db_2` ;

-- -----------------------------------------------------
-- Table `dav6100_db_2`.`r_base_stat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`r_base_stat` (
  `status_code` VARCHAR(5) NOT NULL,
  `tdesc_name` VARCHAR(50) NOT NULL,
  `status_label_en` VARCHAR(100) NULL DEFAULT NULL,
  INDEX `idx_r_base_stat_status_code` (`status_code` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dav6100_db_2`.`r_ctry`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`r_ctry` (
  `country_code` VARCHAR(10) NULL DEFAULT NULL,
  `country_label_en` VARCHAR(100) NULL DEFAULT NULL,
  INDEX `idx_r_ctry_country_code` (`country_code` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dav6100_db_2`.`t_sup_supplier`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`t_sup_supplier` (
  `sup_id` VARCHAR(50) NOT NULL,
  `status_code` VARCHAR(50) NULL DEFAULT NULL,
  `country_code` VARCHAR(10) NULL DEFAULT NULL,
  `sup_name_en` VARCHAR(1024) NULL DEFAULT NULL,
  PRIMARY KEY (`sup_id`),
  INDEX `FK_r_ctry` (`country_code` ASC) VISIBLE,
  INDEX `FK_status_code` (`status_code` ASC) VISIBLE,
  CONSTRAINT `FK_r_ctry`
    FOREIGN KEY (`country_code`)
    REFERENCES `dav6100_db_2`.`r_ctry` (`country_code`),
  CONSTRAINT `FK_status_code`
    FOREIGN KEY (`status_code`)
    REFERENCES `dav6100_db_2`.`r_base_stat` (`status_code`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dav6100_db_2`.`t_ctr_amt`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`t_ctr_amt` (
  `doc_cd` VARCHAR(8) NOT NULL,
  `doc_dept_cd` VARCHAR(4) NOT NULL,
  `doc_id` VARCHAR(20) NOT NULL,
  `doc_bfy` INT NULL DEFAULT NULL,
  `orig_max_am` VARCHAR(50) NULL DEFAULT NULL,
  `sup_id` VARCHAR(50) NOT NULL,
  `status_code` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`doc_cd`, `doc_dept_cd`, `doc_id`),
  INDEX `idx_t_ctr_amt_status_code` (`status_code` ASC) VISIBLE,
  INDEX `idx_t_ctr_amt_sup_id` (`sup_id` ASC) VISIBLE,
  CONSTRAINT `FK_status_code_ctr`
    FOREIGN KEY (`status_code`)
    REFERENCES `dav6100_db_2`.`r_base_stat` (`status_code`),
  CONSTRAINT `FK_sup_id_ctr`
    FOREIGN KEY (`sup_id`)
    REFERENCES `dav6100_db_2`.`t_sup_supplier` (`sup_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dav6100_db_2`.`r_prod`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`r_prod` (
  `item_id` VARCHAR(11) NOT NULL,
  `prod_id` VARCHAR(11) NULL DEFAULT NULL,
  `prod_desc` VARCHAR(1024) NULL DEFAULT NULL,
  `fam_node` VARCHAR(50) NULL DEFAULT NULL,
  `fam_level` VARCHAR(50) NULL DEFAULT NULL,
  `comm_cd` VARCHAR(50) NULL DEFAULT NULL,
  `sup_id` VARCHAR(50) NULL DEFAULT NULL,
  `item_quantity` VARCHAR(50) NULL DEFAULT NULL,
  `item_price` VARCHAR(19) NULL DEFAULT NULL,
  `ctr_ref_doc_cd` VARCHAR(8) NULL DEFAULT NULL,
  `ctr_ref_doc_dept_cd` VARCHAR(5) NULL DEFAULT NULL,
  `ctr_ref_doc_id` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`item_id`),
  INDEX `idx_r_prod_prod_id` (`prod_id` ASC) VISIBLE,
  INDEX `idx_r_prod_item_id` (`item_id` ASC) VISIBLE,
  INDEX `idx_r_prod_sup_id` (`sup_id` ASC) VISIBLE,
  INDEX `FK_ctr_id_prod` (`ctr_ref_doc_cd` ASC, `ctr_ref_doc_dept_cd` ASC, `ctr_ref_doc_id` ASC) VISIBLE,
  CONSTRAINT `FK_ctr_id_prod`
    FOREIGN KEY (`ctr_ref_doc_cd` , `ctr_ref_doc_dept_cd` , `ctr_ref_doc_id`)
    REFERENCES `dav6100_db_2`.`t_ctr_amt` (`doc_cd` , `doc_dept_cd` , `doc_id`),
  CONSTRAINT `FK_sup_id_prod`
    FOREIGN KEY (`sup_id`)
    REFERENCES `dav6100_db_2`.`t_sup_supplier` (`sup_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dav6100_db_2`.`t_ord_order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`t_ord_order` (
  `ord_id` VARCHAR(11) NOT NULL,
  `ord_ackn_dt` VARCHAR(10) NULL DEFAULT NULL,
  `ord_appr_dt` VARCHAR(10) NULL DEFAULT NULL,
  `ord_disp_dt` VARCHAR(10) NULL DEFAULT NULL,
  `status_code` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`ord_id`),
  UNIQUE INDEX `idx_t_ord_order_ord_id` (`ord_id` ASC) INVISIBLE,
  INDEX `FK_status_code_order_idx` (`status_code` ASC) VISIBLE,
  INDEX `FK_status_code_order_table_idx` (`status_code` ASC) VISIBLE,
  INDEX `idx_t_ord_order_status_code` (`status_code` ASC) VISIBLE,
  CONSTRAINT `FK_status_code_order_header`
    FOREIGN KEY (`status_code`)
    REFERENCES `dav6100_db_2`.`r_base_stat` (`status_code`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dav6100_db_2`.`t_ord_delivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`t_ord_delivery` (
  `deliv_id` VARCHAR(11) NOT NULL,
  `ord_id` VARCHAR(11) NULL DEFAULT NULL,
  `status_code` VARCHAR(50) NULL DEFAULT NULL,
  `deliv_dt` VARCHAR(10) NULL DEFAULT NULL,
  `deliv_appr_dt` VARCHAR(23) NULL DEFAULT NULL,
  PRIMARY KEY (`deliv_id`),
  INDEX `FK_ord_id_delivery` (`ord_id` ASC) VISIBLE,
  INDEX `FK_status_code_delivery` (`status_code` ASC) VISIBLE,
  CONSTRAINT `FK_ord_id_delivery`
    FOREIGN KEY (`ord_id`)
    REFERENCES `dav6100_db_2`.`t_ord_order` (`ord_id`),
  CONSTRAINT `FK_status_code_delivery`
    FOREIGN KEY (`status_code`)
    REFERENCES `dav6100_db_2`.`r_base_stat` (`status_code`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dav6100_db_2`.`t_ord_invoice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`t_ord_invoice` (
  `invoice_id` INT NOT NULL,
  `invoice_amount` VARCHAR(19) NULL DEFAULT NULL,
  `invoice_sub_dt` VARCHAR(23) NULL DEFAULT NULL,
  `invoice_appr_dt` VARCHAR(23) NULL DEFAULT NULL,
  `invoice_pay_amt` VARCHAR(19) NULL DEFAULT NULL,
  `discount_amt` VARCHAR(19) NULL DEFAULT NULL,
  `ord_id` VARCHAR(11) NULL DEFAULT NULL,
  `sched_pay_dt` VARCHAR(23) NULL DEFAULT NULL,
  `disb_dt` VARCHAR(23) NULL DEFAULT NULL,
  `status_code` VARCHAR(50) NULL DEFAULT NULL,
  PRIMARY KEY (`invoice_id`),
  INDEX `idx_t_ord_invoice_status_code` (`status_code` ASC) VISIBLE,
  INDEX `FK_ord_id_invoice` (`ord_id` ASC) VISIBLE,
  CONSTRAINT `FK_ord_id_invoice`
    FOREIGN KEY (`ord_id`)
    REFERENCES `dav6100_db_2`.`t_ord_order` (`ord_id`),
  CONSTRAINT `FK_status_code_invoice`
    FOREIGN KEY (`status_code`)
    REFERENCES `dav6100_db_2`.`r_base_stat` (`status_code`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `dav6100_db_2`.`t_ord_item`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `dav6100_db_2`.`t_ord_item` (
  `oitem_id` VARCHAR(11) NULL DEFAULT NULL,
  `item_id` VARCHAR(11) NULL DEFAULT NULL,
  `ord_id` VARCHAR(11) NULL DEFAULT NULL,
  `ord_line_type` VARCHAR(10) NULL DEFAULT NULL,
  `ord_item_qty` INT NULL DEFAULT NULL,
  `ord_item_amt` VARCHAR(19) NULL DEFAULT NULL,
  `prod_id` VARCHAR(11) NULL DEFAULT NULL,
  `ctr_ref_doc_cd` VARCHAR(8) NULL DEFAULT NULL,
  `ctr_ref_doc_id` VARCHAR(20) NULL DEFAULT NULL,
  `ctr_ref_doc_dept_cd` VARCHAR(5) NULL DEFAULT NULL,
  `item_label` VARCHAR(255) NULL DEFAULT NULL,
  `comm_cd` VARCHAR(20) NULL DEFAULT NULL,
  `sup_id` VARCHAR(50) NULL DEFAULT NULL,
  `status_code` VARCHAR(50) NULL DEFAULT NULL,
  UNIQUE INDEX `idx_t_ord_item_oitem_id` (`oitem_id` ASC) VISIBLE,
  INDEX `idx_t_ord_item_status_code` (`status_code` ASC) VISIBLE,
  INDEX `FK_order_id_idx` (`ord_id` ASC) VISIBLE,
  INDEX `FK_sup_id_oitem` (`sup_id` ASC) VISIBLE,
  INDEX `FK_ctr_id` (`ctr_ref_doc_cd` ASC, `ctr_ref_doc_dept_cd` ASC, `ctr_ref_doc_id` ASC) VISIBLE,
  INDEX `FK_prod_id` (`prod_id` ASC) VISIBLE,
  INDEX `FK_item_id` (`item_id` ASC) VISIBLE,
  CONSTRAINT `FK_ctr_id`
    FOREIGN KEY (`ctr_ref_doc_cd` , `ctr_ref_doc_dept_cd` , `ctr_ref_doc_id`)
    REFERENCES `dav6100_db_2`.`t_ctr_amt` (`doc_cd` , `doc_dept_cd` , `doc_id`),
  CONSTRAINT `FK_item_id`
    FOREIGN KEY (`item_id`)
    REFERENCES `dav6100_db_2`.`r_prod` (`item_id`),
  CONSTRAINT `FK_prod_id`
    FOREIGN KEY (`prod_id`)
    REFERENCES `dav6100_db_2`.`r_prod` (`prod_id`),
  CONSTRAINT `FK_status_code_oitem`
    FOREIGN KEY (`status_code`)
    REFERENCES `dav6100_db_2`.`r_base_stat` (`status_code`),
  CONSTRAINT `FK_status_code_order`
    FOREIGN KEY (`status_code`)
    REFERENCES `dav6100_db_2`.`r_base_stat` (`status_code`),
  CONSTRAINT `FK_sup_id_oitem`
    FOREIGN KEY (`sup_id`)
    REFERENCES `dav6100_db_2`.`t_sup_supplier` (`sup_id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Inserting Data into product_dim Table

insert into mydb.product_dim(
product_id, item_id, product_description, product_sub_category)
select prod_id, item_id, prod_desc, fam_node 
from dav6100_db_2.r_prod prod
where not exists(
select 2 from mydb.product_dim product
where 2 = 2
and product.product_id= prod.prod_id);

-- Inserting Data into order_dim Table

insert into mydb.order_dim(
order_id,  order_status)
select ord_id, status_code
from dav6100_db_2.t_ord_delivery ord1
where not exists(
select 1 from mydb.order_dim order2
where 1 = 1
and order2.order_id= ord1.ord_id);

-- Inserting Data into supplier_dim Table

insert into mydb.supplier_dim(
supplier_id, supplier_name, supplier_status, supplier_country)
select supplier1.sup_id, supplier1.sup_name_en, supplier1.status_code, rc.country_label_en
from dav6100_db_2.t_sup_supplier supplier1 
join dav6100_db_2.r_ctry  rc on supplier1.country_code=rc.country_code
where not exists(
select 1 from mydb.supplier_dim supplier2
where 1 = 1
and supplier2.supplier_id= supplier2.supplier_id);

-- Inserting Data into date_dim Table

insert into mydb.date_dim(
delivery_date,order_id, date_day, date_week, date_month, date_quarter, date_year)
SELECT deliv_dt as Delivery_date, ord_id,
DAY(STR_TO_DATE(deliv_dt, '%m/%d/%Y')) AS order_day,
WEEK(STR_TO_DATE(deliv_dt, '%m/%d/%Y')) AS order_week,
MONTH(STR_TO_DATE(deliv_dt, '%m/%d/%Y')) AS order_month,
QUARTER(STR_TO_DATE(deliv_dt, '%m/%d/%Y')) AS order_quarter,
YEAR(STR_TO_DATE(deliv_dt, '%m/%d/%Y')) order_year
					FROM dav6100_db_2.t_ord_delivery;
                    
-- Inserting Data into order_fact Table                    
				
insert into mydb.order_fact (order_key, product_key, supplier_key, date_key, 
item_quantity, item_amount)
select od.order_dim_key, pd.product_dim_key , sd.supplier_dim_key, dd.date_dim_key, 
ot.ord_item_qty, ot.ord_item_amt 
from dav6100_db_2.t_ord_item ot 
join mydb.order_dim od on ot.ord_id=od.order_id
join mydb.product_dim pd on pd.item_id=ot.item_id
join mydb.supplier_dim sd on ot.sup_id=sd.supplier_id
join mydb.date_dim dd on dd.order_id=ot.ord_id
group by 1,2,3,4,5,6
order by 1 asc;


