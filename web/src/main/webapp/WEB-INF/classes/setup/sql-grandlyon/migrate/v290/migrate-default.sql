

-- Spring security
UPDATE Users SET security='update_hash_required';

-- Delete LDAP settings
DELETE FROM Settings WHERE parentid=86;
DELETE FROM Settings WHERE parentid=87;
DELETE FROM Settings WHERE parentid=89;
DELETE FROM Settings WHERE parentid=80;
DELETE FROM Settings WHERE id=80;

-- New settings 
INSERT INTO Settings VALUES (24,20,'securePort','8443');
INSERT INTO Settings VALUES (956,1,'hidewithheldelements',NULL);
INSERT INTO Settings VALUES (957,956,'enable','false');
INSERT INTO Settings VALUES (958,956,'keepMarkedElement','true');



UPDATE Settings SET value='2.9.0' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';
