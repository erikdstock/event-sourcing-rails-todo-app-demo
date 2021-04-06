class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  ## For exploration purposes only - a simple external api for creating events

  ## POST an event with event_type and body, return the aggregate
  # EX: POST /events {
  #   "event": {
  #     "type": "TodoList::Created",
  #     "body": {"name": "Eriks todos"}
  #   }
  # }
  def create
    event_type = event_params[:type]
    throw ArgumentError.new('missing event.type') unless event_type
    klass = ('Events::' + event_type).classify&.constantize
    unless klass&.ancestors&.include? Lib::BaseEvent
      throw ArgumentError.new('event.type must inherit from Lib::BaseEvent')
    end
    event = klass.new(event_params[:body])
    event.save!
    render json: event.reload.aggregate
  end

  def event_params
    params.require(:event).permit(:type, body: {})
  end
  private :event_params
end
