--Создание справочника стоимости доставки по странам shipping_country_rates
DROP TABLE IF EXISTS shipping_country_rates;
CREATE TABLE shipping_country_rates(
id SERIAL,
shipping_country TEXT,
shipping_country_base_rate NUMERIC(14,3),
PRIMARY KEY (id));

CREATE SEQUENCE shipping_country_rates_sequence
START 1;

INSERT INTO shipping_country_rates  (id, shipping_country, shipping_country_base_rate)
SELECT
    nextval('shipping_country_rates_sequence')::BIGINT AS id,
	shipping_country,
	shipping_country_base_rate
FROM 
(SELECT
shipping_country,
shipping_country_base_rate
FROM shipping 

GROUP BY shipping_country, shipping_country_base_rate
) shpn_rate;

DROP SEQUENCE shipping_country_rates_sequence;