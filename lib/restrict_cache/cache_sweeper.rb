module RestrictCache
  class CacheSweeper
    def initialize(app)
      @app = app
    end

    def call(env)
      @app.call(env)
    ensure
      RestrictCache.clear
    end
  end
end

