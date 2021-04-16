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
end
