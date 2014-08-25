VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.NewView extends Backbone.View
  template: JST['backbone/templates/groups/new']

  initialize: ->
    @model = new @collection.model()

  events:
    'submit #new-group': 'save'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    groupDetails = {}
    groupDetails.name = $('#group-name').val()
    groupDetails.members = @memberBoxToString()
    @model.save(groupDetails, {
      success: (group) ->
        that.collection.add(group)
        window.location.hash = "#/groups/"
    });

  memberBoxToString: ->
    members = []
    for e in $('#venmo-onebox-names .member-box')
      members.push($(e).attr('data-userid'))
    return JSON.stringify(members)

  render: (options) ->
    @$el.html(@template())
    @$("form").backboneLink(@model)
    return this