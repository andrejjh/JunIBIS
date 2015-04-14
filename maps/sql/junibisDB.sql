#Start Postgres and Postico
# JdePotter input files
drop schema JdP cascade;
create schema JdP;


drop table JdP.units CASCADE;	
create table JdP.units(code varchar(16) primary key, parent varchar(16), absence varchar(16), name varchar(64), type varchar(16), rank varchar(16), grade varchar(16),title varchar(16), commander varchar(64), QG varchar(64), QGDate varchar(16), EMS integer, OFFINF integer, SOLINF integer, Bn integer, OFFGEN integer, SOLGEN integer, Cie integer, OFFART integer, SOLART	integer, Btt	integer, PC integer, OFFCAV integer, SOLCAV	integer, Sq	integer, INF integer, GEN integer, ART integer, CAV integer, Total	integer);
copy JdP.units from '/Users/aheugheb/ws/1815/csv/1815/1815UnitsBLC.csv' with CSV HEADER delimiter ';';
copy JdP.units from '/Users/aheugheb/ws/1815/csv/1815/1815UnitsFAN.csv' with CSV HEADER delimiter ';';
copy JdP.units from '/Users/aheugheb/ws/1815/csv/1815/1815UnitsPLR.csv' with CSV HEADER delimiter ';';
update JdP.units set rank='Br' where rank='BR';
update JdP.units set rank='Div' where rank='DN';
update JdP.units set type='Inf.' where type='I';
update JdP.units set type='Cav.' where type='C';
update JdP.units set type='Art.' where type='A';
update JdP.units set type='Eng.' where type='G';
update JdP.units set type='E-M'  where type='E';
update JdP.units set type='Amb.' where type='B';

drop table JdP.people cascade;	
create table JdP.people(hash varchar(40) primary key,rank varchar(16), title varchar(16),firstname varchar(64), lastname varchar(64), extension varchar(16),unit varchar(16), role varchar(16),source int, line int);
copy JdP.people from '/Users/aheugheb/ws/1815/csv/1815/1815People.csv' with CSV HEADER delimiter ';';
			

# JFranklin input files
create schema JF;
drop table JF.people;	
create table JF.people(hash varchar(40) primary key, wikidata varchar(16), title varchar(16), rank varchar(16), firstname varchar(64), lastname varchar(64), unit varchar(16), role varchar(16), roleFull text, remark text, sheet int, line int);	
copy JF.people from '/Users/aheugheb/ws/1815/csv/OspreyPeople.csv' with CSV HEADER delimiter ';';
	
# vocabulary files
drop table sources CASCADE;
drop table schemes CASCADE;
drop table terms CASCADE;
create table sources (id serial primary key, code varchar(16) unique, reference text, image text);
create table schemes (id serial primary key, code varchar(16) unique, name_de text, name_en text, name_fr text);
create table terms (id serial primary key, code varchar(16) unique, scheme_code varchar(16), scheme_id int references schemes, name_de text, name_en text, name_fr text);
copy schemes (code, name_de, name_en, name_fr) from '/Users/aheugheb/ws/1815/csv/schemes.csv' with CSV HEADER delimiter ';';
copy terms (code, scheme_code, name_de, name_en, name_fr)from '/Users/aheugheb/ws/1815/csv/terms.csv' with CSV HEADER delimiter ';';
update terms set scheme_id=s.id from (select id, code from schemes) as s  where scheme_code=s.code;
copy sources (code, reference) from '/Users/aheugheb/ws/1815/csv/sources.csv' with CSV HEADER delimiter ';';
drop table maps CASCADE;
create table maps (id serial primary key, code varchar(16) unique, name text, url text, iframe text, cartoDB text);
copy maps (code, name, url, iframe, cartoDB) from '/Users/aheugheb/ws/1815/csv/cartoDBmaps.csv' with CSV HEADER delimiter ';';


# BASE Entities
#drop table events CASCADE;
#create table events (id serial primary key, code varchar(16) unique, type int references terms, beginDate text, endDate text, placeid int references places, wikiURL text, source int references source);
drop table people CASCADE;
create table people (id serial primary key, SHA1 varchar(40) unique, rank int references terms, title int references terms, firstname text, lastname text, nation int references terms, wikidata text, source int references sources);
drop table units CASCADE;
create table units (id serial primary key, code varchar(16) unique, parent varchar(16), parent_id int references units, absence int references terms, name text, bataillons int, squadrons int, batteries int, engineers int, ems int, officers int, men int, total int,category int references terms, rank int references terms, nation int references terms, icon char(4), source int references sources);

