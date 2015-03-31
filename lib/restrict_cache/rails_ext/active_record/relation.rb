module RestrictCache
  module RailsExt
    module ActiveRecord
      module Relation
        def find_from_restrict_cache(*args)
          return nil unless cached_contents

          case args.first
          when Integer
            cached_contents[args.first]
          when String
            cached_contents[args.first.to_i]
          when Array
            args.first.map {|index| cached_contents[index.to_i] }
          else
            raise "unknown argument: #{args.inspect}"
          end
        end

        def find_with_restrict_cache(*args, &block)
          if restrict_cached?(*args)
            records = find_from_restrict_cache(*args)
          else
            records = find_and_restrict_cache(*args)
          end

          block_given? ? records.each {|record| block.call(record) } : records
        end
        alias_method :find_with_rc, :find_with_restrict_cache

        def with_restrict_cache
          self.each(&:restrict_cache) && self
        end
        alias_method :with_rc, :with_restrict_cache

        private
          def cached_contents
            RestrictCache.send(CacheCollection::CacheKey::ACTIVERECORD).contents(self.table_name)
          end

          def restrict_cached?(*args)
            return false unless cached_contents
            args.all? {|index| cached_contents.include?(index) }
          end

          def find_and_restrict_cache(*args)
            records = find(*args)
            Array(records).each(&:restrict_cache)
            records
          end
      end
    end
  end
end

