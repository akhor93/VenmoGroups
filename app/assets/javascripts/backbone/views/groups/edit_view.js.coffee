VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.EditView extends Backbone.View
  template: JST['backbone/templates/groups/edit']

  events:
    'submit #edit-group': 'save'
    'click .delete': 'destroy'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    groupDetails = $(e.currentTarget).serializeObject();
    groupDetails.members = JSON.stringify(@model.get('members'))
    @model.save(groupDetails, {
      success: (group) ->
        window.location.hash = "#/groups/"
    });

  destroy: (e) ->
    e.preventDefault()
    @model.destroy({
      success: () ->
        window.location.hash = "#/groups/"
    })

  render: ->
    @$el.html(@template({
      group: @model
    }))
    @$("form").backboneLink(@model)
    return this