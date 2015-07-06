-- Metadata status
CREATE TABLE StatusValues
  (
    id        int not null,
    name      varchar(32)   not null,
    reserved  char(1)       default 'n' not null,
    primary key(id)
  );


CREATE TABLE StatusValuesDes
  (
    idDes   int not null,
    langId  varchar(5) not null,
    label   varchar(96)   not null,
    primary key(idDes,langId)
  );


CREATE TABLE MetadataStatus
  (
    metadataId  int not null,
    statusId    int default 0 not null,
    userId      int not null,
    changeDate   varchar(30)    not null,
    changeMessage   varchar(2048) not null,
    primary key(metadataId,statusId,userId,changeDate),
    foreign key(metadataId) references Metadata(id),
    foreign key(statusId)   references StatusValues(id),
    foreign key(userId)     references Users(id)

  );

INSERT INTO StatusValues VALUES  (0,'unknown','y');
INSERT INTO StatusValues VALUES  (1,'draft','y');
INSERT INTO StatusValues VALUES  (2,'approved','y');
INSERT INTO StatusValues VALUES  (3,'retired','y');
INSERT INTO StatusValues VALUES  (4,'submitted','y');
INSERT INTO StatusValues VALUES  (5,'rejected','y');

INSERT INTO StatusValuesDes VALUES (0,'fre','Inconnu');
INSERT INTO StatusValuesDes VALUES (1,'fre','Brouillon');
INSERT INTO StatusValuesDes VALUES (2,'fre','Validé');
INSERT INTO StatusValuesDes VALUES (3,'fre','Retiré');
INSERT INTO StatusValuesDes VALUES (4,'fre','A valider');
INSERT INTO StatusValuesDes VALUES (5,'fre','Rejeté');


CREATE TABLE CustomElementSet
  (
    xpath  varchar(1000) not null
  );

-- New settings
INSERT INTO Settings VALUES (17,10,'svnUuid','');

INSERT INTO Settings VALUES (917,1,'metadataprivs',NULL);
INSERT INTO Settings VALUES (918,917,'usergrouponly','false');

INSERT INTO Settings VALUES (950,1,'autodetect',NULL);
INSERT INTO Settings VALUES (951,950,'enable','true');
INSERT INTO Settings VALUES (952,1,'requestedLanguage',NULL);
INSERT INTO Settings VALUES (953,952,'only','false');
INSERT INTO Settings VALUES (954,952,'sorted','false');
INSERT INTO Settings VALUES (955,952,'ignored','true');

-- delete indexlanguages settings
-- Remove third level settings
DELETE FROM Settings WHERE id = 802;
DELETE FROM Settings WHERE id = 803;
DELETE FROM Settings WHERE id = 805;
DELETE FROM Settings WHERE id = 806;
DELETE FROM Settings WHERE id = 808;
DELETE FROM Settings WHERE id = 809;
DELETE FROM Settings WHERE id = 811;
DELETE FROM Settings WHERE id = 812;
DELETE FROM Settings WHERE id = 814;
DELETE FROM Settings WHERE id = 815;
DELETE FROM Settings WHERE id = 817;
DELETE FROM Settings WHERE id = 818;
DELETE FROM Settings WHERE id = 820;
DELETE FROM Settings WHERE id = 821;
DELETE FROM Settings WHERE id = 823;
DELETE FROM Settings WHERE id = 824;
DELETE FROM Settings WHERE id = 826;
DELETE FROM Settings WHERE id = 827;
DELETE FROM Settings WHERE id = 829;
DELETE FROM Settings WHERE id = 830;
DELETE FROM Settings WHERE id = 832;
DELETE FROM Settings WHERE id = 833;
DELETE FROM Settings WHERE id = 835;
DELETE FROM Settings WHERE id = 836;
DELETE FROM Settings WHERE id = 838;
DELETE FROM Settings WHERE id = 839;

-- Remove second level settings
DELETE FROM Settings WHERE id = 801;
DELETE FROM Settings WHERE id = 804;
DELETE FROM Settings WHERE id = 807;
DELETE FROM Settings WHERE id = 810;
DELETE FROM Settings WHERE id = 813;
DELETE FROM Settings WHERE id = 816;
DELETE FROM Settings WHERE id = 819;
DELETE FROM Settings WHERE id = 822;
DELETE FROM Settings WHERE id = 825;
DELETE FROM Settings WHERE id = 828;
DELETE FROM Settings WHERE id = 831;
DELETE FROM Settings WHERE id = 834;
DELETE FROM Settings WHERE id = 837;

-- Remove first level settings
DELETE FROM Settings WHERE id = 800;

-- ISO 3 letter code migration
INSERT INTO Languages VALUES ('eng','English', 'eng','y', 'y');
INSERT INTO Languages VALUES ('fre','Français', 'fre','y', 'n');

UPDATE CategoriesDes SET langid='eng' WHERE langid='en';
UPDATE CategoriesDes SET langid='fre' WHERE langid='fr';

UPDATE IsoLanguagesDes SET langid='eng' WHERE langid='en';
UPDATE IsoLanguagesDes SET langid='fre' WHERE langid='fr';

UPDATE RegionsDes SET langid='eng' WHERE langid='en';
UPDATE RegionsDes SET langid='fre' WHERE langid='fr';

UPDATE GroupsDes SET langid='eng' WHERE langid='en';
UPDATE GroupsDes SET langid='fre' WHERE langid='fr';

UPDATE OperationsDes SET langid='eng' WHERE langid='en';
UPDATE OperationsDes SET langid='fre' WHERE langid='fr';

UPDATE StatusValuesDes SET langid='eng' WHERE langid='en';
UPDATE StatusValuesDes SET langid='fre' WHERE langid='fr';

UPDATE CswServerCapabilitiesInfo SET langid='eng' WHERE langid='en';
UPDATE CswServerCapabilitiesInfo SET langid='fre' WHERE langid='fr';

DELETE FROM Languages WHERE id='en';
DELETE FROM Languages WHERE id='fr';

ALTER TABLE Languages DROP COLUMN isocode;

ALTER TABLE IsoLanguages ADD shortcode varchar(2);

UPDATE IsoLanguages SET shortcode='en' WHERE code='eng';
UPDATE IsoLanguages SET shortcode='fr' WHERE code='fre';

UPDATE Settings SET value='2.7.3' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';
