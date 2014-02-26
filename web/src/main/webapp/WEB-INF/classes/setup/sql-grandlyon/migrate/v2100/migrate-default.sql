

UPDATE UserGroups SET profile = 'RegisteredUser' WHERE profile IS null;


-- Version update
UPDATE Settings SET value='2.10.0' WHERE name='version';
UPDATE Settings SET value='SNAPSHOT' WHERE name='subVersion';
