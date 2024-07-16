create or replace view LF_WH_DB.MARKETING.VW_SEND_EMAIL_OPP_DATA as 
select 
    -- opp.*
    vwsed.jobid
    ,vwsed.emailsenddate
    ,concat(vwsed.jobid, '_', opp.CONTACTID) as Opportunity_JobId_CONTACTID
    ,opp.ID AS Opportunity_ID
    ,opp.ACCOUNTID AS Opportunity_ACCOUNTID
    ,opp.NAME AS Opportunity_NAME
    ,opp.DESCRIPTION AS Opportunity_DESCRIPTION
    ,opp.AMOUNT AS Opportunity_AMOUNT
    ,opp.EXPECTEDREVENUE AS Opportunity_EXPECTEDREVENUE
    ,opp.TOTALOPPORTUNITYQUANTITY AS Opportunity_TOTALOPPORTUNITYQUANTITY
    ,opp.LEADSOURCE AS Opportunity_LEADSOURCE
    ,opp.CAMPAIGNID AS Opportunity_CAMPAIGNID
    ,opp.CREATEDDATE AS Opportunity_CREATEDDATE
    ,opp.CONTACTID AS Opportunity_CONTACTID
    ,CASE
        When vwsed.emailsenddate > opp.CreatedDate then 'Other than SFMC'
        When opp.CreatedDate > vwsed.emailsenddate then 'SFMC'
        else 'Other'
    END as DonatedSource
    -- count(*)
from
    LF_WH_DB.MARKETING.vw_send_email_data vwsed
    left join lf_sfdc_db.sfdc_schema.opportunity opp on opp.CONTACTID = vwsed.contact_id
    where opp.iswon = TRUE
;

select DonatedSource, count(*) as nodonations, sum(Opportunity_AMOUNT) as totalamount from LF_WH_DB.MARKETING.VW_SEND_EMAIL_OPP_DATA group by DONATEDSOURCE;

select DonatedSource, JobId, count(*) as nodonations, sum(Opportunity_AMOUNT) as totalamount from LF_WH_DB.MARKETING.VW_SEND_EMAIL_OPP_DATA group by DONATEDSOURCE, JobId
order by DonatedSource, JobId, nodonations desc, totalamount desc 
;

select iswon, count(*) as cnt from  lf_sfdc_db.sfdc_schema.opportunity group by iswon;
select iswon, * from  lf_sfdc_db.sfdc_schema.opportunity limit 10;
-- When vwsed.emailsenddate > opp.CreatedDate then 'Other than SFMC'
-- When opp.CreatedDate > vwsed.emailsenddate then 'SFMC'
