DECLARE @Counter INT
DECLARE @Hour VARCHAR(2)
SET @Counter=0
DECLARE @Day VARCHAR(8)

DECLARE @ANDROID AS TABLE (JAM VARCHAR(2), TRX BIGINT)
DECLARE @KONVEN AS TABLE (JAM VARCHAR(2), TRX BIGINT)
DECLARE @ALL AS TABLE (JAM VARCHAR(2), TRX BIGINT)

SET @Day='20221212'

WHILE ( @Counter <= 23)
BEGIN
 SET @Hour = CASE WHEN LEN(@Counter)=1 THEN '0'+CONVERT(VARCHAR,@Counter) ELSE CONVERT(VARCHAR,@Counter) END 
--CASE WHEN LEN(@Counter) = 1 THEN SET @Hour = '0'+CONVERT(VARCHAR,@Counter) ELSE CONVERT(VARCHAR,@Counter)
 INSERT INTO @ANDROID
 SELECT 
	@Hour,
	COUNT(CASE WHEN FGATEWAY_TS BETWEEN @Day+@Hour+'0000' AND @Day+@Hour+'5959' THEN 1 ELSE NULL END) 
  FROM [DbDwhIDM].[dbo].[TTRANSACTION_V2] 
  WHERE FGATEWAY_TS BETWEEN @Day+@Hour+'0000' AND @Day+@Hour+'5959'
  --AND FMTI = '0200'
  AND FMERCH_ID LIKE '2000%'
 INSERT INTO @KONVEN
 SELECT 
	@Hour,
	COUNT(CASE WHEN FGATEWAY_TS BETWEEN @Day+@Hour+'0000' AND @Day+@Hour+'5959' THEN 1 ELSE NULL END) 
  FROM [DbDwhIDM].[dbo].[TTRANSACTION_V2] 
  WHERE FGATEWAY_TS BETWEEN @Day+@Hour+'0000' AND @Day+@Hour+'5959'
  --AND FMTI = '0200'
  AND FMERCH_ID NOT LIKE '2000%'
 INSERT INTO @ALL
 SELECT 
	@Hour,
	COUNT(CASE WHEN FGATEWAY_TS BETWEEN @Day+@Hour+'0000' AND @Day+@Hour+'5959' THEN 1 ELSE NULL END) 
  FROM [DbDwhIDM].[dbo].[TTRANSACTION_V2] 
  WHERE FGATEWAY_TS BETWEEN @Day+@Hour+'0000' AND @Day+@Hour+'5959'
  --AND FMTI = '0200'
 SET @Counter  = @Counter  + 1
END	

SELECT 
	AD.JAM,AD.TRX AS 'ANDROID',KN.TRX AS 'KONVEN',AL.TRX AS 'ALL'
FROM @ANDROID AD
FULL OUTER JOIN @KONVEN KN ON KN.JAM = AD.JAM
FULL OUTER JOIN @ALL AL ON AL.JAM = AD.JAM