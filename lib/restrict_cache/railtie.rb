module RestrictCache
  class Railtie < ::Rails::Railtie
    initializer "restrict_cache" do
      require "restrict_cache/rails_ext/all"

      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send(
          :include, RestrictCache::RailsExt::ActionController)
      end

      ActiveSupport.on_load(:active_record) do
         ::ActiveRecord::Base.send(
           :include, RestrictCache::RailsExt::ActiveRecord::Base)
         ::ActiveRecord::Relation.send(
           :include, RestrictCache::RailsExt::ActiveRecord::Relation)
      end
    end
  end
end

