require_relative '../lib/event_store.rb'

class Event < Struct.new(:aggregate_id)
end

describe EventStore do
  it 'is empty at instantiation' do
    event_store = EventStore.new
    expect(event_store.events).to be_empty
  end

  describe 'save' do
    it 'saves event if they have an aggregate id' do
      event_store = EventStore.new
      event = Event.new(0)
      event_store.save(event)

      expect(event_store.events).to contain_exactly(event)
    end

    it 'doesn\'t save events with no aggregate id' do
      event_store = EventStore.new
      event_store.save({})

      expect(event_store.events).to be_empty
    end
  end

  describe 'events_of' do
    it 'returns an empty array if no event has the given aggregate id' do
      event_store = EventStore.new
      expect(event_store.events_of 0).to be_empty
    end

    it 'returns the events saved under a given aggregate id' do
      event_store = EventStore.new
      event = Event.new(0)
      event_store.save(event)

      expect(event_store.events_of 0).to contain_exactly(event)
    end
  end
end
