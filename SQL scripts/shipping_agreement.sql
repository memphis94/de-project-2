--создание справочника тарифов доставки вендора по договору shipping_agreement

DROP TABLE IF EXISTS shipping_agreement;

CREATE TABLE shipping_agreement(
agreementid BIGINT NOT NULL,
agreement_number TEXT,
agreement_rate NUMERIC(14,2),
agreement_commission NUMERIC(14,2),
PRIMARY KEY (agreementid));

INSERT INTO shipping_agreement  (agreementid, agreement_number, agreement_rate, agreement_commission)
SELECT
    vend1::BIGINT AS agreementid,
    vend2 AS agreement_number,
    vend3::NUMERIC(14,2) AS agreement_rate,
    vend4::NUMERIC(14,2) AS agreement_commission
FROM 
(SELECT
(regexp_split_to_array(vendor_agreement_description, ':+'))[1] AS vend1,
(regexp_split_to_array(vendor_agreement_description, ':+'))[2] AS vend2,
(regexp_split_to_array(vendor_agreement_description, ':+'))[3] AS vend3,
(regexp_split_to_array(vendor_agreement_description, ':+'))[4] AS vend4
FROM shipping 
GROUP BY 1,2,3,4
) vend
ORDER BY 1;