module RestrictCache
  module ActiveRecordExt
    module Base
      extend ActiveSupport::Concern

      module ClassMethods
        delegate :find_with_restrict_cache, to: :all
      end

      def restrict_cache
        RestrictCache.add(self)
      end
    end

    module Relation
      AR_CACHE_KEY = Cacheable::CacheKey::ACTIVERECORD

      def find_and_restrict_cache(arg)
        records = find(arg)
        Array(records).each(&:restrict_cache)
        records
      end

      def find_from_restrict_cache(arg)
        contents = RestrictCache.send(AR_CACHE_KEY).contents(self.table_name)
        return nil unless contents

        case arg
        when Integer
          contents[arg]
        when String
          contents[arg.to_i]
        when Array
          args.map {|index| contents[index.to_i] }
        else
          raise "unknown argument: #{arg.inspect}"
        end
      end

      def find_with_restrict_cache(arg)
        if restrict_cached?(Array(arg))
          records = Array(arg).map {|index| find_from_restrict_cache(index) }
          records.size > 1 ? records : records.first
        else
          find_and_restrict_cache(arg)
        end
      end

      def with_restrict_cache
        self.each(&:restrict_cache)
        self
      end

      private
        def restrict_cached?(args)
          content = RestrictCache.send(AR_CACHE_KEY).contents(self.table_name)
          return false unless content
          ids = content.keys
          args.all? {|index| ids.include?(index) }
        end
    end
  end
end

