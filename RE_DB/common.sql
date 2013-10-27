-- Backup into another table:
INSERT INTO auction_results_20131027(prop_street_address,
                                     prop_suburb,
                                     prop_num_bedrooms,
                                     prop_sale_price,
                                     prop_type,
                                     auc_method,
                                     auc_saledate,
                                     auc_agent,
                                     data_source,
                                     data_ins_TS)
   SELECT prop_street_address,
          prop_suburb,
          prop_num_bedrooms,
          prop_sale_price,
          prop_type,
          auc_method,
          auc_saledate,
          auc_agent,
          data_source,
          data_ins_TS
     FROM auction_results;


COMMIT;

-- Find out the structure of the the address field in order to split out a street number
SELECT
  if(ar_s.has_strnum = 1, substring_index(ar.prop_street_address, ' ', 1), NULL) AS prop_street_nbr,
  if(ar_s.has_strnum = 1, substring_index(ar.prop_street_address, ' ', 0 - space_occurs), ar.prop_street_address) AS prop_street_addr,
  ar.prop_suburb,
  ar.prop_num_bedrooms,
  ar.prop_sale_price,
  ar.prop_type,
  ar.auc_method,
  ar.auc_saledate,
  ar.auc_agent,
  ar.data_ins_TS
from auction_results ar left join 
(
  -- Find out whether a street address starts with a number or an alpha
  -- Find out how many spaces occur in the street address
  select
    distinct 
      prop_street_address, 
      (LENGTH(prop_street_address) - LENGTH(REPLACE(prop_street_address, ' ', ''))) AS `space_occurs`,
      substring(prop_street_address, 1, 1) NOT REGEXP '[a-zA-Z]' AS has_strnum
  from auction_results
) ar_s on ar.prop_street_address = ar_s.prop_street_address

