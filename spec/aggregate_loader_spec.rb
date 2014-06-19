require_relative '../lib/aggregate_loader.rb'

describe AggregateLoader do
  describe 'load' do
    it 'raises an AggregateNotFound exeption if not events where found for the given aggregate_id' do
      event_store = double('event_store', :events_of => [])
      aggregate_loader = AggregateLoader.new(event_store)

      expect { aggregate_loader.load(0, {}) }.to raise_error(AggregateNotFound) 
    end

    it 'calls returns a new instance of the aggregate on which all events for the given id where handled' do
      event_1 = double('event_1')
      event_2 = double('event_2')
      aggregate = double('aggregate')
      
      event_store = double('event_store', :events_of => [event_1, event_2])
      aggregate_loader = AggregateLoader.new(event_store)

      expect(aggregate).to receive(:handle).with(event_1).ordered
      expect(aggregate).to receive(:handle).with(event_2).ordered

      aggregate_loader.load(0, aggregate)
    end
  end
end
