module RestrictCache
  class ActionControllerExt
    include ActiveSupport::Concern

    module ClassMethods
      def cache_sweep_action(*args)
        options = args.empty? {} : {only: args}
        around_action :sweep_restrict_cache, options
      end
    end

    def sweep_restrict_cache
      yield
    ensure
      RestrictCache.clear
    end
  end
end

