class VenmoGroups.Models.Group extends Backbone.Model
  paramRoot: 'group'
  urlRoot: '/groups'

  defaults: {
    'members': new Array()
  }

  initialize: (options) ->
    @set('type','group')
    @set_members_as_array()
    @set_num_members_text()
    @on('change:members', @set_members_as_array, this)
    @on('change:members', @set_num_members_text, this)


  set_num_members_text: ->
    num_members = @get('members').length
    num_members_text = num_members + " member"
    if num_members != 1
      num_members_text += 's'
    @set('num_members_text', num_members_text)

  set_members_as_array: ->
    if typeof @get('members') == 'string'
      @set('members', JSON.parse(@get('members')))

  validation:
    name:
      required: true
    members: (value, attr, computedState) ->
      if value.length == 0
        return 'Groups cannot be empty. Please add your friends'

class VenmoGroups.Collections.GroupsCollection extends Backbone.Collection
  model: VenmoGroups.Models.Group
  url: '/groups'