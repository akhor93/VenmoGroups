VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.NewView extends Backbone.View
  template: JST['backbone/templates/groups/new']

  initialize: ->
    Backbone.Validation.bind(this);

  events:
    'submit #new-group': 'save'
    'change #group-name': 'updateGroupName'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()
    if @model.isValid true
      @model.save(null, {
        success: (group) ->
          that.collection.add group
          window.location.hash = "#/groups/"
      });

  updateGroupName: (e) ->
    @model.set('name', $(e.currentTarget).val())

  render: (options) ->
    @$el.html(@template())
    @$("form").backboneLink(@model)
    return this