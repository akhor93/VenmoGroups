class VenmoGroups.Models.Group extends Backbone.Model
  paramRoot: 'group'
  urlRoot: '/groups'

  defaults: {
    'members': new Array()
  }

  initialize: (options) ->
    # debugger;
    # if options && typeof options.members == 'string' then @set('members', JSON.parse(options.members))
    @set('type','group')
    @set_members_as_array()
    @set_num_members_text()
    @on('change:members', @set_num_members_text, this)
    @on('change:members', @set_members_as_array, this)


  set_num_members_text: ->
    num_members = @get('members').length
    num_members_text = num_members + " member"
    if num_members != 1
      num_members_text += 's'
    @set('num_members_text', num_members_text)

  set_members_as_array: ->
    if typeof @get('members') == 'string'
      @set('members', JSON.parse(@get('members')))

class VenmoGroups.Collections.GroupsCollection extends Backbone.Collection
  model: VenmoGroups.Models.Group
  url: '/groups'