require_relative 'redux'

module Store

  def self.configure_store
    show_completed = -> (state, action) {
      state ||= false
      case action[:type]
      when :toggle_show_completed
        # TODO
      else
        state
      end
    }
    todos = -> (state, action) {
      state ||= {last_id: 0, entities: []}
      case action[:type]
      when :change_task
        # TODO
      when :add_task
        # TODO
      when :delete_task
        # TODO
      when :complete_task
        # TODO
      end
      state
    }
    reducers = Redux::combine_reducers([[:todos, todos], [:show_completed, show_completed]])
    Redux::Store.new({}, &reducers)
  end

end
