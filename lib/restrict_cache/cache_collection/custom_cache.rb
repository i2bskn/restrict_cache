module RestrictCache
  class CacheCollection
    class CustomCache < InnerCache
      def add(content)
        @caches[content.class.cache_key] = content
      end

      def contents(cache_key = nil)
        cache_key ? @caches[cache_key] : nil
      end
    end
  end
end

