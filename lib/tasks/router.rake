namespace :router do
  task :router_environment do
    Bundler.require :router, :default

    require 'logger'
    @logger = Logger.new STDOUT
    @logger.level = Logger::DEBUG

    @router = Router::Client.new :logger => @logger
  end

  task :register_application => :router_environment do
    platform = ENV['FACTER_govuk_platform']
    url = "smartanswers.#{platform}.alphagov.co.uk/"
    @logger.info "Registering application..."
    @router.applications.update application_id: "smartanswers", backend_url: url
  end

  task :register_routes => [ :router_environment, :environment ] do
    SmartAnswer::FlowRegistry.new.flows.map do |flow|
      next unless flow.status == :published
      path = "/#{flow.name}"
      @logger.info "Registering #{path}"
      @router.routes.update application_id: "smartanswers", route_type: :prefix,
        incoming_path: path
      @router.routes.update application_id: "smartanswers", route_type: :prefix,
        incoming_path: "#{path}.json"
    end                                                                                                                   
    
    @router.routes.update application_id: "smartanswers", route_type: :full, incoming_path: "/calculate-your-holiday-entitlement"
    @router.routes.update application_id: "smartanswers", route_type: :full, incoming_path: "/calculate-your-holiday-entitlement.json"
  end

  desc "Register smartanswers application and routes with the router (run this task on server in cluster)"
  task :register => [ :register_application, :register_routes ]
end

