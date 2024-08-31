drop table if exists organization;
drop table if exists call_log;

create table organization
(
	org_id integer,
	org_name varchar,
	org_code varchar,
	org_status varchar,
	org_date timestamp,
	properties varchar
)

COPY organization
	from 'D:\timepass\Copy of Data Analyst Intern SQL Assignment - organization.csv'
NULL as 'null'
CSV HEADER;


create table call_log
(
	call_date timestamp,
	user_id varchar,
	lead_id varchar,
	org_id integer,
	call_connected integer,
	call_not_connected_reason varchar
)

COPY call_log
	from 'D:\timepass\Copy of Data Analyst Intern SQL Assignment - call_log.csv'
NULL as 'null'
CSV HEADER;


select * from organization;
select * from call_log;

--Q1) Find the first connected call for all the renewed organizations from the Gujarat location
--Solution:
select organization.org_name,min(call_log.call_date) as first_connected_call
from call_log
inner join organization on call_log.org_id=organization.org_id
where organization.org_status = 'renewed'
and call_log.call_connected=1
and organization.properties like '%Gujarat%'
group by organization.org_name
order by organization.org_name;

/*Approach:using inner join , join the 2 tables,
then using where condition on org_status, check if call was connected 
	and find 'Gujarat' in properties column, finally min() condition helps decide first occurence*/


--Q2) Find the count of organizations that had three consecutive calls 
--(excluding Saturday and Sunday) within 0-4 days, 5-8 days, 8-15 days, 16-30 days,
--30+ days of organization creation

--a. Perform this analysis for both renewed and not renewed organizations

--Solution:
--adding a date column for company creation date
alter table organization
add column creation_date type varchar;

update organization
set creation_date=SUBSTRING(CAST(org_date AS varchar), 0, 11);

alter table organization
alter column creation_date type date
using (creation_date::text::date);



--adding date column for date of call
alter table call_log
add column call_date_extracted varchar;

update call_log
set call_date_extracted=SUBSTRING(CAST(call_date AS varchar), 0, 11);

alter table call_log
alter column call_date_extracted type date
using (call_date_extracted::text::date);
select * from call_log;

-------------------------------------
alter table call_log
add column date_diff integer;

UPDATE call_log b
SET date_diff = b.call_date_extracted-a.creation_date
FROM organization a
WHERE a.org_id = b.org_id;
--------------------------------------
WITH DateDifferences AS (
  SELECT
    call_log.org_id,
    call_log.date_diff,
	organization.org_status,
    LAG(call_log.date_diff) OVER (PARTITION BY call_log.org_id ORDER BY call_log.date_diff) AS previous_date_diff,
    call_log.date_diff - LAG(call_log.date_diff) OVER (PARTITION BY call_log.org_id ORDER BY call_log.date_diff) AS difference_of_dates
  FROM call_log
  JOIN organization ON call_log.org_id = organization.org_id
),
range_based_classes AS (
SELECT 
  org_id,
  date_diff,
  previous_date_diff,
  difference_of_dates,
  org_status,
  CASE
    WHEN date_diff BETWEEN 0 AND 4 THEN '0-4 days'
    WHEN date_diff BETWEEN 5 AND 8 THEN '5-8 days'
    WHEN date_diff BETWEEN 9 AND 15 THEN '8-15 days'
    WHEN date_diff BETWEEN 16 AND 30 THEN '16-30 days'
    ELSE '30+ days'
  END AS date_range_classification
FROM DateDifferences
WHERE difference_of_dates =1
  AND org_id IN (
    SELECT org_id
    FROM DateDifferences
    WHERE difference_of_dates=1
    GROUP BY org_id
    HAVING COUNT(*) >= 3
  )
)
SELECT
    org_status,
    date_range_classification,
    COUNT(DISTINCT org_id) AS unique_org_count
FROM
    range_based_classes
GROUP BY
    org_status,
    date_range_classification
ORDER BY
    org_status,
    date_range_classification;
--------------------------------------
/*Approach: first, extract dates from given timestamps in both tables.
			Add a new column date diff that is the difference of above exrtacted dates
			using lag and partition to find difference between one row and row below to find consecutive days
			then if difference is 1 means days are consecutive
			pack them in a cte and using group by and order by we can find the solution*/

--------------------------------------

--Q3)Identify the location with the maximum number of connected calls for unique leads
--Solution:

--handling missing value
UPDATE organization
SET properties = REPLACE(properties, 'Company E}', 'Company E"}')
WHERE properties LIKE '%"company":"Company E}%';


--adding a new column 'state' to organization table using json properties
ALTER TABLE organization 
ADD COLUMN origin_state varchar;

UPDATE organization
SET origin_state = properties::json->>'location';

select * from call_log;


select organization.origin_state,count(*) as connected_call_count
from call_log
inner join organization on call_log.org_id=organization.org_id
where call_connected=1
group by organization.origin_state
order by count(*) desc
limit 1;
------------------------------------
/*approach: update value in column to proper value
			using json properties find state from properties column
			then find count , order by descending and first row is result*/
------------------------------------


--Q4)For calls not connected, identify the most common reason(s) 
--for why the call was not connected.
--Solution:

select call_not_connected_reason,count(*)
from call_log
-- where call_not_connected_reason not like ''
group by call_not_connected_reason
order by count(*) desc
limit 2;

------------------------------------
/*approach: similar to 3rd, use count, group by not_connected_reason 
			order by descending , first row is solution*/
------------------------------------

--Q5)5. Create a summary for your analysis to summarize your 
--findings and inference for the above queries.

/*Solution: Based on the above analysis, it can be summarized that
			1. Companies E,H,P,Q,R,S all connected their first call in the month of 
					May, all around the same time.
			2. 5 renewed companies have consecutive calls almost 30+ days after creation
					while 1 non renewed company has consecutive calls after 5-8 days, 1 company after 8-15 days
					and 2 after 30+ days. Meaning non-renewed have higher chances of calls comapared to
					renewed companies.
			3. State of Maharashtra has the most number of connected calls which is 77, followed by 
					Gujarat and Punjab by 65 and 45 respectively.
			4. Many reported not_picked to be the reason for not_connected calls, count to be 107.
				But also most were unrecorded reasons, 187. Both results have been included in the solution
 
NOTE: All solution are written with approach followed, which is present right below the solutions. Please do check
	  Solutions were written using PostgreSQL.
*/
				
