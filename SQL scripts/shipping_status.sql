--Создание таблицы статусов о доставке shipping_status
DROP TABLE IF EXISTS shipping_status;

CREATE TABLE shipping_status(
shippingid int8 NULL,
status TEXT,
state TEXT,
shipping_start_fact_datetime TIMESTAMP,
shipping_end_fact_datetime TIMESTAMP)

INSERT INTO shipping_status (shippingid, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
    
WITH max_state AS(SELECT
	shippingid,
	MAX(state_datetime) AS max_state_dt,
	MIN(CASE WHEN s.state = 'booked' THEN s.state_datetime  END) AS shipping_start_fact_datetime,
	MIN(CASE WHEN s.state = 'recieved' THEN s.state_datetime  END) AS shipping_end_fact_datetime
FROM shipping s 
GROUP BY 1)

SELECT 
	ms.shippingid,	
	s.status,
	s.state,
	ms.shipping_start_fact_datetime,
	ms.shipping_end_fact_datetime
	
FROM max_state ms
LEFT JOIN shipping s ON ms.shippingid = s.shippingid
WHERE s.state_datetime = ms.max_state_dt
ORDER BY 1;    
 