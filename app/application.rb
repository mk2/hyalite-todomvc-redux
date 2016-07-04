require 'hyalite'
require 'browser/interval'

require_relative 'store'

class TodoView
  include Hyalite::Component

  def initial_state
    # For redux
    @props[:store].subscribe do
      set_state({todos: @props[:store].state[:todos][:entities], show_completed: @props[:store].state[:show_completed]})
    end

    {todos: @props[:store].state[:todos][:entities], show_completed: @props[:store].state[:show_completed]}
  end

  def method_missing(meth, *args, &blk)
    event = args[0]
    id = args[1] || -1
    dispatch(meth, {content: event.target.value, id: id})
  end

  def dispatch(type, payload)
    @props[:store].dispatch({type: type, payload: payload})
    p type
    p payload
  end

  def render
    # p @state

    todo_elements = @state[:todos].map do |todo|
      !@state[:show_completed] && todo[:completed] ? nil :
        Hyalite.create_element("tr", {key: "tr-#{todo[:id]}"},
          Hyalite.create_element("td", nil,
            Hyalite.create_element("div", {className: "input-group"},
              Hyalite.create_element("button", {className: "btn btn-primary input-group-btn", onClick: -> (event) { delete_task(event, todo[:id]) }}, "-"),
              todo[:completed] ?
                Hyalite.create_element("input", {className: "form-input", placeholder: "タスク", value: todo[:content], readOnly: "true", disabled: "true"}) :
                Hyalite.create_element("input", {className: "form-input", placeholder: "タスク", value: todo[:content], onChange: -> (event) {change_task(event, todo[:id])} }),
              Hyalite.create_element("button", {className: "btn btn-primary input-group-btn", onClick: -> (event) { complete_task(event, todo[:id]) }}, "Fin")
              )
            )
          )
    end

    completed_tasks_switch =
      Hyalite.create_element("div", {className: "form-group"},
        Hyalite.create_element("label", {className: "form-switch"},
          @state[:show_completed] ?
            Hyalite.create_element("input", {type: "checkbox", checked: true, onChange: -> (event) {toggle_show_completed(event)} }) :
            Hyalite.create_element("input", {type: "checkbox", onChange: -> (event) {toggle_show_completed(event)} }),
          Hyalite.create_element("i", {className: "form-icon" }),
          "完了済みも表示する"
          )
        )

    add_task_button =
      Hyalite.create_element("button", {className: "btn btn-block", onClick: -> (event) { add_task(event) } }, "+")

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
