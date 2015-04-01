.mode csv
.header on
.separator ;

attach '1815.sqlite' as srcP; 
attach 'Osprey.sqlite' as srcF; 

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
create table people (id varchar(40) primary key, rank references terms, title references terms, firstname text, lastname text, nation references terms, wikidata text, source references sources);
create table units (id varchar(16) primary key, parent references units, name text, bataillons int, squadrons int, batteries int, engineers int,officers int, men int, total int,type references terms, rank references terms, nation references terms, source references sources);
create unique index people_id on people (id);
create unique index units_id on units (id);

# Links
create table upLinks (unitid references units, personid references people, role references roles, source references sources);
	pkey=unitid+personid	
create table ueLinks (unitid references units, eventid references events, source references sources); 
	pkey=unitid+event	
create table peLinks (unitid references units, eventid references events, source references sources); 
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
insert into units (id, parent, name, officers ,men, bataillons, squadrons, batteries, engineers, type, rank, source) select id, parentid, name, OFFINF+OFFCAV+OFFART+OFFGEN, SOLINF+SOLCAV+SOLART+SOLGEN, Bn, Sq, Btt, Cie, case type when 'I' then 'Inf.' when 'C' then 'Cav.' when 'A' then 'Art.' when 'G' then 'Eng.' else 'EM' end, rank,'JPDePotter1981' from srcP.units where rank in ('AR', 'CPS', 'BR','DN', 'Sub');	
insert into units (id, parent, name, officers ,men, bataillons, squadrons, batteries, engineers, type, rank, source) select id, parentid, name, case type when('I') then OFFINF when('C')then OFFCAV when ('A')then OFFART else OFFGEN end, case type when('I') then SOLINF when('C')then SOLCAV when ('A')then SOLART else SOLGEN end, Bn, Sq, Btt, Cie, case type when 'I' then 'Inf.' when 'C' then 'Cav.' when 'A' then 'Art.' when 'G' then 'Eng.' else 'EM' end, rank,'JPDePotter1981' from srcP.units where rank not in ('AR', 'CPS', 'BR','DN', 'Sub');	

update units set total=officers+men;
update units set nation= 'British' where substr(id,1,1)='B';
update units set nation= 'French' where substr(id,1,1)='F';
update units set nation= 'Hanovrian' where substr(id,1,1)='H';
update units set nation= 'Brunswick' where substr(id,1,1)='R';
update units set nation= 'Dutch' where substr(id,1,1)='N';
update units set nation= 'Prussian' where substr(id,1,1)='P';

# JFranklin source
# Populate people and uplinks
insert into people (id, rank, title, firstname, lastname, nation, source) select id, rank, title, firstname, lastname, case substr(unitid,1,1) when 'B' then 'British' when 'F' then 'French' when 'H' then 'Hanovrian' when 'R' then 'Brunswick' when 'N' then 'Dutch' else 'Prussian' end, 'JFranklin2015' from srcF.people order by lastname, firstname;
insert into uplinks select unitid, id, roleid, 'JFranklin2015' from srcF.people;
insert into uelinks select id, 'Quatre-Bras', 'JFranklin2015' from srcF.units where Sheet=1;
insert into pelinks select id, 'Quatre-Bras', 'JFranklin2015' from srcF.people where Sheet=1;
insert into uelinks select id, 'Ligny', 'JFranklin2015' from srcF.units where Sheet=2;
insert into pelinks select id, 'Ligny', 'JFranklin2015' from srcF.people where Sheet=2;
	 
# JPDePotter source
# Populate people for all remaining units	
	
	
# explore
	
select tit.name_en, firstname, lastname, t.name_en, u.name from people p left join uplinks up on up.personid=p.id left join units u on u.id=up.unitid left join terms t on t.id=up.role left join terms tit on tit.id=p.title;
	