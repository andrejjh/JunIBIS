# input files
## units ODB from JP dePotter 1981
* FAN=French, Armée du Nord,
* ALC=Anglo-Allied, Lower-Countries Army
* PLR=Prussiens, Lower Rhine Army

#create table units(id varchar(16) primary key, parentID varchar(16), name varchar(64), type varchar(16), rank varchar(16), grade varchar(16),title varchar(16), commander varchar(64), QG varchar(64), QGDate varchar(16), EMS integer, OFFINF integer, SOLINF integer, Bn integer, OFFGEN integer, SOLGEN integer, Cie integer, OFFART integer, SOLART	integer, Btt	integer, PC integer, OFFCAV integer, SOLCAV	integer, Sq	integer, INF integer, GEN integer, ART integer, CAV integer, Total	integer);
create table moves(unitid varchar(16), datetime text, latitude real, longitude real);
create table locations(idlong text, id varchar(16), name text, longitude real, latitude real, line int);

create table itineraries(unitid varchar(16));
insert into itineraries select distinct unitid from positions;

# prepare itineraries for French 2eme CA, Prussian 1st and 2nd Brigade
	 
insert into itineraries select id from units where parentid in ('P1Br', 'P2Br', 'F2A');	 
insert into itineraries select id from units where parentid in (select unitid from itineraries);	 

# SQLITE3 1815.sqlite
.mode csv
.separator ;
.header on

# Import data
.import csv/allunits.csv units
.import csv/MovesLoc.csv locations
.import csv/MovesPos.csv positions
.import csv/Battles.csv battles
.import csv/BattleUnits.csv battleUnits
update units set parentid=null where parentid="";
update units set type='I' where type='G';
update positions set departure=null where departure="";
	
# Create indexes
create unique index units_id on units (id);
create unique index locations_id on locations (id);
create unique index positions_sl on positions (line);
create unique index battles_id on battles (id);
		
# Quality control
select * from units where parentid not in (select id from units);
select * from positions where unitid not in (select id from units);
select * from positions where locid not in (select id from locations);
select * from battleUnits where unitid not in (select id from units);
select * from battleUnits where battleid not in (select id from battles);

# Export Views
drop view cartoDB;
create view cartoDB as select p.unitid, u.name, substr(u.id,1,1)||u.type as type, u.rank, u.chief, p.arrival, l.name as locality, l.latitude, l.longitude from positions p left join units u on u.id=p.unitid left join locations l on l.id=p.localityid order by p.line;
create view cartoMoves as select m.unitid, substr(u.id,1,1)||u.type||'B' as type, case(substr(u.id,1,1)) when 'F' then 1 when 'P' then 2 when 'B' then 3 when 'H' then 4 when 'R' then 5 else 6 end as army, m.datetime, m.latitude, m.longitude from moves m left join units u on u.id=m.unitid order by m.unitid, m.datetime;
.output csv/cartoMoves15.csv
select * from cartoMoves;

.exit



#Colors
1. P gray #808080
2. F blue #2080FF
3. B red #FF0000
4. N green #208000
5. H light red #F84F40
6. R Black #000000
