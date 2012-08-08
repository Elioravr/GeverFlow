class GeverFlow.Views.TasksBoard extends Backbone.View
  el: '#tasks-board'
  
  initialize: (params)->
    @el = $(@el)
    @collection = params.collection
    @taskView = params.taskView
    @timerView = params.timerView
    @_initFilterTitles()
    @collection.on('reset', @render, this)
    @collection.on('add', @newTask, this)
  
  events:
    'click .add-button': 'add'
    'click .remove-task-button': 'remove'
    'click .edit-task-button': 'edit'
    'drop .column': 'taskDropped'
  
  render: ->
    @collection.each (task) =>
      @newTask(task)

  add: (event) ->
    task = new GeverFlow.Models.Task()
    task.set('column_id', @getColumnId(event.currentTarget))
    @taskView.setEditor(task)
  
  _initFilterTitles: ->
    $('.task-filter-title').click ->
      content = $(this).siblings('.task-filter-content')
      if content.is(':hidden')
        content.show()
      else
        content.hide()
    @todayContainer = '.today-container'
    @yesterdayContainer = '.yesterday-container'
    @lastWeekContainer = '.last_week-container'
    @yesterdayContainer = '.yesterday-container'
    @yesterdayContainer = '.yesterday-container'

  newTask: (task) =>
    newTask = new GeverFlow.Views.Task(task: task, timerView: @timerView)
    newTask.render()
    container = @getColumnContainer(task.attributes.column_id)
    
    if container.data('group-by-date') == false
      $(newTask.el).hide().appendTo(container).fadeIn(1000)
    else
      @_appendTaskToTheRightContainer(newTask, container)


    @registerToEvents(newTask.el)

  _appendTaskToTheRightContainer: (newTask, container) ->
    updatedAt = new Date(newTask.model.get('updated_at'))
    updatedAt.setHours(0,0,0,0)
    today = @_newDate()
    yesterday = @_newDate()
    yesterday.setDate(yesterday.getDate() - 1)
    lastWeek = @_newDate()
    lastWeek.setDate(lastWeek.getDate() - 7)
    lastMonth = @_newDate()
    lastMonth.setMonth(lastMonth.getMonth() - 1)
    if updatedAt >= today
      @_appendToTimeContainer(newTask.el, '.today-container')
    else if updatedAt.toString() is yesterday.toString()
      @_appendToTimeContainer(newTask.el, '.yesterday-container')
    else if yesterday > updatedAt >= lastWeek
      @_appendToTimeContainer(newTask.el, '.last_week-container')
    else if lastWeek > updatedAt >= lastMonth
      @_appendToTimeContainer(newTask.el, '.last_month-container')
    else
      @_appendToTimeContainer(newTask.el, '.before-container')
    @_updateAllContainersTitles()

  _appendToTimeContainer: (element, containerClass) ->
    taskContainer = $("#{containerClass} .task-filter-content")
    $(element).hide().appendTo(taskContainer).fadeIn(1000)
    tasksInContainer = taskContainer.children().length
    #@_updateContainerTitle(taskContainer, tasksInContainer)

  _updateContainerTitle: (taskContainer, tasksInContainer) ->
    title = taskContainer.siblings('.task-filter-title').html()
    taskContainer.siblings('.task-filter-title').html("#{title} (#{tasksInContainer})")
  
  _newDate: ->
    date = new Date()
    date.setHours(0,0,0,0)
    date
    
  registerToEvents: (el) ->
    $(el).draggable
      containment: "#tasks-board"
      scroll: false
      opacity: 0.6
      revert: (droppedElement) ->
        if droppedElement
          return !droppedElement.hasClass('column')
        return true

  edit: (event) ->
    id = $(event.target).parent('a').data('task_id')
    task = @collection.get(id)
    @taskView.setEditor(task)
    $('#new-task').modal('show')


  getColumnId: (button) ->
    $(button).data('column-id')

  getColumnContainer: (id) ->
    $(".column[data-id=#{id}]")
  
  remove: (event) ->
    taskId = $(event.currentTarget).data('task_id')
    @collection.remove taskId

  taskDropped: (event, draggedElement) ->
    column = $(event.currentTarget)
    task = $(draggedElement.draggable)
    model = @collection.get(task.attr('id'))
    model.set('column_id', column.data('id'))
    task.attr('column_id', column.data('id'))
    model.save()

