class Bus

  attr_reader :subscribers
  def initialize
    @subscribers = []
  end

  def subscribe (subscriber)
    @subscribers << subscriber unless @subscribers.include?(subscriber)
  end

  def unsubscribe (subscriber)
    @subscribers.delete subscriber
  end

  def publish_as(message, type)
    @subscribers.each {|subscriber| call_handler(subscriber, message, type)}
  end

  def publish(message)
    @subscribers.each {|subscriber| call_handler(subscriber, message, message.class.to_s)}
  end

  private

  def handler_of(type)
    "handle_#{type}"
  end

  def call_handler(subscriber, message, type)
    handler_name = handler_of type
    handler = 'handle' unless subscriber.respond_to? handler_name

    if subscriber.respond_to? handler_name
      subscriber.public_send(handler_name, message)
    elsif subscriber.respond_to? 'handle'
      subscriber.public_send('handle', message)
    end
  end
end
