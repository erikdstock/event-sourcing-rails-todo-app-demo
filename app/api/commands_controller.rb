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

    params do
      requires :id, type: String
      optional :name, type: String, desc: 'new name'
      optional :metadata, type: Hash, desc: 'metadata associated with the event', default: {}
    end
    put 'update_list/:id' do
      list = TodoList.find(params[:id])
      command = Commands::TodoList::UpdateName.new(todo_list: list, name: params[:name], metadata: params[:metadata])
      if command.valid?
        command.call
      else
        error!({ errors: command.errors.full_messages }, 400)
      end
    end
  end
end
