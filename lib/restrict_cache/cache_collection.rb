require "restrict_cache/cache_collection/inner_cache"
require "restrict_cache/cache_collection/active_record_cache" if defined?(ActiveRecord)
require "restrict_cache/cache_collection/custom_cache"

module RestrictCache
  class CacheCollection
    module CacheKey
      ACTIVERECORD = :active_record_cache
      CUSTOM = :custom_cache
      ALL = [
        defined?(ActiveRecord) ? ACTIVERECORD : nil,
        CUSTOM,
      ].compact.freeze

      def self.get(content)
        case
        when defined?(ActiveRecord) && content.class < ActiveRecord::Base
          ACTIVERECORD
        when content.class < RestrictCache::Base
          CUSTOM
        else
          raise "unknown cache class"
        end
      end
    end

    class << self
      def build_inner_cache(key)
        const_get(key.to_s.classify, false).new
      end
    end

    CacheKey::ALL.each do |inner_cache_key|
      define_method inner_cache_key do
        inner_cache inner_cache_key
      end
    end

    def initialize
      @cache_collection = {}
    end

    def add(content)
      inner_cache(CacheKey.get(content)).add(content)
    end

    def [](key)
      return nil unless key
      @cache_collection[key]
    end

    def cache_keys
      CacheKey::ALL
    end

    private
      def inner_cache(key)
        @cache_collection[key] ||= self.class.build_inner_cache(key)
      end
  end
end

