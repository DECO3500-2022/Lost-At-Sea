module RabbitMQInterface
    class Producer
        def initialize(hostname, queue)
            @hostname = hostname
            @queue = queue
            @connection = Bunny.new(hostname: hostname)
            @channel = nil
        end
      
        def start()
            @connection.start
            @channel = @connection.create_channel
        end
      
        def enqueue(message)
            @channel.default_exchange.publish(message, routing_key: @queue)
        end
        
        def close()
            @connection.close
        end
    
        def send(message)
            self.start
            self.enqueue(message)
            self.close()
        end
    end
end
