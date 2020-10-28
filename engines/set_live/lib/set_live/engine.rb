module SetLive
  class Engine < ::Rails::Engine
    isolate_namespace SetLive

    initializer "static assets" do |app|
      app.middleware.insert_before(::ActionDispatch::Static, ::ActionDispatch::Static, "#{root}/public")
    end

    initializer "webpacker.proxy" do |app|
      insert_middleware = begin
        SetLive.webpacker.config.dev_server.present?
                        rescue
                          nil
                        end
      next unless insert_middleware

      app.middleware.insert_before(
        0, Webpacker::DevServerProxy, # "Webpacker::DevServerProxy" if Rails version < 5
        ssl_verify_none: true,
        webpacker: SetLive.webpacker
      )
    end
  end
end
