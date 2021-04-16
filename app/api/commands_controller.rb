class CommandsController < Grape::API
  namespace :commands do
    desc 'create a new todo list'
    params do
      requires :name, type: String
      optional :metadata, type: Hash, desc: 'metadata associated with the event', default: {}
    end
    post :create_list do
      command = Commands::TodoList::Create.new(name: params[:name], metadata: params[:metadata])
      if command.valid?
        command.call
      else
        error!({ errors: command.errors.full_messages }, 400)
      end
    end
  end
end
