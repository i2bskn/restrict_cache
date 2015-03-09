module RestrictCache
  module Accessible
    GLOBAL_CACHE_KEY = :restrict_cache

    def collection
      Thread.current[GLOBAL_CACHE_KEY] ||= Cacheable.new
    end

    def clear
      Thread.current[GLOBAL_CACHE_KEY] = nil
    end
  end

  extend Accessible
end

