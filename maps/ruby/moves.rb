require "pp"
require "sqlite3"

class Move
  attr_reader :place, :longitude, :latitude, :arrival, :departure, :meantime
  def initialize(place, longitude, latitude, arrival, departure)
    @place=place
    @longitude=longitude
    @latitude=latitude
    @arrival=arrival
    @departure=departure
    @meantime= @arrival.nil? ? @departure : @departure.nil? ? @arrival : @arrival + (@departure- @arrival)/2
 #   pp self
  end

  def <=>(other)
      @meantime <=> other.meantime
  end
  def arrives()
    return arrival.nil? ? @departure : @arrival
  end
  def departs()
     return departure.nil? ? @arrival : @departure
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
      return nil
    end

  end

  def move(place, longitude, latitude, arrival, departure)
    @moves << Move.new(place, longitude.to_f, latitude.to_f, to_time(arrival), to_time(departure))
  end
  def itinerary(froms, tos, increment)
    where=""
    visible=false
    results = Array.new
    if @moves.empty?
      return results
    end
    from=to_time(froms)
    to=to_time(tos)
    @moves=@moves.sort()
    pm=nil
    dt=from
    step=0
    idx=0
    m=@moves.at(idx)

    until dt > to
      while (!m.nil?) && (dt > m.departs)
        pm=m
        idx+=1
        m=@moves.at(idx)
        visible= !m.nil?
      end
      if !m.nil?
        if (dt < m.arrives)
        then # on its way to m
          visible= pm.nil? ? false : !pm.departure.nil?
#          where= pm.nil? ? 'nowhere yet' : 'en route between ' + pm.place + ' and ' + m.place
          x= pm.nil? ? 0 : ((dt-pm.departs) * m.longitude + (m.arrives-dt) * pm.longitude) / (m.arrives-pm.departs)
          y= pm.nil? ? 0 : ((dt-pm.departs) * m.latitude + (m.arrives-dt) * pm.latitude) / (m.arrives-pm.departs)
        else # precisely at position m
          visible= !m.departure.nil?
#         where= 'exactly at ' + m.place
            x= m.longitude
            y= m.latitude
        end
      end
#      pp( dt.strftime('18%y/%m/%d %H:%M:%S'), where, visible, m)
      results << [@id, @part, step ,dt.strftime('18%y/%m/%d %H:%M:%S'), y.to_s, x.to_s ] unless !visible
      step=step+1
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
    # Generate unit itinerary
    moves= unit.itinerary(battle.start, battle.stop, 3600)
    moves.each do |m|
#  pp m
     db.execute("INSERT INTO moves (unitID, part, step, datetime, latitude, longitude) VALUES (?, ?, ?, ?, ?, ?)", m)
    end
end
