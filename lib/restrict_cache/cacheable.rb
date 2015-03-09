require "restrict_cache/cacheable/active_record_cache"

module RestrictCache
  class Cacheable
    def self.build_inner_cache(key)
      const_get(key.to_s.classify, false).new
    end

    def initialize
      @cache_collection = {}
    end

    def add(content)
      inner_cache(inner_cache_key(content)).add(content)
    end

    def active_record
      inner_cache(:active_record_cache)
    end

    private
      def inner_cache_key(content)
        case
        when content.class < ActiveRecord::Base then :active_record_cache
        else :custom_cache
        end
      end

      def inner_cache(key)
        @cache_collection[key] ||= self.class.build_inner_cache(key)
      end
  end
end

