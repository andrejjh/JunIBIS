require "digest/sha1"
require "pp"
require "sqlite3"

class People
  def initialize(oid, firstname, lastname)
    @oid=oid
    @firstname=firstname
    @lastname=lastname
    fullname=firstname+' '+lastname
    @id=Digest::SHA1.hexdigest(fullname)
  end
  def save(db)
#    pp self
    db.execute("UPDATE people set id=? where oid=?", @id, @oid)
  end
end


# Open a database
# create table people (id blob, firstname text, lastname, rank text, title text);
db = SQLite3::Database.new "../Osprey.sqlite"
# Find all people
db.execute('select oid, firstname, lastname from people') do |row|
    p=People.new(row[0],row[1], row[2])
    p.save(db)  
end
