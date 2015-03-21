module RestrictCache
  module RailsExt
    module ActiveRecord
      module Base
        extend ActiveSupport::Concern

        module ClassMethods
          delegate :find_with_restrict_cache, to: :all
        end

        def restrict_cache
          RestrictCache.add(self)
        end
      end
    end
  end
end

