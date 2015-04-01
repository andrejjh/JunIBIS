## units ODB from JP dePotter 1981
* FAN=French, Armée du Nord,
* ALC=Anglo-Allied, Lower-Countries Army
* PLR=Prussiens, Lower Rhine Army

#create table units(id varchar(16) primary key, parentID varchar(16), name varchar(64), type varchar(16), rank varchar(16), grade varchar(16),title varchar(16), commander varchar(64), QG varchar(64), QGDate varchar(16), EMS integer, OFFINF integer, SOLINF integer, Bn integer, OFFGEN integer, SOLGEN integer, Cie integer, OFFART integer, SOLART	integer, Btt	integer, PC integer, OFFCAV integer, SOLCAV	integer, Sq	integer, INF integer, GEN integer, ART integer, CAV integer, Total	integer);
#create table locations(idlong text, id varchar(16), name text, longitude real, latitude real, line int);


# SQLITE3 1815.sqlite
.mode csv
.separator ;
.header on

# Import data
.import csv/1815unitsBLC.csv units
.import csv/1815unitsFAN.csv units
.import csv/1815unitsPLR.csv units
.import csv/MovesLoc.csv locations
.import csv/MovesPos.csv positions
.import csv/Battles.csv battles
.import csv/BattleUnits.csv battleUnits
.import csv/Ranks.csv ranks

update units set parentid=null where parentid="";
#update units set type='I' where type='G';
update positions set departure=null where departure="";
	
# Create indexes
create unique index units_id on units (id);
create unique index locations_id on locations (id);
create unique index positions_sl on positions (line);
create unique index battles_id on battles (id);
create unique index ranks_id on ranks (id);
		
# allUnits for 15CoB battle
insert into battleUnits select distinct '15CoB', unitID from positions order by unitID; 
insert into battleUnits select distinct 'CoB', unitID from positions order by unitID; 

# Quality control
select * from units where parentid not in (select id from units);
select * from units where rank not in (select id from ranks);
select * from positions where unitid not in (select id from units);
select * from positions where locid not in (select id from locations);
select * from battleUnits where unitid not in (select id from units);
select * from battleUnits where battleid not in (select id from battles);


create table moves(unitid varchar(16), part int, datetime text, latitude real, longitude real, flat real, flong real, army int);
	# run ruby moves.rb
update moves set flat=round(latitude, 4), flong=round(longitude,4);
update moves set army = case(substr(unitid,1,1)) when 'F' then 1 when 'P' then 2 when 'B' then 3 when 'H' then 4 when 'R' then 5 else 6 end;	
	# run ruby stacking.rb
# Export Views
#drop view cartoDB;
#create view cartoDB as select p.unitid, u.name, substr(u.id,1,1)||u.type as type, u.rank, u.chief, p.arrival, l.name as locality, l.latitude, l.longitude from positions p left join units u on u.id=p.unitid left join locations l on l.id=p.localityid order by p.line;
create view cartoMoves as select case (part) when 0 then m.unitid else m.unitid||'('||part||')' end as unitid, substr(u.id,1,1)||u.type|| r.size as type, army, m.datetime, m.flat as latitude, m.flong as longitude from moves m left join units u on u.id=m.unitid left join ranks r on r.id=u.rank order by m.unitid, m.datetime;
.once csv/CoBMoves.csv
select * from cartoMoves;

# Engineer use Infantry Unit!
FGM->FIM

.exit