class GeverFlow.Views.TimerView extends Backbone.View
  el: '#timer-layout'

  render: ->
    #@fillTasksSelect()

  initialize: (params) ->
    @el = $(@el)
    @collection = params.collection
    @el.draggable
      containment: "body"
      scroll: false
      opacity: 0.6
  
  events:
    'click .close-timer-button': '_showButtonsForStop'

  _initTimer: ->
    @timer = new Timer(25, 0)

    @timer.secondPast = =>
      $('.time-left').text("#{@timer.to_s()}")

    @timer.minutePast = =>
      timeSpent = @task.get('time_spent')
      timeSpent++
      @task.set('time_spent', timeSpent)
      @task.save()

    @timer.timesUp = =>
      alert("Time's Up")
      @_showButtonsForStop()
    
    $('.stop-timer-button').click =>
      @timer.stop()
      @_showButtonsForStop()
  
  changeTask: (id) ->
    @task = @collection.get(id)
    $(@el).find('#timer-task-name').text(@_getTaskShorterName())
    if $(@el).is(':hidden')
      @_startTimer()

  _showButtonsForPlay: ->
    $('#timer-task-name').text(@_getTaskShorterName()).show()
    $(@el).fadeIn()

  _showButtonsForStop: ->
    $(@el).fadeOut()
    @_clearChosenTasks()

  _startTimer: ->
    @_initTimer()
    @timer.start()
    @_showButtonsForPlay()
  
  _clearChosenTasks: ->
    $('.task-container').removeClass('chosen-task', 300)

  _getTaskShorterName: ->
    title = @task.get('title')
    if title.length > 22
      title = title.slice(0,19)
      if /^[ -/]$/.test(title[19])
        title = title.slice(0,18)
      title += "..."
    return title

class GeverFlow.Views.TaskEditor extends Backbone.View
  el: '#new-task'
  events:
    'click #save-task-button': 'save'
    'keyup #task_title': 'checkIfHebrew'
    'keyup #task_description': 'checkIfHebrew'

  render: ->
    $(@el).html(@template(task: @task))
    this

  setEditor: (task) ->
    @model = task
    $('#task_title').val(@model.get("title"))
    $('#task_description').val(@model.get("description")) 
    $('#task_time_spent').val(@model.get("time_spent"))
    $('#task_time_estimated').val(@model.get("time_estimated"))
    $('#task_column_id').val(@model.get('column_id')).trigger('liszt:updated')
    $('#task_user_id').val(@model.get("user_id")).trigger('liszt:updated')
    setTimeout('$("#task_title").focus()', 200)
    
  save: (event) ->
    @saveTask()
    @collection.create @model,
      wait: true
      error: (target, res) =>
        window.res = res
        errors = JSON.parse(res.responseText)
        errorString = ""
        for id, error of errors
          errorString += "#{id} #{error}</br>"

        $('#add-task-modal-error').html(errorString).show()
        @model.fetch()
      success: =>
        $('#new-task').modal('hide')
        @clearForm()

  saveTask: =>
    @model.set('title', $('#task_title').val())
    description = $('#task_description').val()
    @model.set('description', description)
    timeSpent = $('#task_time_spent').val()
    if isNaN(timeSpent)
      timeSpent = 0
    @model.set('time_spent', timeSpent)
    timeEstimated = $('#task_time_estimated').val()
    if isNaN(timeEstimated)
      timeEstimated = 0
    @model.set('time_estimated', timeEstimated)
    #@model.set('column_id', $('#new-task').data('column_id'))
    @model.set('column_id', $('#task_column_id').val())
    @model.set('user_id', $('#task_user_id').val())

  checkIfHebrew: (event)->
    input = $(event.currentTarget)
    if /^[א-ת]$/.test(input.val()[0])
      input.css('direction', 'rtl')
    else
      input.css('direction', 'ltr')

  clearForm: ->
    $('#task_title').val("")
    $('#task_description').val("")
    $('#task_time_spent').val("")
    $('#task_time_estimated').val("")
    $('#task_column_id').val("").trigger('liszt:updated')
    $('#task_user_id').val("").trigger('liszt:updated')
    $('#add-task-modal-error').html("").hide()

