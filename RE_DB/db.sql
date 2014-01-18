-- v1.3
-- Removed data_ins_TS as PK due to need to make multiple inserts unique
-- Made prop_url limited 255 due to 767byte limit for MySQL keys
CREATE TABLE `auction_results` (
        `prop_street_address` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
        `prop_suburb` VARCHAR( 100 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
        `prop_num_bedrooms` TINYINT( 5 ) NULL,
        `prop_sale_price` DOUBLE( 22, 0 ) NULL,
        `prop_type` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `prop_url` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `auc_method` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `auc_saledate` VARCHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `auc_agent` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `data_source` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
        `data_ins_TS` TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         PRIMARY KEY ( `prop_url`,`prop_suburb`,`prop_street_address`,`prop_type`,`prop_sale_price`,`auc_method`,`auc_saledate`,`data_source` )
 )
CHARACTER SET = utf8

-- v1.2
/*
CREATE TABLE `auction_results` (
        `prop_street_address` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
        `prop_suburb` VARCHAR( 100 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
        `prop_num_bedrooms` TINYINT( 5 ) NULL,
        `prop_sale_price` DOUBLE( 22, 0 ) NULL,
        `prop_type` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `auc_method` VARCHAR( 50 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `auc_saledate` VARCHAR( 30 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `auc_agent` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NULL,
        `data_source` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
        `data_ins_TS` TIMESTAMP NOT NULL ON UPDATE CURRENT_TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
         PRIMARY KEY ( `prop_suburb`,`prop_street_address`,`prop_type`,`prop_sale_price`,`auc_saledate`,`data_ins_TS`,`data_source` )
 )
CHARACTER SET = utf8
*/

-- v1.0
CREATE TABLE `suburbs` ( 
	`City` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, 
	`Postcode` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, 
	`Suburb` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL, 
	`Council` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
	 PRIMARY KEY ( `City`,`Suburb` )
 )
CHARACTER SET = utf8

-- v1.0
CREATE VIEW reiv_src_url
AS
SELECT concat('http://www.realestateview.com.au/portal/propertydata?rm=salesauctionresults&state=victoria&suburb=', REPLACE(suburb, ' ', '%20'), '&postcode=') url FROM suburbs
WHERE council NOT IN ('VIC FAR COUNTRY', 'VIC COUNTRY')
ORDER BY council, suburb;

CREATE OR REPLACE VIEW re_suburbs
AS SELECT * FROM suburbs
WHERE suburbs.Council NOT IN ('VIC FAR COUNTRY','VIC COUNTRY') 
ORDER BY Council,Suburb;

CREATE VIEW `AR_All_OutEastern`
AS
   SELECT `auction_results`.`prop_street_address` AS `prop_street_address`,
          `auction_results`.`prop_suburb` AS `prop_suburb`,
          `auction_results`.`prop_num_bedrooms` AS `prop_num_bedrooms`,
          `auction_results`.`prop_sale_price` AS `prop_sale_price`,
          `auction_results`.`prop_type` AS `prop_type`,
          `auction_results`.`prop_url` AS `prop_url`,
          `auction_results`.`auc_method` AS `auc_method`,
          `auction_results`.`auc_saledate` AS `auc_saledate`,
          `auction_results`.`auc_agent` AS `auc_agent`,
          `auction_results`.`data_source` AS `data_source`,
          `auction_results`.`data_ins_TS` AS `data_ins_TS`
     FROM `auction_results`
    WHERE (`auction_results`.`prop_suburb` IN
              ('MITCHAM',
               'RINGWOOD',
               'HEATHMONT',
               'WANTIRNA',
               'BAYSWATER',
               'CROYDON SOUTH'))
   ORDER BY `auction_results`.`prop_suburb`;

CREATE VIEW `AR_Latest_MidEastern`
AS
   SELECT `auction_results`.`prop_street_address` AS `prop_street_address`,
          `auction_results`.`prop_suburb` AS `prop_suburb`,
          `auction_results`.`prop_num_bedrooms` AS `prop_num_bedrooms`,
          `auction_results`.`prop_sale_price` AS `prop_sale_price`,
          `auction_results`.`prop_type` AS `prop_type`,
          `auction_results`.`prop_url` AS `prop_url`,
          `auction_results`.`auc_method` AS `auc_method`,
          `auction_results`.`auc_saledate` AS `auc_saledate`,
          `auction_results`.`auc_agent` AS `auc_agent`,
          `auction_results`.`data_source` AS `data_source`,
          `auction_results`.`data_ins_TS` AS `data_ins_TS`
     FROM `auction_results`
    WHERE (    (`auction_results`.`data_ins_TS` >
                   (SELECT max(cast(`auction_results`.`data_ins_TS` AS date))
                      FROM `auction_results`))
           AND (`auction_results`.`prop_suburb` IN
                   ('BLACKBURN',
                    'BLACKBURN NORTH',
                    'BLACKBURN SOUTH',
                    'BURWOOD',
                    'BURWOOD EAST',
                    'ASHWOOD',
                    'SURREY HILLS',
                    'BOX HILL',
                    'BOX HILL SOUTH',
                    'MOUNT WAVERLEY',
                    'CHADSTONE',
                    'DONCASTER',
                    'MALVERN EAST',
                    'GLEN WAVERLEY')))
   ORDER BY `auction_results`.`prop_suburb`;




