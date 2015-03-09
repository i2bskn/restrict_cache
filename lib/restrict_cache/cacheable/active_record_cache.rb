module RestrictCache
  class Cacheable
    class ActiveRecordCache
      def initialize
        @caches = {}
      end

      def add(content)
        @caches[table_name(content)] ||= {}
        @caches[table_name(content)][content.id] = content
      end

      def contents(_table_name)
        @caches[_table_name.to_sym]
      end

      private
        def table_name(content)
          content.class.table_name.to_sym
        end
    end
  end
end

