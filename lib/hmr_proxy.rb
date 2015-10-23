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
    if env["PATH_INFO"].start_with?('/assets/bundle/')
      if env["PATH_INFO"].end_with?('.js')&&!env["PATH_INFO"].end_with?('.hot-update.js')
        path=env["PATH_INFO"].sub('/assets/bundle/','')
        env["PATH_INFO"]='/assets/bundle/'+path.split('.')[0]+'.js'
      end
      env["HTTP_HOST"] = "localhost:5000"
    end
    env
  end

end
