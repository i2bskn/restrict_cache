module RestrictCache
  class ActionControllerExt
    include ActiveSupport::Concern

    module ClassMethods
      def cache_sweep_action(*args)
        options = args.extract_options!
        actions = args.empty? ? {} : {only: args}
        options.merge! actions unless actions.empty?
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

