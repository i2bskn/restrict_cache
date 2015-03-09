module RestrictCache
  module ActiveRecordExt
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def find_and_restrict_cache(arg)
        records = find(arg)
        Array(records).each(&:restrict_cache)
        records
      end

      def find_from_restrict_cache(arg)
        contents = RestrictCache.collection.active_record.contents(self.table_name)
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

      private
        def restrict_cached?(args)
          content = RestrictCache.collection.active_record.contents(self.table_name)
          return false unless content
          ids = content.keys
          args.all? {|index| ids.include?(index) }
        end
    end

    def restrict_cache
      RestrictCache.collection.add(self)
    end
  end
end

