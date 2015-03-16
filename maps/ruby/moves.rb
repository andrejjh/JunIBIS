require "pp"
require "sqlite3"

class Move
  attr_reader :place, :longitude, :latitude, :arrival, :departure
  def initialize(place, longitude, latitude, arrival, departure)
    @place=place
    @longitude=longitude
    @latitude=latitude
    @arrival=arrival
    @departure=departure
  end

  def <=>(other)
    @arrival <=> other.arrival
  end
end

class Unit
  def to_time(s)
    re =%r{^(\d+)/(\d+)/(\d+)\s(\d+):(\d+):(\d+)}
    if md=re.match(s)
      return Time.gm(200+md[1].to_f,md[2].to_f, md[3].to_f, md[4].to_f, md[5].to_f, md[6].to_f)
    else
      return Time.now()
      pp ("No match for (#{s})!")
    end

  end
  def initialize(id)
    @id=id
    @moves= Array.new()
  end
  def move(place, longitude, latitude, arrival, departure)
    @moves << Move.new(place, longitude.to_f, latitude.to_f, to_time(arrival), to_time(departure))
  end
  def showMoves
    pp @moves
  end
  def itinerary(froms, tos, increment)
    results = Array.new
    if @moves.empty?
      return results
    end
    from=to_time(froms)
    to=to_time(tos)
    @moves=@moves.sort()
    pm=nil
    dt=from
    idx=0

    m=@moves.at(idx)
    while (!m.nil?) && (dt > m.departure)
      pm=m
      idx+=1
      m=@moves.at(idx)
    end

    until dt > to
      if m.nil?
        where = '???'
      else
        if (dt < m.arrival)
          where= pm.nil? ? '???' : 'en route between ' + pm.place + ' and ' + m.place
          x= pm.nil? ? 0 : ((dt-pm.departure) * m.longitude + (m.arrival-dt) * pm.longitude) / (m.arrival-pm.departure)
          y= pm.nil? ? 0 : ((dt-pm.departure) * m.latitude + (m.arrival-dt) * pm.latitude) / (m.arrival-pm.departure)
        else
          where= 'at ' + m.place
          x= m.longitude
          y= m.latitude
        end
        if (!m.nil?) &&  (dt >= m.departure)
          pm=m
          idx+=1
          m=@moves.at(idx)
        end
      end
      results << [@id,dt.strftime('18%y/%m/%d %H:%M:%S'), y.to_s, x.to_s ] unless where=='???'
      dt=dt+ increment
      end
    return results
  end
end

battleID='15CoB'
unitIDs = Array.new()
battleBegin=''
battleEnd=''
# Open a database
db = SQLite3::Database.new "../1815.sqlite"
# Find units for which itineraries should be generated
db.execute( 'select begin,end, type from battles where ID=?',battleID) do |row|
  battleBegin=row[0]
  battleEnd=row[1]
  battleType=row[2]
end
db.execute( 'select unitID from battleUnits where battleID=? order by unitID', battleID) do |row|
  unitIDs << row[0]
end
unitIDs.each do |unitID|
  pp unitID
  unit= Unit.new(unitID)
  # Find unit positions
  db.execute( 'select l.id, l.longitude, l.latitude, p.Arrival, p.Departure from positions p left join locations l on l.id=p.locID where unitID=? order by p.arrival', unitID ) do |row|
#    pp row
  unit.move(row[0], row[1], row[2], row[3], row[4])
#  unit.showMoves
  end
  # Generate unit itinerary
#  moves= unit.itinerary('1815/06/14 20:00:00', '1815/06/16 04:00:00')
  moves= unit.itinerary(battleBegin, battleEnd, 1800)
  moves.each do |m|
#    pp m
   db.execute("INSERT INTO moves (unitID, datetime, latitude, longitude) VALUES (?, ?, ?, ?)", m)
  end
end
