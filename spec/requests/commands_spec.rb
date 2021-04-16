require 'rails_helper'

RSpec.describe 'Commands', type: :request do
  describe 'POST /create_list' do
    it 'creates a new list' do
      expect(TodoList.all.count).to equal 0

      expect { post '/api/commands/create_list', params: { name: 'Test List' } }
        .to change { TodoList.all.count }.by 1

      expect(TodoList.last.name).to eq 'Test List'
    end

    it 'does not create a list that already exists' do
      post '/api/commands/create_list', params: { name: 'Test List' }

      expect { post '/api/commands/create_list', params: { name: 'Test List' } }
        .to change { TodoList.all.count }.by 0

      expect(JSON.parse(response.body)['errors']).to eq ['List name must be unique']
    end
  end

  describe 'PUT /update_list' do
    let!(:list) { TodoList.create!(name: 'Cat Food') }
    it 'updates a list' do
      expect(list.name).to eq 'Cat Food'
      put "/api/commands/update_list/#{list.id}", params: { name: 'Cat Toys' }
      expect(list.reload.name).to eq 'Cat Toys'
    end

    it 'returns a 404 on a todo list that is not found' do
      put "/api/commands/update_list/blah", params: { name: 'Cat Toys' }
      expect(response.status).to eq 404
    end
  end
end
