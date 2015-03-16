require "digest/sha1"
require "pp"
require "sqlite3"

class People
  def initialize(firstname, lastname,rank, title)
    @firstname=firstname
    @lastname=lastname
    @rank=rank
    @title=title
    @id=Digest::SHA1.hexdigest(name)
  end
  def save(db)
    db.execute("INSERT INTO people (id, firstname, lastname, rank, title) VALUES (?, ?, ?, ?, ?)", @id, @firstname, @lastname,@rank, @title)
  end
end


# Open a database
# create table people (id blob, firstname text, lastname, rank text, title text);
db = SQLite3::Database.new "../1815.sqlite"
# Find units chiefs
db.execute('select distinct firstname, lastname, grade, title from ospreypeople') do |row|
  if row[0].length>0
    p=People.new(row[0],row[1],row[2], row[3])
#  pp p
    p.save(db)  
  end
end
