require_relative 'redux'

module Store

  def self.configure_store
    show_completed = -> (state, action) {
      state ||= false
      case action[:type]
      when :toggle_show_completed
        state = !state
      else
        state
      end
    }
    todos = -> (state, action) {
      state ||= {last_id: 0, entities: []}
      case action[:type]
      when :change_task
        id = action[:payload][:id]
        state[:entities] = state[:entities].map do |entity|
          if entity[:id] == id
            entity[:content] = action[:payload][:content]
          end
          entity
        end
      when :add_task
        state[:entities] << {completed: false, content: "", id: state[:last_id]}
        state[:last_id] += 1
      when :delete_task
        state[:entities] = state[:entities].select do |entity|
          entity[:id] != action[:payload][:id]
        end
      when :complete_task
        state[:entities] = state[:entities].map do |entity|
          if entity[:id] == action[:payload][:id]
            entity[:completed] = true
            entity
          else
            entity
          end
        end
      end
      state
    }
    reducers = Redux::combine_reducers([[:todos, todos], [:show_completed, show_completed]])
    Redux::Store.new({}, &reducers)
  end

end
