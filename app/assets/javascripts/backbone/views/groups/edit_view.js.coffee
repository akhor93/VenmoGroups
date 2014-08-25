VenmoGroups.Views.Groups ||= {}

class VenmoGroups.Views.Groups.EditView extends Backbone.View
  template: JST['backbone/templates/groups/edit']

  events:
    'submit #edit-group': 'save'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    groupDetails = {}
    groupDetails.name = $('#group-name').val()
    groupDetails.members = @memberBoxToString()
    @model.save(groupDetails, {
      success: (group) ->
        window.location.hash = "#/groups/"
    });

  memberBoxToString: ->
    members = []
    for e in $('#venmo-onebox-names .member-box')
      members.push($(e).attr('data-userid'))
    return JSON.stringify(members)

  IDToMemberNames: (ids_string) ->
    ids = JSON.parse(ids_string);
    members = [];
    for id in ids
      members.push(@options.friends[id]['display_name'] + ', ')
    return members.join("")

  render: ->
    @$el.html(@template({
      group: @model
    }))
    @$("form").backboneLink(@model)
    return this