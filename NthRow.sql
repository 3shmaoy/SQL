DECLARE @iStart AS INT
DECLARE @iEnd AS INT
DECLARE @iOffset AS INT
DECLARE @iLength AS INT
SET @iStart = 13
SET @iEnd = 15
SET @iOffset = @iStart - 1
SET @iLength = @iEnd - @iStart + 1

-- T-SQL
SELECT *
  FROM (
		SELECT mst_user.empno, 
			   mst_user.username, 
			   ROW_NUMBER() OVER (ORDER BY mst_user.empno ASC) ROW_NUM
		  FROM RoadSys.dbo.mst_user
		--GROUP BY mst_user.empno
		) TBL_INNER
 WHERE ROW_NUM BETWEEN @iStart AND @iEnd

SELECT mst_user.empno, 
  	   mst_user.username
  FROM RoadSys.dbo.mst_user
 ORDER BY mst_user.empno
OFFSET @iOffset ROWS
FETCH NEXT @iLength ROWS ONLY

/*
SELECT mst_user.empno, 
  	   mst_user.username
  FROM RoadSys.dbo.mst_user
 ORDER BY mst_user.empno
OFFSET @iOffset
 LIMIT @iLength

SELECT mst_user.empno, 
  	   mst_user.username   
  FROM RoadSys.dbo.mst_user
 ORDER BY mst_user.empno
 LIMIT @iOffset, @iLength
*/