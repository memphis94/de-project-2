--Создание справочника о типах доставки shipping_transfer
DROP TABLE IF EXISTS shipping_transfer;
CREATE TABLE shipping_transfer(
id SERIAL,
transfer_type TEXT,
transfer_model TEXT,
shipping_transfer_rate NUMERIC(14,3),
PRIMARY KEY (id));

CREATE SEQUENCE shipping_transfer_sequence
START 1;

INSERT INTO shipping_transfer  (id, transfer_type, transfer_model,  shipping_transfer_rate)

SELECT
    nextval('shipping_transfer_sequence')::BIGINT AS id,
    transfer_type,
    transfer_model,
    shipping_transfer_rate
 FROM (
 SELECT 
 	(regexp_split_to_array(shipping_transfer_description, ':+'))[2] AS transfer_type,
    (regexp_split_to_array(shipping_transfer_description, ':+'))[1] AS transfer_model,
    shipping_transfer_rate
 FROM public.shipping s
 GROUP BY 1,2,3) t_rates;
 
DROP SEQUENCE shipping_transfer_sequence; 

