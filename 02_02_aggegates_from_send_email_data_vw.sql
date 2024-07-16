USE DATABASE LF_WH_DB;
USE SCHEMA MARKETING;

alter table dim_time rename to LF_WH_DB.common.dim_date;

desc table LF_WH_DB.marketing.vw_send_email_data;
desc table LF_WH_DB.common.dim_date;
desc table LF_SFDC_DB.sfdc_schema.contact;

-- select * from LF_WH_DB.marketing.vw_send_email_data limit 10;
select count(*) from LF_WH_DB.marketing.vw_send_email_data;

select CONTACTBOUNCESTATUS, * from LF_WH_DB.marketing.vw_send_email_data limit 10;

SELECT
  COUNT(*) OVER() as emails_send_count,
  SUM(CASE WHEN EMAILINTERACTIONISOPENED = 1 THEN 1 ELSE 0 END) OVER() as emails_opened_count,
  SUM(CASE WHEN EMAILINTERACTIONISOPENED = 0 THEN 1 ELSE 0 END) OVER() as emails_unopened_count,
  COUNT(DISTINCT CASE WHEN EMAILINTERACTIONISOPENED = 1 THEN SUBSCRIBERKEY END) OVER() as opened_distinct_users_count,
  COUNT(DISTINCT CASE WHEN EMAILINTERACTIONISOPENED = 0 THEN SUBSCRIBERKEY END) OVER() as unopened_distinct_users_count,
  SUM(CASE WHEN EMAILINTERACTIONNAME = 'Unsubscribed' THEN 1 ELSE 0 END) OVER() as unsubscribed_count,
  COUNT(DISTINCT CASE WHEN EMAILINTERACTIONNAME = 'Unsubscribed' THEN SUBSCRIBERKEY END) OVER() as unsubscribed_distinct_users_count,
  SUM(CONTACTBOUNCESTATUS) OVER() as bounced_email_count,
  SUM(EMAILINTERACTIONEMAILCLICKCOUNT) OVER() as total_clicks,
  COUNT(DISTINCT EMAILCLICKID) OVER() as unique_clicks
FROM send_email_data_vw
;


SELECT SUM(EMAILINTERACTIONEMAILCLICKCOUNT) as total_clicks
FROM send_email_data_vw;
    
-- 2. Unique clicks by contact name
SELECT CONTACTNAME, COUNT(DISTINCT EMAILCLICKID) as unique_clicks
FROM send_email_data_vw
WHERE EMAILINTERACTIONEMAILCLICKCOUNT > 0
GROUP BY CONTACTNAME
ORDER BY unique_clicks DESC
;

SELECT 
    EMAILSENDDATE
    , CONTACTNAME
    , COUNT(EMAILCLICKID) as total_clicks
    , COUNT(DISTINCT EMAILADDRESS) as unique_clicks
FROM send_email_data_vw
WHERE EMAILINTERACTIONEMAILCLICKCOUNT > 0
GROUP BY EMAILSENDDATE, CONTACTNAME
ORDER BY total_clicks desc, unique_clicks DESC
;

-- 3. Clicks per day
SELECT JOBID, DAY, EMAILADDRESS, COUNT(*) as emails_opened_by_receiver
FROM send_email_data_vw
WHERE EMAILINTERACTIONISOPENED = 1
GROUP BY JOBID, DAY, EMAILADDRESS;
