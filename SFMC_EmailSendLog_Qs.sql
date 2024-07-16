USE DATABASE LF_WH_DB;
USE SCHEMA MARKETING;

create or replace view LF_WH_DB.MARKETING.send_email_data_vw as 
SELECT 
    sse."JobID"       AS JobID
    , sse.SubscriberKey
    , sse.EmailAdd  AS EmailAddress
    , sse.FirstName
    , sse.LastName
    , TO_DATE(sse.XTLONGDATE, 'DY, MMMM DD, YYYY') AS EmailSendDate
    , ei.id as EmailInteractionId
    , ei.name as EmailInteractionName
    , ei.createddate        AS EmailInteractionCreatedDate
    , ei.is_opened__c       AS EmailInteractionIsOpened
    -- , ei.job_id__c          AS EmailInteractionJobId -- debugging purposes
    , ei.email_click_count__c   AS EmailInteractionEmailClickCount
    , ec.id                 AS EmailClickId
    , ec.name               AS EmailClickName
    , ec.createddate        AS EmailClickCreatedDate
    , ec.date_clicked__c    AS EmailClickDateClicked
    , ec.email_interaction__c   AS EmailClickEmlIntr
    -- , ec.job_id__c          AS EmailClickJobId -- debugging purposes
    , ct.ID                 AS ContactId
    , ct.accountid          AS AccountId
    , ct.firstname          AS ContactFirstName
    , ct.lastname           AS ContactLastName
    , ct.name               AS ContactName
    , ct.email              AS ContactEmail
    , ct.CREATEDDATE        AS ContactCreatedDate
    , ct.CONTACTACCOUNTID__C AS ContactAccountId
    , ct.BOUNCE_STATUS__C   AS ContactBounceStatus
    , ct.deceasedflag__c    AS ContactDeceasedFlag
    , dimt.* -- expand
FROM
    lf_sfdc_db.sfdc_schema.SFMC_SYS_SENDLOG_EMAIL sse
    left join lf_sfdc_db.sfdc_schema.EMAIL_INTERACTION__C ei 
        on ei.JOB_ID__C = sse."JobID"
        -- on ei.RECIPIENT__C = sse.subscriberkey and ei.JOB_ID__C = sse."JobID"
    join lf_sfdc_db.sfdc_schema.CONTACT ct on ct.id = ei.RECIPIENT__C
    join lf_sfdc_db.sfdc_schema.EMAIL_CLICK__C ec on ec.email_interaction__c = ei.id
    join lf_wh_db.common.dim_time dimt on EmailSendDate = dimt.date
-- WHERE to filter last year data
;

select count(*) as cnt from LF_WH_DB.marketing.send_email_data_vw; -- 183106

select * from LF_WH_DB.marketing.send_email_data_vw limit 10;

-- HELPERS
select count(*) as cnt from lf_sfdc_db.sfdc_schema.SFMC_SYS_SENDLOG_EMAIL; -- 9325174
select * from lf_sfdc_db.sfdc_schema.SFMC_SYS_SENDLOG_EMAIL limit 100;

select count(*) as cnt from lf_sfdc_db.sfdc_schema.EMAIL_INTERACTION__C; -- 77943
select * from lf_sfdc_db.sfdc_schema.EMAIL_INTERACTION__C limit 100; 

select count(*) as cnt from lf_sfdc_db.sfdc_schema.EMAIL_CLICK__C; -- 190038
select * from lf_sfdc_db.sfdc_schema.EMAIL_CLICK__C 
-- order by createddate desc;
limit 100;

select count(*) as cnt from lf_sfdc_db.sfdc_schema.email_detail__c; -- 21791
select * from lf_sfdc_db.sfdc_schema.email_detail__c limit 100;

select count(*) as cnt from lf_sfdc_db.sfdc_schema.contact; -- 4240465
select * from lf_sfdc_db.sfdc_schema.contact limit 100;
