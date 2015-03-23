module RestrictCache
  class Base
    class << self
      def instance
        _cache = RestrictCache.custom_cache.contents(cache_key)
        _cache = RestrictCache.custom_cache.add(self.new) unless _cache
        _cache
      end

      def cache_key
        self.name
      end

      private
        def method_missing(name, *args, &block)
          super unless instance.respond_to?(name)

          define_singleton_method(name) do |*a, &b|
            instance.public_send(name, *a, &b)
          end

          send(name, *args, &block)
        end

        def respond_to_missing?(name, include_private = false)
          instance.respond_to?(name)
        end
    end
  end
end

