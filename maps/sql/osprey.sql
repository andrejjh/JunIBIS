# SQLITE3 Osprey.sqlite
.mode csv
.separator ;
.header on

# Import data
.import csv/OspreyPeople1.csv people
.import csv/OspreyPeople2.csv people
.import csv/OspreyUnitsBLC.csv units
.import csv/OspreyUnitsFAN.csv units
.import csv/OspreyUnitsPLR.csv units

create unique index units_id on units (id);
#run ruby people.rb
create unique index people_id on units (id);

# Quality control
select * from people where unitid not in (select id from units);

