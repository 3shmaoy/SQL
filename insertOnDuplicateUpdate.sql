INSERT INTO table1 -- ( col1, col2, ... )
    -- VALUES ( val1, val2, ... )
    -- or a select statement
    -- SELECT ....
    ON DUPLICATE KEY UPDATE     -- directly w/o the SET keyword
         col1 = val1
        ,col2 = val2
        -- ...
;