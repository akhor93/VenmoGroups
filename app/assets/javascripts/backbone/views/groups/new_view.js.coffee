VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.NewView extends Backbone.View
  template: JST['backbone/templates/groups/new']

  events:
    'submit #new-group': 'save'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    groupDetails = $(e.currentTarget).serializeObject();
    groupDetails.members = JSON.stringify @model.get 'members'
    @model.save(groupDetails, {
      success: (group) ->
        that.collection.add group
        window.location.hash = "#/groups/"
    });

  render: (options) ->
    @$el.html(@template())
    @$("form").backboneLink(@model)
    return this