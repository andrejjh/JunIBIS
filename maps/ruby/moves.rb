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
class Detachment
  attr_reader :part, :moves
  def initialize(id,part)
    @id=id
    @part=part
    @moves= Array.new()
  end
  def to_time(s)
    re =%r{^(\d+)/(\d+)/(\d+)\s(\d+):(\d+):(\d+)}
    if md=re.match(s)
      return Time.gm(200+md[1].to_f,md[2].to_f, md[3].to_f, md[4].to_f, md[5].to_f, md[6].to_f)
    else
      return Time.now()
      pp ("No match for (#{s})!")
    end

  end

  def move(place, longitude, latitude, arrival, departure)
    @moves << Move.new(place, longitude.to_f, latitude.to_f, to_time(arrival), to_time(departure))
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
          # did not yet arrive to m
          where= pm.nil? ? '???' : 'en route between ' + pm.place + ' and ' + m.place
          x= pm.nil? ? 0 : ((dt-pm.departure) * m.longitude + (m.arrival-dt) * pm.longitude) / (m.arrival-pm.departure)
          y= pm.nil? ? 0 : ((dt-pm.departure) * m.latitude + (m.arrival-dt) * pm.latitude) / (m.arrival-pm.departure)
        elsif (dt > m.departure)
          # already depart from m
          while (!m.nil?) && (dt > m.departure)
            pm=m
            idx+=1
            m=@moves.at(idx)
          end
          where= m.nil? ? '???' : 'en route between ' + pm.place + ' and ' + m.place
          x= m.nil? ? 0 : ((dt-pm.departure) * m.longitude + (m.arrival-dt) * pm.longitude) / (m.arrival-pm.departure)
          y= m.nil? ? 0 : ((dt-pm.departure) * m.latitude + (m.arrival-dt) * pm.latitude) / (m.arrival-pm.departure)
        else 
          # currently at position m         
          where= 'at ' + m.place
          x= m.longitude
          y= m.latitude
        end
      end
      results << [@id, @part, dt.strftime('18%y/%m/%d %H:%M:%S'), y.to_s, x.to_s ] unless where=='???'
      dt=dt+ increment
      end
    return results
  end
end
class Battle
  attr_reader :id, :start, :stop
  def initialize(id,start,stop,type)
    @id=id
    @start=start
    @stop=stop
    @type=type
  end
end
class Unit
  def initialize(id)
    @id=id
    @detachments= Hash.new()
  end
  def move(part,place, longitude, latitude, arrival, departure)
    if (part=="") then part="0" end
    if !@detachments.include?(part)
        @detachments[part]= Detachment.new(@id,part)
    end
    d=@detachments[part]
    d.move(place, longitude.to_f, latitude.to_f, arrival, departure)
  end
    
  def itinerary(froms, tos, increment)
    results = Array.new
    @detachments.each_value do |d|
      results = results + d.itinerary(froms, tos, increment)
    end
    return results
  end  
  def showMoves()
    pp @detachments
  end
end

unitIDs = Array.new()
battle = nil
# Open a database
db = SQLite3::Database.new "../1815.sqlite"
# Find units for which itineraries should be generated
db.execute( 'select id, begin,end, type from battles where ID=?',ARGV[0]) do |row|
  battle=Battle.new(row[0], row[1], row[2], row[3])
  pp battle
end
db.execute( 'select unitID from battleUnits where battleID=? order by unitID', battle.id) do |row|
  unitIDs << row[0]
end
unitIDs.each do |unitID|
    pp unitID
    unit= Unit.new(unitID)
    # Find unit positions
    db.execute( 'select p.part, l.id, l.longitude, l.latitude, p.Arrival, p.Departure from positions p left join locations l on l.id=p.locID where unitID=? order by p.arrival', unitID ) do |row|
#   pp row
    unit.move(row[0], row[1], row[2], row[3], row[4],row[5])
  end
#  unit.showMoves
  # Generate unit itinerary
#  moves= unit.itinerary('1815/06/14 20:00:00', '1815/06/16 04:00:00')
  moves= unit.itinerary(battle.start, battle.stop, 1800)
  moves.each do |m|
#  pp m
   db.execute("INSERT INTO moves (unitID, part, datetime, latitude, longitude) VALUES (?, ?, ?, ?, ?)", m)
  end
end
