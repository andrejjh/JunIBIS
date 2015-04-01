require "digest/sha1"
require "pp"
require "sqlite3"

#    db.execute("UPDATE people set id=? where oid=?", @id, @oid)
def handleStack(datetime, latitude, longitude)

  
end  
# Open a database
# create table people (id blob, firstname text, lastname, rank text, title text);
db = SQLite3::Database.new "../1815.sqlite"
# Find all people
db.execute('select distinct datetime from moves order by datetime') do |dt|
  pp dt[0]
  db.execute('select latitude, longitude, count(*) as count from moves where datetime=? group by latitude, longitude',dt[0]) do |row|
    handleStack(dt[0],row[0], row[1])
    if row[2].to_f > 1 then 
##      pp row
      @offset=2
      @datetime=dt[0]
      @lat10000=(row[0]*10000).round
      @lon10000=(row[1]*10000).round
      db.execute('select oid, unitid from moves where datetime=? and latitude=? and longitude=? order by army desc',dt[0], row[0], row[1]) do |unit|
        @latitude=@lat10000.to_f/10000
        @longitude=@lon10000.to_f/10000
#        msg= unit[1] + ' moved to (' + @latitude.to_s + ', ' +@longitude.to_s + ')'
#        pp msg
        db.execute('update moves set flat=?, flong=? where oid=?',@latitude, @longitude,unit[0])
        @lat10000 =@lat10000 + @offset
        @lon10000 =@lon10000 + @offset
      end
    end
#    p=People.new(row[0],row[1], row[2])
#    p.save(db)  
  end
end