# Links
drop table upLinks cascade;
create table upLinks (unit_id int references units, person_id int references people, role_id int references terms, source int references sources);
create table ueLinks (unit_id int references units, event_id int references events, source int references sources); 
create table peLinks (unit_id int references units, event_id int references events, source int references sources);

# Alternative Names
create table uNames (unit_id references units, name_de text, name_en text, name_fr text, source references sources);
# Alternative Strengths
create table uStrengths (unit_id references units, officers int, men int, total int, source references sources);
# Alternative Losses
create table uLosses (unit_id references units, officers int, men int, total int, source references sources);
	
	
# Populate units from JdP source
insert into units (code, parent, absence, name, ems, officers ,men, bataillons, squadrons, batteries, engineers, category, rank, icon, source) 
	select u.code, parent, absence.id, name, 
	ems, OFFINF+OFFCAV+OFFART+OFFGEN, SOLINF+SOLCAV+SOLART+SOLGEN, 
	Bn, Sq, Btt, Cie, type.id , rank.id, substr(u.code,1,1)||substr(u.type,1,1)||'B', 1 
	from JdP.units u 
	left join terms as rank on rank.code= u.rank 
	left join terms as type on type.code= u.type 
	left join terms as absence on absence.code=u.absence
	where rank in ('AR', 'CPS', 'Br','Div', 'Sub');	
insert into units (code, parent, absence, name, ems, officers ,men, bataillons, squadrons, batteries, engineers, category, rank, icon, source) 
	select u.code, parent, absence.id, name, ems, 
	case u.type when('Inf.') then OFFINF when('Cav.')then OFFCAV when ('Art.')then OFFART when ('Eng.') then OFFGEN else 0 end, 
	case u.type when('Inf.') then SOLINF when('Cav.')then SOLCAV when ('Art.')then SOLART when ('Eng.') then SOLGEN else 0 end, 
	Bn, Sq, Btt, Cie, type.id , rank.id, substr(u.code,1,1)||substr(u.type,1,1)||'B', 1 
	from JdP.units u 
	left join terms as rank on rank.code= u.rank 
	left join terms as type on type.code= u.type 
	left join terms as absence on absence.code=u.absence
	where rank not in ('AR', 'CPS', 'Br','Div', 'Sub');	

update units set total=officers+men;
update units set parent_id=parent.id from units parent where parent.code=units.parent;
update units set nation= nation.id from terms nation where nation.code= case substr(units.code,1,1) when 'B' then 'British' when 'P' then 'Prussian' when 'H' then 'Hanovrian' when 'R' then 'Brunswick' when 'N' then 'Dutch' else 'French' end;

# Populate people and uplinks from JdP source
insert into people (SHA1, rank, title, firstname, lastname, nation, source) 
	select p.hash, rank.id, title.id, firstname, lastname, u.nation, p.source from JdP.people p 
	left join units u on u.code=p.unit
	left join terms rank on rank.code=p.rank
	left join terms title on title.code=p.title
	order by lastname, firstname;
insert into uplinks select u.id, p.id, role.id, jdp.source from JdP.people jdp
	left join units u on u.code=jdp.unit
	left join people p on p.SHA1=jdp.hash
	left join terms role on role.code=jdp.role;


# Quality checks
select * from uplinks left join people p on p.id=person_id where role_id is null;
	
insert into uelinks select id, 'Quatre-Bras', 2 from JF.units where Sheet=2;
insert into pelinks select id, 'Quatre-Bras', 2 from JF.people where Sheet=2;
insert into uelinks select id, 'Ligny', 3 from JF.units where Sheet=3;
insert into pelinks select id, 'Ligny', 3 from JF.people where Sheet=3;
	 
	
# explore	
select tit.name_en, firstname, lastname, t.name_en, u.name from people p left join uplinks up on up.person_id=p.id left join units u on u.id=up.unit_id left join terms t on t.id=up.role left join terms tit on tit.id=p.title;
	