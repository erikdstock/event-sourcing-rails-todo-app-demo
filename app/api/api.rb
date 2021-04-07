class API < Grape::API
  prefix 'api'
  format :json

  mount EventsController
  mount ListsController
  mount CommandsController
end
