class ListsController < Grape::API
  #   This route isn't intended as a permanent (or well-written) piece of API
  namespace 'lists' do
    desc 'get a list'
    params do
      requires :id, type: Integer, desc: 'Status ID.'
    end
    get ':id' do
      list = TodoList.find(params[:id])
      error(404) unless list
      list.as_json(include: :todo_items)
    end
  end
end
