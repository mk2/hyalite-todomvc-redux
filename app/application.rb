require 'hyalite'
require 'browser/interval'

class TodoView
  include Hyalite::Component

  def initial_state
    @last_id = 0
    @todos = [{id: @last_id, completed: false, content: "何かの予定"}]
    {todos: @todos}
  end

  def on_change_task(e)
    p e.target.value
  end

  def on_click_add_task_button(e)
    puts "on_click_add_task_button"
    @last_id += 1
    @todos << {completed: false, content: " ", id: @last_id}
    set_state(todos: @todos)
  end

  def component_did_mount
  end

  def render
    todo_elements = @state[:todos].map do |todo|
      Hyalite.create_element("tr", nil,
        Hyalite.create_element("td", nil,
          Hyalite.create_element("div", {className: "input-group"},
            Hyalite.create_element("button", {className: "btn btn-primary input-group-btn"}, "-"),
            Hyalite.create_element("input", {className: "form-input", placeholder: "タスク", value: todo[:content], onChange: -> (event) { on_change_task(event) } }),
            Hyalite.create_element("button", {className: "btn btn-primary input-group-btn"}, "Fin")
            )
          )
        )
    end

    p todo_elements

    add_task_button =
      Hyalite.create_element("tr", nil,
        Hyalite.create_element("td", {colspan: 3},
          Hyalite.create_element("button", {className: "btn btn-block", onClick: -> (event) { on_click_add_task_button(event) } }, "+")
          )
        )

    Hyalite.create_element("div", {className: 'container'},
      Hyalite.create_element("div", {className: 'columns'},
        Hyalite.create_element("div", {className: 'column col-3'}),
        Hyalite.create_element("div", {className: 'column col-6'},
          Hyalite.create_element("table", {className: "table table-striped table-hover"},
            add_task_button,
            todo_elements
            )
          ),
        Hyalite.create_element("div", {className: 'column col-3'})
        )
      )
  end
end

$document.ready do
  Hyalite.render(Hyalite.create_element(TodoView, nil), $document['#container'])
end
