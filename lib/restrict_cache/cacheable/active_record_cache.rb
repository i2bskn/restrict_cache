module RestrictCache
  class Cacheable
    class ActiveRecordCache < Base
      def add(content)
        tbl_name, index = table_name_of(content), index_of(content)
        @caches[tbl_name] ||= {}
        @caches[tbl_name][index] = content
      end

      def contents(_table_name)
        @caches[_table_name.to_sym]
      end

      private
        def table_name_of(content)
          content.class.table_name.to_sym
        end

        def index_of(content)
          content.public_send content.class.primary_key
        end
    end
  end
end

