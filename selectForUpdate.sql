START TRANSACTION;
    SELECT * FROM table1 ... FOR UPDATE;   -- selected rows will be locked
    -- ...
    UPDATE table1 SET col1 = val1 ...;     -- normally the same selected rows
COMMIT;