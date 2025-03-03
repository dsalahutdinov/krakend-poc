require 'json'
require 'sinatra'
require 'opentelemetry/sdk'
require 'opentelemetry/exporter/otlp'
require 'opentelemetry/instrumentation/sinatra'

ENV['OTEL_EXPORTER_OTLP_ENDPOINT'] = 'http://jaeger:4318'

OpenTelemetry::SDK.configure do |c|
  c.service_name = 'stores'
  c.use_all
end

class App < Sinatra::Base
  # disable it only for development
  configure :development do
    set :host_authorization, { permitted_hosts: [] }
  end

  # but enable it for production for some domains
  configure :production do
    set :host_authorization, { permitted_hosts: ['.example.com'] }
  end

  hash = {
    stores: [
      { id: '123', name: 'First' },
      { id: '234', name: 'Second' }
    ]
  }

  get '/search' do
    tracer = OpenTelemetry.tracer_provider.tracer('search stores')
    tracer.in_span('search') do |span|
      span.set_attribute('some-attr', 'some-value')
    end
    return hash.to_json
  end
end
