module Redux
  class Store
    attr_reader :state

    def initialize(initial_state = nil, &reducer)
      @state     = initial_state
      @reducer   = reducer || ->(*){}
      @listeners = []
      dispatch({})
    end

    def dispatch(action)
      @state = @reducer.call(@state, action)
      @listeners.each{ |listener| listener.call() }
    end

    def subscribe(&listener)
      @listeners << listener
      ->{ @listeners.delete(listener) }
    end
  end
end


module Redux
  def self.combine_reducers(reducers)
    ->(state = {}, action){
      reducers.reduce({}){ |next_state, (key, reducer)|
        next_state[key] = reducer.call(state[key], action)
        p next_state
      }
    }
  end
end
