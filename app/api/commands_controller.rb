class CommandsController < Grape::API
  namespace :commands do
    namespace :list do
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

    namespace :item do
      desc 'create a new todo item'
      params do
        requires :name, type: String
        requires :todo_list_id, type: Integer
        optional :metadata, type: Hash, desc: 'metadata associated with the event', default: {}
      end
      post :create_item do
        todo_list = TodoList.find(params[:todo_list_id])
        command = Commands::TodoItem::Create.new(name: params[:name], todo_list: todo_list, metadata: params[:metadata])
        if command.valid?
          command.call
        else
          error!({ errors: command.errors.full_messages }, 400)
        end
      end
    end
  end
end
