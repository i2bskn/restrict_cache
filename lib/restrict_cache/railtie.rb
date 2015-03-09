module RestrictCache
  class Railtie < ::Rails::Railtie
    initializer "restrict_cache" do
      require "restrict_cache/active_record_ext"

      ActiveSupport.on_load(:active_record) do
         ::ActiveRecord::Base.send(:include, RestrictCache::ActiveRecordExt)
      end
    end
  end
end

