--Создание представления shipping_datamart
CREATE OR REPLACE VIEW shipping_datamart AS

SELECT 
	ss.shippingid,
	si.vendorid,
	st.transfer_type,
	EXTRACT(DAY FROM (AGE(ss.shipping_end_fact_datetime,ss.shipping_start_fact_datetime))) AS full_day_at_shipping,
	CASE WHEN ss.shipping_end_fact_datetime > si.shipping_plan_datetime THEN 1 ELSE 0 END AS is_delay,
	CASE WHEN ss.status = 'finished' THEN 1 ELSE 0 END AS is_shipping_finish,
	CASE WHEN ss.shipping_end_fact_datetime > si.shipping_plan_datetime THEN EXTRACT(DAY FROM (ss.shipping_end_fact_datetime - si.shipping_plan_datetime)) ELSE 0 END AS delay_day_at_shipping,
	si.payment_amount,
	si.payment_amount*(scr.shipping_country_base_rate + sa.agreement_rate + st.shipping_transfer_rate)	AS vat,
	si.payment_amount * sa.agreement_commission AS profit

	
FROM shipping_status ss 
JOIN shipping_info si ON ss.shippingid =si.shippingid 
JOIN shipping_transfer st ON si.transfer_type_id = st.id 
JOIN shipping_country_rates scr ON si.shipping_country_id = scr.id 
JOIN shipping_agreement sa ON si.agreementid = sa.agreementid 