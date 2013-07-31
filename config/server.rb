require 'neverblock' unless defined?(NeverBlock)
require 'thin'

module Thin

  # Patch the thin server to use NeverBlock::Pool::FiberPool
  class Server

    DEFAULT_FIBER_POOL_SIZE = 20

    def fiber_pool
      @fiber_pool ||= NB::Pool::FiberPool.new(DEFAULT_FIBER_POOL_SIZE)
    end

  end

  # A request is processed by wrapping it in a fiber from the fiber pool.
  # If all the fibers are busy the request will wait in a queue to be picked up
  # later. Meanwhile, the server will still be processing requests
  class Connection < EventMachine::Connection

    def process
      @request.threaded = false
      @backend.server.fiber_pool.spawn {post_process(pre_process)}
    end

  end

end
