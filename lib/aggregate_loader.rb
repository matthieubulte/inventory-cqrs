require 'bus.rb'

class AggregateNotFound < StandardError
end

class AggregateLoader
  def initialize(event_store)
    @event_store = event_store
  end

  def load(aggregate_id, aggregate)
    events = @event_store.events_of(aggregate_id)
    
    raise AggregateNotFound if events.empty?

    tmp_bus = Bus.new
    tmp_bus.subscribe aggregate

    events.each { |event| tmp_bus.publish(event) }
    aggregate
  end
end
