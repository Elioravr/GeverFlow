class GeverFlow.Models.Subtask extends Backbone.RelationalModel

class GeverFlow.Collections.SubtaskCollection extends Backbone.Collection
  url: '/api/subtasks'

class GeverFlow.Models.Task extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany
    key: 'subtasks'
    relatedModel: 'GeverFlow.Models.Subtask'
    collectionType: 'GeverFlow.Collections.SubtaskCollection'
    reverseRelation:
      key: 'task_id'
      includeInJSON: 'id'
  }]

