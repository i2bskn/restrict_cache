module RestrictCache
  class Cacheable
    class Base
      def initialize
        @caches = {}
      end

      def add(content)
        raise NotImplementedError
      end

      def contents(_table_name)
        raise NotImplementedError
      end

      def size
        @caches.size
      end
    end
  end
end

