module RestrictCache
  module RailsExt
    module ActiveRecord
      module Base
        extend ActiveSupport::Concern

        module ClassMethods
          %i(find_with_restrict_cache find_with_rc).each do |key|
            delegate key, to: :all
          end
        end

        def restrict_cache
          RestrictCache.add(self)
        end
      end
    end
  end
end

