class GeverFlow.Routers.Tasks extends Backbone.Router
  routes:
    'boards/:id': 'board'

  board: (id) ->
    @collection = new GeverFlow.Collections.Tasks()
    @collection.reset($('#tasks-board').data('tasks'))
    window.col = @collection
    taskView = new GeverFlow.Views.TaskEditor(collection: @collection)
    #taskView.render()
    timer = new GeverFlow.Views.TimerView(collection: @collection)
    timer.render()
    tasksBoardView = new GeverFlow.Views.TasksBoard(collection: @collection, taskView: taskView, timerView: timer)
    tasksBoardView.render()
