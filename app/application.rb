require 'hyalite'
require 'browser/interval'

require_relative 'store'

class TodoView
  include Hyalite::Component

  def initial_state
    @props[:store].subscribe do
      state = @props[:store].state
      p state
      set_state({todos: state[:todos][:entities], show_completed: state[:show_completed]})
    end
    {todos: @props[:store].state[:todos][:entities], show_completed: @props[:store].state[:show_completed]}
  end

  def dispatch(type, payload)
    @props[:store].dispatch({type: type, payload: payload})
  end

  def on_change_task(e, id)
    p id
    dispatch(:change_task, {id: id, content: e.target.value})
  end

  def on_click_delete_task_button(e, id)
    dispatch(:delete_task, {id: id})
  end

  def on_click_add_task_button(e)
    dispatch(:add_task, nil)
  end

  def on_click_complete_task_button(e, id)
    dispatch(:complete_task, {id: id})
  end

  def on_toggle_show_completed_switch(e)
    dispatch(:toggle_show_completed, nil)
  end

  def component_did_mount
  end

  def render
    # p @state

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
