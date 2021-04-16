class API < Grape::API
  prefix 'api'
  format :json

  rescue_from ActiveRecord::RecordNotFound do |error|
    Rails.logger.warn "#{error.class.name}: #{error.message}"
    rack_response({ error: 'Not Found' }.to_json, 404)
  end

  mount EventsController
  mount ListsController
  mount CommandsController
end
