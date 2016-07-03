require 'hyalite'
require 'browser/interval'

class TodoView
  include Hyalite::Component

  def initial_state
    @last_id = 0
    @todos = [{id: @last_id, completed: false, content: "何かの予定"}]

    # For redux
    @props[:store].subscribe do
      # TODO
    end

    {todos: @todos, show_completed: false}
  end

  def dispatch(type, payload)
    # TODO
  end

  def on_change_task(e, id)
    @todos = @todos.map do |todo|
      if todo[:id] == id
        todo[:content] = e.target.value
      end
      todo
    end
    set_state(todos: @todos)
  end

  def on_click_delete_task_button(e, id)
    @todos = @todos.select do |todo|
      todo[:id] != id
    end
    set_state(todos: @todos)
  end

  def on_click_add_task_button(e)
    puts "on_click_add_task_button"
    @last_id += 1
    @todos << {completed: false, content: " ", id: @last_id}
    set_state(todos: @todos)
  end

  def on_click_complete_task_button(e, id)
    @todos = @todos.map do |todo|
      if todo[:id] == id
        todo[:completed] = true
      end
      todo
    end
    set_state(todos: @todos)
  end

  def on_toggle_show_completed_switch(e)
    puts "on_toggle_show_completed_switch"
    set_state(show_completed: !@state[:show_completed])
  end

  def component_did_mount
  end

  def render
    p @state

    todo_elements = @state[:todos].map do |todo|
      !@state[:show_completed] && todo[:completed] ? nil :
        Hyalite.create_element("tr", {key: "tr-#{todo[:id]}"},
          Hyalite.create_element("td", nil,
            Hyalite.create_element("div", {className: "input-group"},
              Hyalite.create_element("button", {className: "btn btn-primary input-group-btn", onClick: -> (event) { on_click_delete_task_button(event, todo[:id]) }}, "-"),
              todo[:completed] ?
                Hyalite.create_element("input", {className: "form-input", placeholder: "タスク", value: todo[:content], readOnly: "true", disabled: "true"}) :
                Hyalite.create_element("input", {className: "form-input", placeholder: "タスク", value: todo[:content], onChange: -> (event) {on_change_task(event, todo[:id])} }),
              Hyalite.create_element("button", {className: "btn btn-primary input-group-btn", onClick: -> (event) { on_click_complete_task_button(event, todo[:id]) }}, "Fin")
              )
            )
          )
    end

    completed_tasks_switch =
      Hyalite.create_element("div", {className: "form-group"},
        Hyalite.create_element("label", {className: "form-switch"},
          @state[:show_completed] ?
            Hyalite.create_element("input", {type: "checkbox", checked: true, onChange: -> (event) {on_toggle_show_completed_switch(event)} }) :
            Hyalite.create_element("input", {type: "checkbox", onChange: -> (event) {on_toggle_show_completed_switch(event)} }),
          Hyalite.create_element("i", {className: "form-icon" }),
          "完了済みも表示する"
          )
        )

    add_task_button =
      Hyalite.create_element("button", {className: "btn btn-block", onClick: -> (event) { on_click_add_task_button(event) } }, "+")

    Hyalite.create_element("div", {className: 'container'},
      Hyalite.create_element("div", {className: 'columns'},
        Hyalite.create_element("div", {className: 'column col-3'}),
        Hyalite.create_element("div", {className: 'column col-6'},
          completed_tasks_switch,
          add_task_button,
          Hyalite.create_element("table", {className: "table table-striped table-hover"},
            todo_elements
            )
          ),

        Hyalite.create_element("div", {className: 'column col-3'})
        )
      )
  end
end

$document.ready do
  Hyalite.render(Hyalite.create_element(TodoView, {store: Store::configure_store}), $document['#container'])
end
