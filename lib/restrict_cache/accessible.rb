module RestrictCache
  module Accessible
    THREAD_KEY = :restrict_cache

    def cache
      Thread.current[THREAD_KEY] ||= Cacheable.new
    end

    def clear
      Thread.current[THREAD_KEY] = nil
    end

    def method_missing(name, *args, &block)
      super unless cache.respond_to?(name)

      define_singleton_method(name) do |*a, &b|
        cache.public_send(name, *a, &b)
      end

      send(name, *args, &block)
    end
  end

  extend Accessible
end

