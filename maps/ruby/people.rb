require "digest/sha1"
require "pp"
require "sqlite3"

class People
  def initialize(oid, firstname, lastname, extension)
    @oid=oid
    @firstname=firstname
    @lastname=lastname
    @extension=extension
    fullname= lastname+firstname+'_'+'_'+extension
    @hash=Digest::SHA1.hexdigest(fullname)
  end
  def save(db)
#    pp self
    db.execute("UPDATE people set hash=? where oid=?", @hash, @oid)
  end
end


# Open a database
# create table people (id blob, firstname text, lastname, rank text, title text);
#db = SQLite3::Database.new "../Osprey.sqlite"
db = SQLite3::Database.new "../1815.sqlite"
# Find all people
db.execute('select oid, firstname, lastname, extension from people') do |row|
    p=People.new(row[0],row[1], row[2], row[3])
    p.save(db)  
end
