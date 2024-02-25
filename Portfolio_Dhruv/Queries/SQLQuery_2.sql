use Portfolio_dhruv
IF OBJECT_ID('tempdb..##TBL_temp') IS NOT NULL
DROP TABLE ##TBL_temp

IF OBJECT_ID('tempdb..#indicator') IS NOT NULL
DROP TABLE #indicator

create table #indicator (Indicator nvarchar(max))
insert into #indicator Select Distinct Indicator_name  from dbo.[2016]
--select * from #indicator
declare
    @sqlquery nvarchar(max),
    @PivotColumns nvarchar(max)
select @PivotColumns = Coalesce(@PivotColumns + ',','') + QUOTENAME(Indicator)
from #indicator

--SELECT @PivotColumns

SET @sqlquery = N'Select [Country_Name],' + @PivotColumns + '
into ##TBL_temp
from [dbo].[2016]
pivot (MAX([_2016])
    for [Indicator_Name] in (' + @PivotColumns + ')) AS Q'

--SELECT @sqlquery

exec sp_executesql @sqlquery

select * from ##TBL_temp
--(select * from dbo.[2016]) as src
--PIVOT
--(
 --   MAX(_2016)
   -- For [T.Indicator_Name] IN ( ' + @cols + ')
--) as pivot_table;

