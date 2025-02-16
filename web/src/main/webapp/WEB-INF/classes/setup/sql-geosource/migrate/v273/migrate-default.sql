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
INSERT INTO Languages VALUES ('ara','العربية', 'ara','n', 'n');
INSERT INTO Languages VALUES ('cat','Català', 'cat','n', 'n');
INSERT INTO Languages VALUES ('chi','中文', 'chi','n', 'n');
INSERT INTO Languages VALUES ('dut','Nederlands', 'dut','y', 'n');
INSERT INTO Languages VALUES ('eng','English', 'eng','y', 'y');
INSERT INTO Languages VALUES ('fin','Suomi', 'fin','y', 'n');
INSERT INTO Languages VALUES ('fre','Français', 'fre','y', 'n');
INSERT INTO Languages VALUES ('ger','Deutsch', 'ger','y', 'n');
INSERT INTO Languages VALUES ('nor','Norsk', 'nor','n', 'n');
INSERT INTO Languages VALUES ('por','Português', 'por','y', 'n');
INSERT INTO Languages VALUES ('rus','русский язык', 'rus','n', 'n');
INSERT INTO Languages VALUES ('spa','Español', 'spa','y', 'n');
INSERT INTO Languages VALUES ('vie','Tiếng Việt', 'vie','n', 'n');

UPDATE CategoriesDes SET langid='ara' WHERE langid='ar';
UPDATE CategoriesDes SET langid='cat' WHERE langid='ca';
UPDATE CategoriesDes SET langid='chi' WHERE langid='cn';
UPDATE CategoriesDes SET langid='dut' WHERE langid='nl';
UPDATE CategoriesDes SET langid='eng' WHERE langid='en';
UPDATE CategoriesDes SET langid='fin' WHERE langid='fi';
UPDATE CategoriesDes SET langid='fre' WHERE langid='fr';
UPDATE CategoriesDes SET langid='ger' WHERE langid='de';
UPDATE CategoriesDes SET langid='nor' WHERE langid='no';
UPDATE CategoriesDes SET langid='por' WHERE langid='po';
UPDATE CategoriesDes SET langid='rus' WHERE langid='ru';
UPDATE CategoriesDes SET langid='spa' WHERE langid='sp';
UPDATE CategoriesDes SET langid='vie' WHERE langid='vi';

UPDATE IsoLanguagesDes SET langid='ara' WHERE langid='ar';
UPDATE IsoLanguagesDes SET langid='cat' WHERE langid='ca';
UPDATE IsoLanguagesDes SET langid='chi' WHERE langid='cn';
UPDATE IsoLanguagesDes SET langid='dut' WHERE langid='nl';
UPDATE IsoLanguagesDes SET langid='eng' WHERE langid='en';
UPDATE IsoLanguagesDes SET langid='fin' WHERE langid='fi';
UPDATE IsoLanguagesDes SET langid='fre' WHERE langid='fr';
UPDATE IsoLanguagesDes SET langid='ger' WHERE langid='de';
UPDATE IsoLanguagesDes SET langid='nor' WHERE langid='no';
UPDATE IsoLanguagesDes SET langid='por' WHERE langid='po';
UPDATE IsoLanguagesDes SET langid='rus' WHERE langid='ru';
UPDATE IsoLanguagesDes SET langid='spa' WHERE langid='sp';
UPDATE IsoLanguagesDes SET langid='vie' WHERE langid='vi';

UPDATE RegionsDes SET langid='ara' WHERE langid='ar';
UPDATE RegionsDes SET langid='cat' WHERE langid='ca';
UPDATE RegionsDes SET langid='chi' WHERE langid='cn';
UPDATE RegionsDes SET langid='dut' WHERE langid='nl';
UPDATE RegionsDes SET langid='eng' WHERE langid='en';
UPDATE RegionsDes SET langid='fin' WHERE langid='fi';
UPDATE RegionsDes SET langid='fre' WHERE langid='fr';
UPDATE RegionsDes SET langid='ger' WHERE langid='de';
UPDATE RegionsDes SET langid='nor' WHERE langid='no';
UPDATE RegionsDes SET langid='por' WHERE langid='po';
UPDATE RegionsDes SET langid='rus' WHERE langid='ru';
UPDATE RegionsDes SET langid='spa' WHERE langid='sp';
UPDATE RegionsDes SET langid='vie' WHERE langid='vi';


UPDATE GroupsDes SET langid='ara' WHERE langid='ar';
UPDATE GroupsDes SET langid='cat' WHERE langid='ca';
UPDATE GroupsDes SET langid='chi' WHERE langid='cn';
UPDATE GroupsDes SET langid='dut' WHERE langid='nl';
UPDATE GroupsDes SET langid='eng' WHERE langid='en';
UPDATE GroupsDes SET langid='fin' WHERE langid='fi';
UPDATE GroupsDes SET langid='fre' WHERE langid='fr';
UPDATE GroupsDes SET langid='ger' WHERE langid='de';
UPDATE GroupsDes SET langid='nor' WHERE langid='no';
UPDATE GroupsDes SET langid='por' WHERE langid='po';
UPDATE GroupsDes SET langid='rus' WHERE langid='ru';
UPDATE GroupsDes SET langid='spa' WHERE langid='sp';
UPDATE GroupsDes SET langid='vie' WHERE langid='vi';


