module RestrictCache
  class Railtie < ::Rails::Railtie
    initializer "restrict_cache" do
      require "restrict_cache/action_controller_ext"
      require "restrict_cache/active_record_ext"

      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send(:include, RestrictCache::ActionControllerExt)
      end

      ActiveSupport.on_load(:active_record) do
         ::ActiveRecord::Base.send(:include, RestrictCache::ActiveRecordExt::Base)
         ::ActiveRecord::Relation.send(:include, RestrictCache::ActiveRecordExt::Relation)
      end
    end
  end
end

