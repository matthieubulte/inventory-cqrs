require_relative '../lib/bus.rb'

class DummySubscriber
  def handle
  end

  def handleFoo
  end
end

describe Bus do
  it 'gets created with no subscribers' do
    bus = Bus.new
    expect(bus.subscribers).to be_empty
  end

  describe 'suscribe' do
    it 'can add subscriber not previously added' do
      bus = Bus.new
      bus.subscribe({})

      expect(bus.subscribers).to include({})
    end

    it 'doesn\'t add subscribers already added' do
      bus = Bus.new
      bus.subscribe({})
      bus.subscribe({})

      expect(bus.subscribers).to contain_exactly({})
    end
  end

  describe 'unsubscribe' do
    it 'can remove subscriber previously added' do
      bus = Bus.new
      bus.subscribe({})
      bus.unsubscribe({})

      expect(bus.subscribers).to be_empty
    end

    it 'doesn\'t change the subscribers list if the subscriber parameter hasn\'t been registered before' do
      bus = Bus.new
      bus.subscribe({:foo => 'Foo'})
      bus.unsubscribe({})

      expect(bus.subscribers).to contain_exactly({:foo => 'Foo'})
    end
  end

  describe 'publish_as' do
    it 'calls the names handle method on subscribers' do
      bus = Bus.new
      subscriber = double
      bus.subscribe subscriber
      
      expect(subscriber).to receive(:handle_Foo).with({})
      bus.publish_as({}, 'Foo')
    end

    it 'calls the default `handle` method if the named handle method is not defined' do
      bus = Bus.new
      subscriber = double

      allow(subscriber).to receive(:respond_to?).with('handle_Foo').and_return(false)     
      allow(subscriber).to receive(:respond_to?).with('handle').and_return(true)
      expect(subscriber).to receive(:handle).with({})
      
      bus.subscribe subscriber
      bus.publish_as({}, 'Foo')
    end

    it 'doesn\'t call any method if neither the named handle nor the default `handle` method are defined' do
      bus = Bus.new
      subscriber = double

      allow(subscriber).to receive(:respond_to?).with('handle_Foo').and_return(false)     
      allow(subscriber).to receive(:respond_to?).with('handle').and_return(false)
      
      bus.subscribe subscriber
      bus.publish_as({}, 'Foo') 
    end
  end

  describe 'publish' do
    it 'calls the handle method using message class name' do
      class Foo
      end

      bus = Bus.new
      subscriber = double
      message = Foo.new
      bus.subscribe subscriber
      
      expect(subscriber).to receive(:handle_Foo).with(message)
      bus.publish(message)
    end
  end
end
