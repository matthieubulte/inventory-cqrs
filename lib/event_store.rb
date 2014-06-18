class EventStore

  attr_reader :events
  def initialize
    @events = []
  end

  def save (event)
    @events << event if event.respond_to? :aggregate_id
  end

  def events_of (id)
    @events.select { |event| event.aggregate_id == id }
  end 
end
