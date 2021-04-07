# frozen_string_literal: true

module Commands
  class TodoList::Create
    include Lib::Command
    validate :unique_list_name

    attributes :name, :metadata

    private def build_event
      Events::TodoList::Created.new(
        name: name,
        metadata: metadata
      )
    end

    def unique_list_name
      errors.add(:base, 'List name must be unique') unless ::TodoList.where(name: name).empty?
    end
  end
end
