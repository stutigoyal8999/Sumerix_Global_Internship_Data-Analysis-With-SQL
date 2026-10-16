--DDL queries run on a practice table so that the main schema remains untouched

--CREATE
CREATE TABLE Practice_Table(
    ItemID INTEGER PRIMARY KEY AUTOINCREMENT,
    ItemName VARCHAR(50) NOT NULL
);

--ALTER : adding a column and then renaming the table
ALTER TABLE Practice_Table ADD COLUMN Notes VARCHAR(100);
ALTER TABLE Practice_Table RENAME TO Practice_Items;

--TRUNCATE (concept)
DELETE FROM Practice_Items;

--DROP : removing the practice table
DROP TABLE Practice_Items;