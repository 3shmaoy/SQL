DECLARE @sUserName AS VARCHAR(20)
SET @sUserName = 'sakabe'

SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME 
 WHERE userid = @sUserName 

SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME
 WHERE userid = @sUserName 
   FOR XML AUTO
-- <TABLE_NAME FIELD_NAME="VALUE1" />\n ...

SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME 
 WHERE userid = @sUserName 
   FOR XML RAW
SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME 
 WHERE userid = @sUserName 
   FOR XML RAW, TYPE
-- <row FIELD_NAME="VALUE1" />\n ...

SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME
 WHERE userid = @sUserName 
   FOR XML RAW ('NEW_ROW_NAME')
-- <NEW_ROW_NAME FIELD_NAME="VALUE1" />\n ...




SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME
 WHERE userid = @sUserName 
   FOR XML PATH
SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME
 WHERE userid = @sUserName 
   FOR XML RAW, ELEMENTS	-- same
-- <row>\n<FIELD_NAME>VALUE1</FIELD_NAME>\n</row>\n ...

SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME 
 WHERE userid = @sUserName 
   FOR XML RAW ('NEW_ROW_NAME'), ELEMENTS
-- <NEW_ROW_NAME>\n<FIELD_NAME>VALUE1</FIELD_NAME>\n</NEW_ROW_NAME>\n ...


SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME 
 WHERE userid = @sUserName 
   FOR XML PATH ('')
SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME 
 WHERE userid = @sUserName 
   FOR XML RAW (''), ELEMENTS
-- <FIELD_NAME>VALUE1</FIELD_NAME>\n ...

SELECT usernamekana  + ' ' 
  FROM mst_user TABLE_NAME 
 WHERE userid = @sUserName 
   FOR XML PATH ('')
SELECT usernamekana [data()]
  FROM mst_user TABLE_NAME 
 WHERE userid = @sUserName 
   FOR XML PATH ('')
-- VALUE1 VALUE2 ...
-- one line add use ur own separator, otherwise values will be concatenated w/o separators
-- w/ one leading or trailing extra separator (leading easier to reemove later)
-- the separator w/ the XML function data() is fixed to a space but has no leading or trailing extra separators


SELECT usernamekana FIELD_NAME
  FROM mst_user TABLE_NAME
 WHERE userid = @sUserName 
   FOR XML AUTO, ELEMENTS XSINIL, BINARY BASE64, ROOT('R')
-- FOR XML ..., BINARY BASE64  : get any binary data as a base64 encoded string
-- FOR XML ..., ROOT('Container_Element') : add a container element for the o/p
-- FOR XML ..., ELEMENTS XSINIL : will o/p (xsi:nil="true") for nulls


/*
Columns names/aliases => XML elements
	- columns will be merged (concatenated) as one when having the same column/label name
	- columns w/o name (simple table columns will always have a name) : o/p as simple text node in the XML w/o an element <row>VALUE</row>
	- [*] or "*" : no name & also merged together as if having the same name

	FIELD_NAME  => (decided by other commands)
		- <row...FIELD_NAME="VALUE"... 
		- <row>
			...
			<FIELD_NAME>VALUE</FIELD_NAME>
			...
		  </row>
	@FIELD_NAME => (forced unless misused)
		- <row...FIELD_NAME="VALUE"... : all atribute columns must be in the begining b4 other kinds
	GROUP_NAME/FIELD_NAME => (a column gets merged in the previous group if it's the same group)
		- <row>
			...
			<GROUP_NAME>
				<FIELD_NAME>VALUE</FIELD_NAME>
			</GROUP_NAME
			...
		  </row>
*/

/*
XML functions to use as column aliases
	data() : concatenate values w/ a space separator
	text() : as a simple text node in the XML
	comment() : <!-- VALUE -->
	node() : equal to [*]
*/


SELECT Tag,                 -- must be unique

	   -- grouping of records can be NULL or 0 for no parents 
	   -- can NOT be a parent that has been already closed	(if adding % 3 :: 0:no parent :: 1->2-:: 0:no parent so close 2,1 :: 1 as parent XX )
	   (Tag-1) Parent,

	   -- fields group number can only be an existing tag
       
	   -- to have a field in every group/record
	   username [GROUP_NAME!1!FIELD_NAME1],
	   username [GROUP_NAME!2!FIELD_NAME2],
	   username [GROUP_NAME!3!FIELD_NAME3],
	   username [GROUP_NAME!4!FIELD_NAME4],
	   username [GROUP_NAME!5!FIELD_NAME5],
	   username [GROUP_NAME!6!FIELD_NAME6],

	   6     [GROUP_NAME!6!GRP_6], -- only show this field in this (6) group
	   empno [GROUP_NAME!2!GRP_2]  -- only show this field in this (2) group
FROM
(
SELECT CAST(ROW_NUMBER() OVER(ORDER BY empno) AS INT) Tag,
	   username,
	   empno
  FROM mst_user TABLE_NAME
 WHERE userid = @sUserName
 ) TABLE_NAME
  FOR XML EXPLICIT


