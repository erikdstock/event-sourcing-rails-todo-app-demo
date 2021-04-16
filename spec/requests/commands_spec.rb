require 'rails_helper'

RSpec.describe 'Commands', type: :request do
  describe 'POST /create_list' do
    it 'creates a new list' do
      expect(TodoList.all.count).to equal 0

      expect { post '/api/commands/list/create_list', params: { name: 'Test List' } }
        .to change { TodoList.all.count }.by 1

      expect(TodoList.last.name).to eq 'Test List'
    end

    it 'does not create a list that already exists' do
      post '/api/commands/list/create_list', params: { name: 'Test List' }

      expect { post '/api/commands/list/create_list', params: { name: 'Test List' } }
        .to change { TodoList.all.count }.by 0

      expect(JSON.parse(response.body)['errors']).to eq ['List name must be unique']
    end
  end

  describe 'POST /create_item' do
    let! (:todo_list) { TodoList.create(name: "The list") }

    it 'creates a new item' do
      expect(TodoItem.all.count).to equal 0

      expect { post '/api/commands/item/create_item', params: { name: 'Test Item', todo_list_id: todo_list.id } }
        .to change { TodoItem.all.count }.by 1

      expect(TodoItem.last.name).to eq 'Test Item'
    end

    it 'requires that name is not empty' do
      expect { post '/api/commands/item/create_item', params: { name: '', todo_list_id: todo_list.id } }
        .to change { TodoItem.all.count }.by 0

      expect(JSON.parse(response.body)['errors']).to eq ["Name can't be blank"]
    end
  end
end
