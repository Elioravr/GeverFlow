class GeverFlow.Views.TasksBoard extends Backbone.View
  el: '#tasks-board'
  
  initialize: (params)->
    @el = $(@el)
    @collection = params.collection
    @taskView = params.taskView
    @timerView = params.timerView
    @indexedTask = null
    @currentColumn = null
    @_initFilterTitles()
    @_initKeyboardShortcuts()
    @collection.on('reset', @render, this)
    @collection.on('add', @newTask, this)
    @collection.on('add', @_updateAllContainersTitles, this)
    @collection.on('change', @_updateAllContainersTitles, this)
    @collection.on('remove', @_updateAllContainersTitles, this)
  
  events:
    'click .add-button': 'add'
    'click .edit-task-button': 'edit'
    'drop .column': 'taskDropped'
  
  render: ->
    @collection.each (task) =>
      @newTask(task)
    @_updateAllContainersTitles()

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
    @todayContainerClass = '.today-container'
    @yesterdayContainerClass = '.yesterday-container'
    @lastWeekContainerClass = '.last_week-container'
    @lastMonthContainerClass = '.last_month-container'
    @beforeContainerClass = '.before-container'

  _initKeyboardShortcuts: ->
    $(window).keydown (event) =>
      code = event.keyCode
      if event.shiftKey and @_checkCodeWithoutInput(code, 191)
        modal = $('#keyboard-shortcuts')
        @_showOrHideModal(modal)
      else if @_checkCodeWithoutInput(code, 78)
        button = $('.main-table-header').first().find('.add-button')
        button.trigger('click')
      else if @_checkCodeWithoutInput(code, 77)
        $('.only-my-task-button').trigger('click')
      else if @_checkCodeWithoutInput(code, 65)
        $('.all-tasks-button').trigger('click')
      else if @_checkCodeWithoutInput(code, 37) or
              @_checkCodeWithoutInput(code, 38) or
              @_checkCodeWithoutInput(code, 39) or
              @_checkCodeWithoutInput(code, 40) or
              @_checkCodeWithoutInput(code, 72) or
              @_checkCodeWithoutInput(code, 74) or
              @_checkCodeWithoutInput(code, 75) or
              @_checkCodeWithoutInput(code, 76)
        event.preventDefault()
        @_manageArrows(code)
      else if @_checkCodeWithoutInput(code, 27)
        @_quitChosenTask()
      else if code is 27 #fix bug of focusing on hidden input
        $('#task_title').blur()
      else if @_checkCodeWithoutInput(code, 69) and @indexedTask isnt null
        edit = $(@indexedTask).find('.edit-task-button')
        edit.trigger('click')
      else if @_checkCodeWithoutInput(code, 46) and @indexedTask isnt null
        remove = $(@indexedTask).find('.remove-task-button')
        remove.trigger('click')
      else if @_checkCodeWithoutInput(code, 83) and @indexedTask isnt null
        stop = $('.stop-timer-button').trigger('click')
        stop.trigger('click')
      else if @_checkCodeWithoutInput(code, 13) and @indexedTask isnt null
        start = $(@indexedTask).find('.work-on-task-button')
        start.trigger('click')
      else if @_checkCodeWithoutInput(code, 79) and @indexedTask isnt null
        description = $(@indexedTask).find('.task-subtasks-list')
        if description.is(':visible')
          button = $(@indexedTask).find('.hide-discription-button')
        else
          button = $(@indexedTask).find('.show-discription-button')
        button.trigger('click')

        
  _checkCodeWithoutInput: (actualCode, require) ->
    return actualCode is require and (@_checkIfInput(event.target) is false)

  _showOrHideModal: (modal) ->
    if modal.is(':hidden')
      modal.modal('show')
    else
      modal.modal('hide')

  _checkIfInput: (target) ->
    return ($(target).is('input') or $(target).is('textarea'))

  newTask: (task) =>
    newTask = new GeverFlow.Views.Task(task: task, timerView: @timerView)
    newTask.render()
    container = @getColumnContainer(task.attributes.column_id)
    
    if container.data('group-by-date') == false
      $(newTask.el).hide().appendTo(container).fadeIn(1000)
    else
      @_appendTaskToTheRightContainer(newTask, container)

    @registerToEvents(newTask.el)

  _manageArrows: (code) ->
    if @currentColumn is null
      @_initColumn()
      @_initIndexedTask() if @indexedTask is null
    else
      if code is 75 or code is 38 # Up
        @_moveToLastTask()
        @_markIndexedTask()
      else if code is 74 or code is 40 # Down
        @_moveToNextTask()
        @_markIndexedTask()
      else if code is 76 or code is 39 # Right
        @_moveToNextColumn()
        @_initIndexedTask()
      else if code is 72 or code is 37 # Left
        @_moveToLastColumn()
        @_initIndexedTask()

  _initIndexedTask: ->
    @currentTaskIndex = 0
    @indexedTask = $(@currentColumn).find('.task-container:visible')[@currentTaskIndex]
    @_markIndexedTask()

  _markIndexedTask: ->
    $('.task-container').removeClass('indexed-task')
    $(@indexedTask).addClass('indexed-task')
  
  _initColumn: ->
    @currentColumnIndex = 0
    @currentColumn = $('.column')[@currentColumnIndex]

  _moveToNextColumn: ->
    columns = $('.column')
    if ++@currentColumnIndex >= columns.length
      @currentColumnIndex = 0

    @currentColumn = $(columns[@currentColumnIndex])

    if $(@currentColumn).children('.task-container:visible').length is 0 and
       @currentColumn.data('group-by-date') is false
      @_moveToNextColumn()
    else if @currentColumn.data('group-by-date') is true
      if @_manageGroupByDateColumn() is null
        @_moveToNextColumn()
  
  _moveToNextTask: ->
    tasks = $(@currentColumn).find('.task-container')
    if ++@currentTaskIndex >= tasks.length
      @currentTaskIndex = 0

    @indexedTask = tasks[@currentTaskIndex]
    if $(@indexedTask).is(':hidden')
      @_moveToNextTask()
  
  _moveToLastColumn: ->
    columns = $('.column')
    if --@currentColumnIndex < 0
      @currentColumnIndex = columns.length - 1

    @currentColumn = $(columns[@currentColumnIndex])
    
    if @currentColumn.children('.task-container:visible').length is 0 and
       @currentColumn.data('group-by-date') is false
      @_moveToLastColumn()
    else if @currentColumn.data('group-by-date') is true
      if @_manageGroupByDateColumn() is null
        @_moveToLastColumn()
  
  _moveToLastTask: ->
    tasks = $(@currentColumn).find('.task-container')
    if --@currentTaskIndex < 0
      @currentTaskIndex = tasks.length - 1

    @indexedTask = tasks[@currentTaskIndex]
    if $(@indexedTask).is(':hidden')
      @_moveToLastTask()
  
  _quitChosenTask: ->
    @currentColumn = @indexedTask = @currentTaskIndex = @currentColumnIndex = null
    $('.indexed-task').removeClass('indexed-task')

  _manageGroupByDateColumn: ->
    todayContent = $("#{@todayContainerClass} .task-filter-content")
    yesterdayContent = $("#{@yesterdayContainerClass} .task-filter-content")
    lastWeekContent = $("#{@lastWeekContainerClass} .task-filter-content")
    lastMonthContent = $("#{@lastMonthContainerClass} .task-filter-content")
    beforeContent = $("#{@beforeContainerClass} .task-filter-content")
    
    if todayContent.children().length > 0
      todayContent.show()
    else if yesterdayContent.children().length > 0
      yesterdayContent.show()
    else if lastWeekContent.children().length > 0
      lastWeekContent.show()
    else if lastMonthContent.children().length > 0
      lastMonthContent.show()
    else if beforeContent.children().length > 0
      beforeContent.show()
    else
      return null

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
      @_appendToTimeContainer(newTask.el, @todayContainerClass)
    else if updatedAt.toString() is yesterday.toString()
      @_appendToTimeContainer(newTask.el, @yesterdayContainerClass)
    else if yesterday > updatedAt >= lastWeek
      @_appendToTimeContainer(newTask.el, @lastWeekContainerClass)
    else if lastWeek > updatedAt >= lastMonth
      @_appendToTimeContainer(newTask.el, @lastMonthContainerClass)
    else
      @_appendToTimeContainer(newTask.el, @beforeContainerClass)

  _appendToTimeContainer: (element, containerClass) ->
    taskContainer = $("#{containerClass} .task-filter-content")
    $(element).hide().appendTo(taskContainer).fadeIn(1000)
    tasksInContainer = taskContainer.children().length

  _updateAllContainersTitles: ->
    todayContainer = $("#{@todayContainerClass} .task-filter-content")
    tasksInToday = todayContainer.children().length
    @_updateContainerTitle(todayContainer, 'Today', tasksInToday)
    yesterdayContainer = $("#{@yesterdayContainerClass} .task-filter-content")
    tasksInYesterday = yesterdayContainer.children().length
    @_updateContainerTitle(yesterdayContainer, 'Yesterday', tasksInYesterday)
    lastWeekContainer = $("#{@lastWeekContainerClass} .task-filter-content")
    tasksInLastWeek = lastWeekContainer.children().length
    @_updateContainerTitle(lastWeekContainer, 'Last Week', tasksInLastWeek)
    lastMonthContainer = $("#{@lastMonthContainerClass} .task-filter-content")
    tasksInLastMonth = lastMonthContainer.children().length
    @_updateContainerTitle(lastMonthContainer, 'Last Month', tasksInLastMonth)
    beforeContainer = $("#{@beforeContainerClass} .task-filter-content")
    tasksInBefore = beforeContainer.children().length
    @_updateContainerTitle(beforeContainer, 'Before', tasksInBefore)

  _updateContainerTitle: (taskContainer, time, tasksInContainer) ->
    taskContainer.siblings('.task-filter-title').html("#{time} (#{tasksInContainer})")
  
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
    id = $(event.currentTarget).data('task_id')
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
    $(@el).fadeIn(500)

  _showButtonsForStop: ->
    $(@el).fadeOut(500)
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
    if confirm("Are you sure you want to delete: #{@model.get('title')}?")
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
