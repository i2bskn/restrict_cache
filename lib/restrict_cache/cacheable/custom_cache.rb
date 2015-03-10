module RestrictCache
  class Cacheable
    class CustomCache < Base
      def add(cache_key, content)
        @caches[cache_key.to_sym] = content
      end

      def contents(cache_key = nil)
        cache_key ? @caches[cache_key.to_sym] : nil
      end
    end
  end
end
