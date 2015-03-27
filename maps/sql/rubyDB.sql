attach '1815.sqlite' as srcP; # data from JPdePotter & Eric moves
attach 'Osprey.sqlite' as srcF; # data from JFranklin

PRAGMA foreign_keys=ON;

# Static tables (from CSV)
#create table sources (id varchar(16) primary key, reference text);
#create table places (id varchar(16) primary key, name_de text, name_en text, name_fr text);
#create table schemes (id varchar(16) primary key, name_de text, name_en text, name_fr text);
#create table terms (id varchar(16), schemeid references schemes, name_de text, name_en text, name_fr text);
# Populate Static tables from CSV
.import csv/sources.csv sources
create unique index sources_id on sources (id);
.import csv/places.csv places
create unique index places_id on places (id);
.import csv/schemes.csv schemes
create unique index schemes_id on schemes (id);
.import csv/terms.csv terms
create unique index terms_id on terms (id);
		

# BASE Entities
create table events (id varchar(16) primary key, type references terms, beginDate text, endDate text, placeid references places, wikiURL text, sourceid references source);
create table people (id varchar(40) primary key, rank references terms, title references terms, firstname text, lastname text, wikiURL text, sourceid references sources);
create table units (id varchar(16) primary key, parent references units, name text, officers int, men int, total int,type references terms, rankid references terms, sourceid references sources);
create unique index people_id on people (id);
create unique index units_id on units (id);

# Links
create table upLinks (unitid references units, personid references people, roleid references roles, sourceid references sources);
	pkey=unitid+personid	
create table ueLinks (unitid references units, eventid references events, sourceid references sources); 
	pkey=unitid+event	
create table peLinks (unitid references units, eventid references events, sourceid references sources); 
	pkey=unitid+event	

# Alternative Names
create table uNames (unitid references units, name_de text, name_en text, name_fr text, sourceid references sources);
	pkey=unitid+sourceid
# Alternative Strengths
create table uStrengths (unitid references units, officers int, men int, total int, sourceid references sources);
# Alternative Losses
create table uLosses (unitid references units, officers int, men int, total int, sourceid references sources);
pkey=unitid+sourceid
	
	
# JPDePotter source
# Populate units
insert into units (id, parent, name, officers ,men, type, rankid, sourceid) select id, parentid, name, OFFINF+OFFCAV+OFFART+OFFGEN, SOLINF+SOLCAV+SOLART+SOLGEN, type, rank,'JPDePotter1981' from srcP.units where rank in ('AR', 'CPS', 'DN', 'Sub');	
insert into units (id, parent, name, officers ,men, type, rankid, sourceid) select id, parentid, name, case type when('I') then OFFINF when('C')then OFFCAV when ('A')then OFFART else OFFGEN end, case type when('I') then SOLINF when('C')then SOLCAV when ('A')then SOLART else SOLGEN end, type, rank,'JPDePotter1981' from srcP.units where rank not in ('AR', 'CPS', 'DN', 'Sub');	

update units set total=officers+men;

# JFranklin source
# Populate people and uplinks
insert into people (id, rank, title, firstname, lastname, source) select id, rank, title, firstname, lastname,'JFranklin2015' from srcF.people order by lastname, firstname;
insert into uplinks select unitid, id, roleid, 'JFranklin2015' from srcF.people;
	