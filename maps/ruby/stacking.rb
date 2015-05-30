#require "digest/sha1"
require "pp"
require "sqlite3"

@radius=[0,10,10,10,10,10,10,20,20,20,20,20,20,30,30,30,30,30,30,40,40,40,40,40,40]
@angles=[0,270,150,30,330,210,90,60,0,300,240,180,120,90,30,330,270,210,150,120,60,0,300,240,180]


def handleStack(oid, lat, long, index,db)
#  puts(oid.to_s+";"+index.to_s+";"+@latitude.to_s+";"+@longitude.to_s)
  @dLat=@radius[index]*Math.sin(@angles[index].to_f*Math::PI/180)
  @dLong=@radius[index]*Math.cos(@angles[index].to_f*Math::PI/180)
  @latitude= (lat * 10000 + @dLat).round.to_f/10000
  @longitude= (long * 10000 + @dLong).round.to_f/10000  
  
  db.execute('update moves set flat=?, flong=? where oid=?',@latitude, @longitude,oid)
end  
    
# Open a database
db = SQLite3::Database.new "../1815.sqlite"
# Find stacked units
db.execute('select distinct step from moves order by step') do |step|
  pp step[0]
  db.execute('select latitude, longitude, count(*) as count from moves where step=? group by latitude, longitude',step[0]) do |row|
    if row[2].to_i > 1 and row[2].to_i <= 25 then 
      @index=0
      db.execute('select oid, unitid from moves where step=? and latitude=? and longitude=? order by army desc',step[0], row[0], row[1]) do |unit|
        handleStack(unit[0],row[0].to_f, row[1].to_f, @index, db)
        @index+=1
      end
    end
  end
end
