/****** Script for Select log user access sharepoint  ******/
SELECT 
	count  ([Referrer]) as Count
    , [Referrer]
	 -- ,Username
	  ,REPLACE(SUBSTRING([Username], CHARINDEX('\', [Username]), LEN([Username])), '\', '') AS Name
  FROM [WFE_Log_DB].[dbo].[IISLogDetails]
  where username is not null 
  and HttpStatus = '200' 
  and Referrer is not null
  and EntryTime >= '2019-04-01' 
  and EntryTime < '2019-07-01'
  and Referrer like 'http://triangle.three.co.id/IT/budget/_layouts/15/ReportServer/%'
  and username not like '%portal%'
 Group by [Referrer],USERNAME


