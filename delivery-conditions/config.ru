require 'rack'
require 'json'

run do |_env|
  q = _env['QUERY_STRING']
  # puts _env.inspect

  parsed_params = q.split('&')
                   .each_with_object({}) do |s, obj|
    head, tail = s.split('=')
    obj[head] ||= []
    obj[head] << tail
  end
  puts parsed_params.inspect
  store_ids = if !parsed_params['store_ids[]'].nil?
                parsed_params['store_ids[]']
              elsif !parsed_params['store_ids'].nil?
                CGI.unescape(parsed_params['store_ids'].first.to_s).split(',')
              end

  stores = []
  store_ids.each_with_index do |store_id, index|
    stores << if _env['REQUEST_PATH'] == '/deliveries'
                { id: store_id, delivery_field: "Delivery enrich data for store #{index}" }
              else
                { id: store_id, enrich_field: "Some enrich data for store #{index}" }
              end
  end
  # sleep(0.1)

  [200, { 'content-type' => 'application/json' }, [{ stores: stores }.to_json]]
end
