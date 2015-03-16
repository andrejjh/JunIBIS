attach '1815.sqlite' as src;
PRAGMA foreign_keys=ON;

# Static tables
create table sources (id varchar(16) primary key, reference text);
create table ranks (id varchar(16) primary key, name text);
create table places (id varchar(16) primary key, name text);

# BASIC Entities
create table events (id varchar(16) primary key, begin text, end text, placeid references places, wikiURL text);
create table people (id varchar(16) primary key, title text, firstname text, lastname text, wikiURL text);
create table units (id varchar(16) primary key, type char, rankid references ranks);

# Names
create table eNames (eventid references events, language varchar(2), name text, sourceid references sources);
	pkey=eventid+language+sourceid
create table uNames (unitid references units, language varchar(2), name text, sourceid references sources);
	pkey=unitid+language+sourceid
# Stengths
create table uStrengths (unitid references units, officers int, men int, total int, sourceid references sources);
	pkey=unitid+sourceid
	
# Links
create table uLeaders (unitid references units, personid references people, sourceid references sources);
	pkey=unitid+sourceid	
create table uODBs(unitid references units, parentid references units, sourceid references sources);
	pkey=unitid+sourceid	
create table uEvents (unitid references units, eventid references events, sourceid references sources); 
	pkey=unitid+sourceid	
	
# Populate
insert into sources values ('JPDePotter1981', 'Mise à mort de l Empire par Napoléon. Jean-Pierre de Potter. Editions Graffitti 1981'),('JFranklin2015', ''),('ClashOfArms', '');
insert into ranks values ('AR', 'Army'), ('CPS', 'Corps'), ('DN', 'Division'), ('BR', 'Brigade'), ('Rgt', 'Regiment'), ('Bn', 'Battailon'), ('Sq', 'Squadron'), ('Cie', 'Company'), ('Batt', 'Battery'), ('Sub', 'Other subgroup'), ('Park', 'Artillery park'), ('EM', 'Etat-Major');
insert into units select id, type, rank from src.units;	

insert into uNames select id, 'EN', name, 'JPDePotter1981' from src.units; 
update uNames set language='FR' where unitid like 'F%';

insert into uStrengths (unitid, officers,men, sourceid) select id, OFFINF, SOLINF, 'JPDePotter1981' from src.units where type='I';		
insert into uStrengths (unitid, officers,men, sourceid) select id, OFFCAV, SOLCAV, 'JPDePotter1981' from src.units where type='C';			
insert into uStrengths (unitid, officers,men, sourceid) select id, OFFART, SOLART, 'JPDePotter1981' from src.units where type='A';	
insert into uStrengths (unitid, officers,men, sourceid) select id, OFFGEN, SOLGEN, 'JPDePotter1981' from src.units where type='G';	
insert into uStrengths (unitid, officers,men, sourceid) select id, OFFINF+OFFCAV+OFFART+OFFGEN, SOLINF+SOLCAV+SOLART+SOLGEN, 'JPDePotter1981' from src.units where rank in('AR', 'CPS', 'DN', 'Sub');	
update uStrengths set total=officers+men;	
delete from uStrengths where total=0;

insert into uODBs select id, parentid, 'JPDePotter1981', from src.units;
	
					