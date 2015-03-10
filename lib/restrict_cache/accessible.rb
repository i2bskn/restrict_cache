module RestrictCache
  module Accessible
    THREAD_KEY = :restrict_cache

    def collection
      Thread.current[THREAD_KEY] ||= Cacheable.new
    end

    def clear
      Thread.current[THREAD_KEY] = nil
    end
  end

  extend Accessible
end

