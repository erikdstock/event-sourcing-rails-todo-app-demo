class EventsController < Grape::API
  desc 'create an event directly '
  params do
    requires :type, type: String, desc: 'A deserializeable event class (Minus `Events::`)'
    requires :body, type: Hash, desc: 'keyword args for the event constructor'
  end

  post :events do
    event_type = params[:type]
    error!({ message: 'event.type must inherit from Lib::BaseEvent' }, 401) unless event_type
    klass = "Events::#{event_type}".classify&.constantize
    unless klass&.ancestors&.include? Lib::BaseEvent
      error!({ message: 'event.type must inherit from Lib::BaseEvent' }, 401)
    end
    event = klass.new(params[:body])
    if event.save
      event.reload.aggregate
    else
      error!({ message: event.errors.full_messages }, 401)
    end
  end
end
