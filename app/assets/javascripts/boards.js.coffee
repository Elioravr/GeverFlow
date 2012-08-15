# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->
  $('.add-button').click ->
    columnId = $(this).data('columnId')
    $('#task_column_id').val(columnId).trigger('liszt:updated')
  
  $('#trash-can').droppable
    hoverClass: 'trash-can-hover'
    #over: ->
      #$(this).addClass('trash-can-hover', 300)
    #out: ->
      #$(this).removeClass('trash-can-hover', 300)
    accept: (draggedElement) ->
      draggedElement = $(draggedElement)
      return draggedElement.hasClass('task-container')

  $('.column').droppable
    tolerance: 'pointer'
    hoverClass: 'column-in'
    accept: (draggedElement) ->
      draggedElement = $(draggedElement)
      if draggedElement.hasClass('task-container')
        draggedFromColumn = parseInt(draggedElement.attr('column_id'), 10)
        return draggedFromColumn isnt $(this).data('id')
      false
    #over: (event, draggedElement) ->
      #dragged = $(draggedElement).draggable
      #if dragged.hasClass('task-container')
        #taskColumnId = parseInt(dragged.attr('column_id'))
        #columnId = $(this).data('id')
        #if taskColumnId isnt columnId
          #$(this).addClass('column-in', 300)
    out: (event) ->
      $(this).removeClass('column-in', 300)
    drop: (event, droppedElement) ->
      dragged = $(droppedElement.draggable)
      if dragged.hasClass('task-container')
        $(this).removeClass('column-in', 300)
        task = $(droppedElement.draggable)
        column = $(this)
        task.css('top', 0).css('left', 0)
        if $(this).children('.today-container').length is 0
          $(this).append(droppedElement.draggable)
        else
          taskContainer = $(this).find('.today-container .task-filter-content')
          taskContainer.show()
          taskContainer.append(droppedElement.draggable)

  $('.only-my-task-button').click ->
    button = $(this)
    $('.task-container').each ->
      task = $(this)
      taskUserId = task.find('.username-field a').data('user_id')
      if taskUserId is button.data('current_user_id')
        task.show()
      else
        task.fadeOut(300)

  $('.all-tasks-button').click ->
    $('.task-container').show()
