--Создание таблицы shipping_info с уникальными доставками    
DROP TABLE IF EXISTS shipping_info;
CREATE TABLE shipping_info(
shippingid int8 NULL,
vendorid int8 NULL,
payment_amount numeric(14, 2) NULL,
shipping_plan_datetime timestamp NULL,
transfer_type_id BIGINT,
shipping_country_id BIGINT,
agreementid BIGINT,
FOREIGN KEY (transfer_type_id) REFERENCES shipping_transfer(id) ON UPDATE CASCADE,
FOREIGN KEY (shipping_country_id) REFERENCES shipping_country_rates(id) ON UPDATE CASCADE,
FOREIGN KEY (agreementid) REFERENCES shipping_agreement(agreementid) ON UPDATE CASCADE);

INSERT INTO shipping_info(shippingid, vendorid, payment_amount, shipping_plan_datetime, transfer_type_id, shipping_country_id, agreementid)
    
WITH shipping_join AS(
SELECT 
	shippingid,
    vendorid,
    payment_amount,
    shipping_plan_datetime,
    shipping_country,
    (regexp_split_to_array(shipping_transfer_description, ':+'))[2] AS transfer_type,
    (regexp_split_to_array(shipping_transfer_description, ':+'))[1] AS transfer_model,
    (regexp_split_to_array(vendor_agreement_description, ':+'))[1] AS agreementid
FROM shipping)

SELECT
	s.shippingid,
	s.vendorid,
	s.payment_amount,
	s.shipping_plan_datetime,
	st.id AS transfer_type_id,
	scr.id AS shipping_country_id,
	sa.agreementid

FROM shipping_join s
JOIN shipping_transfer st ON s.transfer_type = st.transfer_type
AND s.transfer_model = st.transfer_model
JOIN  shipping_country_rates scr ON s.shipping_country = scr.shipping_country
JOIN shipping_agreement sa ON   s.agreementid::BIGINT = sa.agreementid