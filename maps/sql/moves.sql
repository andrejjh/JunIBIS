## units ODB from JP dePotter 1981, Positions and Locations from Eric


# SQLITE3 1815.sqlite
.mode csv
.separator ;
.header on

# Import data
.import csv/1815/1815units.csv units
.import csv/CoBLoc.csv locations
.import csv/MSJLoc.csv locations
.import csv/CoBPos.csv positions
.import csv/MSJPos.csv positions
.import csv/Battles.csv battles
.import csv/BattleUnits.csv battleUnits
.import csv/Ranks.csv ranks
.import csv/icons.csv icons
#.import csv/1815/1815people.csv people
#.import csv/1815/1815peopleBLC.csv people
#.import csv/1815/1815peopleFAN.csv people
#.import csv/1815/1815peoplePLR.csv people


update units set parentid=null where parentid="";
update positions set departure=null where departure="";
update positions set arrival=null where arrival="";

# Create indexes
create unique index units_id on units (id);
create unique index locations_id on locations (id);
create unique index positions_sl on positions (line);
create unique index battles_id on battles (id);
create unique index ranks_id on ranks (id);
create unique index icons_id on icons (id);
#create unique index people_hash on people(hash);


# Quality control
select * from units where parentid not in (select id from units);
select * from units where rank not in (select id from ranks);
select * from positions where unitid not in (select id from units);
select * from positions where locid not in (select id from locations);
select * from positions where arrival not like '1815/06/%' or departure not like '1815/06/%';
select * from positions where substr(arrival,9,2) not in ('14', '15','16','17','18','19','20','21', '22');
select * from positions where substr(departure,9,2) not in ('14', '15','16','17','18','19','20','21', '22');
select * from positions where arrival is null and departure is null;

select * from battleUnits where unitid not in (select id from units);
select * from battleUnits where battleid not in (select id from battles);
#select * from people where unit_id not in (select id from units);

# allUnits for 15CoB battle
insert into battleUnits select distinct 'CoB', unitID from positions order by unitID;


#run ruby people.rb
#.once csv/1815/1815people.csv
#select * from people;
#.once csv/1815/1815units.csv
#select * from units;

create table moves (unitID varchar(16), part int, step int, datetime text, latitude real , longitude real, army int, flat real, flong real);
# run ruby moves.rb CoB
update moves set flat=round(latitude, 4), flong=round(longitude,4);
update moves set army = case(substr(unitid,1,1)) when 'G' then 1 when 'F' then 1 when 'P' then 2 when 'B' then 3 when 'H' then 4 when 'R' then 5 else 6 end;
# run ruby stacking.rb

# Export Views
drop view cartoMoves;
#create view cartoDB as select p.unitid, u.name, substr(u.id,1,1)||u.type as type, u.rank, u.chief, p.arrival, l.name as locality, l.latitude, l.longitude from positions p left join units u on u.id=p.unitid left join locations l on l.id=p.localityid order by p.line;
create view cartoMoves as select case(part) when 0 then m.unitid else m.unitid || '-' || part end as unitid, icon.id as icon, army, m.step, m.datetime, m.flat as latitude, m.flong as longitude from moves m left join units u on u.id=m.unitid left join icons icon on icon.code=substr(m.unitid,1,1)||u.type||'B' order by m.unitid, m.step;
.once csv/CoBMoves28.csv
select * from cartoMoves;


.exit
