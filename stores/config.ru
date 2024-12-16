require 'rack'
require 'json'

run do |_env|
  hash = {
    stores: [
      { id: '123', name: 'First' },
      { id: '234', name: 'Second' }
    ]
  }
  # sleep(0.1)

  [200, { 'content-type' => 'application/json' }, [hash.to_json]]
end
