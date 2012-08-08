window.GeverFlow =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new GeverFlow.Routers.Tasks()
    Backbone.history.start(pushState: true)

$(document).ready ->
  GeverFlow.init()
