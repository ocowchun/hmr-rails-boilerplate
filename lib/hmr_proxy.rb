require 'rack-proxy'
class HmrProxy < Rack::Proxy
  def initialize(app)
    @streaming = false
    @ssl_verify_none =  false
    @read_timeout =  1
    @app = app
  end

  def call(env)
    original_host = env["HTTP_HOST"]
    rewrite_env(env)
    if env["HTTP_HOST"] != original_host
      perform_request(env)
    else
      # just regular
      @app.call(env)
    end
  end

  def rewrite_env(env)
    if env["PATH_INFO"].start_with?('/static/')
      env["HTTP_HOST"] = "localhost:5000"
    end
    env
  end

end