class GeverFlow.Views.Task extends Backbone.View
  template: JST['tasks/task']
  events:
    'click .remove-task-button': 'remove'
    'click .work-on-task-button': 'startWork'
    'click .show-discription-button': 'showDescription'
    'click .hide-discription-button': 'hideDescription'
    'click a[title="add-subtask"]': 'subtaskAdded'
    'keydown .new-subtask-content': 'subtaskAddedByEnter'

  initialize: (params) ->
    @model = params.task
    @timerView = params.timerView
    @model.on('remove', @afterRemove, this)
    @model.on('change', @render, this)
    $(@el).addClass('task-container')
    $(@el).attr('id', @model.get('id'))
    $(@el).attr('column_id', @model.get('column_id'))
    if /^[א-ת]$/.test(@model.get('title')[0])
      $(@el).addClass('task-container-heb')
  
  render: ->
    task = @model.attributes
    if task.user_id? is false
      task.user = null
    $(@el).html(@template(task: task))
    @subtasksCollection = @model.get('subtasks')
    @subtasksCollection.each (subtask) =>
      @_newSubtask(subtask)
    @_updateTaskColumn()
    @_initAddSubtaskInput()
    this

  _updateTaskColumn: ->
    column = $(".column[data-id=#{@model.get('column_id')}]")
    $(@el).attr('column_id', column.data('id'))
    if column.data('group-by-date') == false
      column.append(@el)
    else
      column.find('.today-container .task-filter-content').show().append(@el)

  remove: ->
    @model.destroy
      wait: true

  afterRemove: ->
    $(@el).remove()
  
  startWork: (event) ->
    @_markChosenTask()
    @timerView.changeTask(@model.id)

  _markChosenTask: ->
    $('.task-container').removeClass('chosen-task', 300)
    $("##{@model.get('id')}").addClass('chosen-task', 300)
  
  _newSubtask: (subtask) ->
    view = new GeverFlow.Views.Subtask(subtask: subtask)
    view.render()
    container = $(@el).children('.task-subtasks-list').children('.subtasks-list')
    $(view.el).appendTo(container)

  showDescription: (event) ->
    button = $(event.currentTarget)
    button.parent().siblings('.task-description').show()
    button.parent().siblings('.task-subtasks-list').show()
    button.siblings('.hide-discription-button').show()
    button.hide()
  
  hideDescription: (event) ->
    button = $(event.currentTarget)
    button.parent().siblings('.task-description').hide()
    button.parent().siblings('.task-subtasks-list').hide()
    button.siblings('.show-discription-button').show()
    button.hide()

  _initAddSubtaskInput: ->
    input = $(@el).find('.new-subtask-content')
    inputString = "Add Subtask"
    input.val(inputString)
    input.addClass 'subtask-input-before-writing'
    input.focusin ->
      input = $(this)
      if input.hasClass('subtask-input-before-writing')
        input.val('')
        input.removeClass 'subtask-input-before-writing'
        input.addClass 'subtask-input-after-writing'
    input.focusout ->
      input = $(this)
      if input.val().length is 0
        input.val(inputString)
        input.addClass 'subtask-input-before-writing'
        input.removeClass 'subtask-input-after-writing'
  
  subtaskAddedByEnter: (event) ->
    if event.keyCode is 13
      input = $(event.currentTarget)
      button = input.siblings('a[title="add-subtask"]')
      @_addSubtask(button, input)

  subtaskAdded: (event) ->
    button = $(event.currentTarget)
    input = button.siblings('.new-subtask-content')
    unless input.hasClass 'subtask-input-before-writing'
      @_addSubtask(button, input)
  
  _addSubtask: (button, input) ->
    subtaskContent = input.val()
    if subtaskContent.length isnt 0
      subtask = @_saveSubtask(subtaskContent)
      subtaskView = new GeverFlow.Views.Subtask(subtask: subtask)
      subtaskView.render()
      $(subtaskView.el).appendTo(button.siblings('.subtasks-list'))
      input.val('')

  _saveSubtask: (subtaskContent) ->
    subtasks = @model.get('subtasks')
    subtask = subtasks.create
      content: subtaskContent
      task_id: @model.get('id')
      is_done: false
    return subtask

class GeverFlow.Views.Subtask extends Backbone.View
  template: JST['tasks/subtask']
  tagName: 'li'

  events:
    'click .remove-subtask': 'remove'
    'click .subtask-content': 'changeSubtaskCheckbox'
    'change .check-subtask': 'checkSubtask'

  initialize: (params) ->
    @model = params.subtask
    @model.on('remove', @afterRemove, this)
    $(@el).addClass('subtask')
    $(@el).attr('id', "subtask-#{@model.get('id')}")
  
  render: ->
    subtask = @model.attributes
    $(@el).html(@template(subtask: subtask))
    @_markAsDone()
    this
  
  _markAsDone: ->
    if @model.get('is_done')
      $(@el).find('.check-subtask').attr('checked', true)
      $(@el).children('.subtask-content').addClass('done')

  remove: ->
    @model.destroy
      wait: true

  afterRemove: ->
    $(@el).remove()

  changeSubtaskCheckbox: (event) ->
    sibling = $(event.currentTarget)
    checkbox = sibling.siblings('.check-subtask')
    if checkbox.is(':checked')
      checkbox.removeAttr('checked')
    else
      checkbox.attr('checked', 'checked')
    checkbox.trigger('change')

  checkSubtask: (event) ->
    checkbox = $(event.currentTarget)
    
    if checkbox.is(':checked')
      @model.set('is_done', true)
      $(@el).children('.subtask-content').addClass('done')
    else
      @model.set('is_done', false)
      $(@el).children('.subtask-content').removeClass('done')
    
    @model.save()
