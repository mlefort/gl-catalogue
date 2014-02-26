CREATE TABLE SettingsBackup AS SELECT * FROM Settings;

INSERT INTO Settings VALUES (88,80,'defaultGroup', NULL);
INSERT INTO Settings VALUES (113,87,'group',NULL);
INSERT INTO Settings VALUES (178,173,'group',NULL);
INSERT INTO Settings VALUES (179,170,'defaultGroup', NULL);

UPDATE Settings SET value='2.7.2' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';