UPDATE OperationsDes SET langid='ara' WHERE langid='ar';
UPDATE OperationsDes SET langid='cat' WHERE langid='ca';
UPDATE OperationsDes SET langid='chi' WHERE langid='cn';
UPDATE OperationsDes SET langid='dut' WHERE langid='nl';
UPDATE OperationsDes SET langid='eng' WHERE langid='en';
UPDATE OperationsDes SET langid='fin' WHERE langid='fi';
UPDATE OperationsDes SET langid='fre' WHERE langid='fr';
UPDATE OperationsDes SET langid='ger' WHERE langid='de';
UPDATE OperationsDes SET langid='nor' WHERE langid='no';
UPDATE OperationsDes SET langid='por' WHERE langid='po';
UPDATE OperationsDes SET langid='rus' WHERE langid='ru';
UPDATE OperationsDes SET langid='spa' WHERE langid='sp';
UPDATE OperationsDes SET langid='vie' WHERE langid='vi';


UPDATE StatusValuesDes SET langid='ara' WHERE langid='ar';
UPDATE StatusValuesDes SET langid='cat' WHERE langid='ca';
UPDATE StatusValuesDes SET langid='chi' WHERE langid='cn';
UPDATE StatusValuesDes SET langid='dut' WHERE langid='nl';
UPDATE StatusValuesDes SET langid='eng' WHERE langid='en';
UPDATE StatusValuesDes SET langid='fin' WHERE langid='fi';
UPDATE StatusValuesDes SET langid='fre' WHERE langid='fr';
UPDATE StatusValuesDes SET langid='ger' WHERE langid='de';
UPDATE StatusValuesDes SET langid='nor' WHERE langid='no';
UPDATE StatusValuesDes SET langid='por' WHERE langid='po';
UPDATE StatusValuesDes SET langid='rus' WHERE langid='ru';
UPDATE StatusValuesDes SET langid='spa' WHERE langid='sp';
UPDATE StatusValuesDes SET langid='vie' WHERE langid='vi';


UPDATE CswServerCapabilitiesInfo SET langid='ara' WHERE langid='ar';
UPDATE CswServerCapabilitiesInfo SET langid='cat' WHERE langid='ca';
UPDATE CswServerCapabilitiesInfo SET langid='chi' WHERE langid='cn';
UPDATE CswServerCapabilitiesInfo SET langid='dut' WHERE langid='nl';
UPDATE CswServerCapabilitiesInfo SET langid='eng' WHERE langid='en';
UPDATE CswServerCapabilitiesInfo SET langid='fin' WHERE langid='fi';
UPDATE CswServerCapabilitiesInfo SET langid='fre' WHERE langid='fr';
UPDATE CswServerCapabilitiesInfo SET langid='ger' WHERE langid='de';
UPDATE CswServerCapabilitiesInfo SET langid='nor' WHERE langid='no';
UPDATE CswServerCapabilitiesInfo SET langid='por' WHERE langid='po';
UPDATE CswServerCapabilitiesInfo SET langid='rus' WHERE langid='ru';
UPDATE CswServerCapabilitiesInfo SET langid='spa' WHERE langid='sp';
UPDATE CswServerCapabilitiesInfo SET langid='vie' WHERE langid='vi';


DELETE FROM Languages WHERE id='ar';
DELETE FROM Languages WHERE id='cn';
DELETE FROM Languages WHERE id='de';
DELETE FROM Languages WHERE id='en';
DELETE FROM Languages WHERE id='es';
DELETE FROM Languages WHERE id='fr';
DELETE FROM Languages WHERE id='nl';
DELETE FROM Languages WHERE id='no';
DELETE FROM Languages WHERE id='pt';
DELETE FROM Languages WHERE id='ru';

ALTER TABLE Languages DROP COLUMN isocode;

ALTER TABLE IsoLanguages ADD shortcode varchar(2);

UPDATE IsoLanguages SET shortcode='ar' WHERE code='ara';
UPDATE IsoLanguages SET shortcode='ca' WHERE code='cat';
UPDATE IsoLanguages SET shortcode='ch' WHERE code='chi';
UPDATE IsoLanguages SET shortcode='nl' WHERE code='dut';
UPDATE IsoLanguages SET shortcode='en' WHERE code='eng';
UPDATE IsoLanguages SET shortcode='fi' WHERE code='fin';
UPDATE IsoLanguages SET shortcode='fr' WHERE code='fre';
UPDATE IsoLanguages SET shortcode='de' WHERE code='ger';
UPDATE IsoLanguages SET shortcode='no' WHERE code='nor';
UPDATE IsoLanguages SET shortcode='po' WHERE code='por';
UPDATE IsoLanguages SET shortcode='ru' WHERE code='rus';
UPDATE IsoLanguages SET shortcode='sp' WHERE code='spa';
UPDATE IsoLanguages SET shortcode='vi' WHERE code='vie';

UPDATE Settings SET value='2.7.3' WHERE name='version';
UPDATE Settings SET value='0' WHERE name='subVersion';
