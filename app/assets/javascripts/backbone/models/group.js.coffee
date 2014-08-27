class VenmoGroups.Models.Group extends Backbone.Model
  paramRoot: 'group'
  urlRoot: '/groups'

  defaults: {
    'members': new Array()
  }

  initialize: (options) ->
    if typeof options.members == 'string' then @set('members', JSON.parse(options.members))
    @set('type','group')
    @set_num_members_text()
    @on('change', @set_num_members_text, this)


  set_num_members_text: ->
    num_members = @get('members').length
    num_members_text = num_members + " member"
    if num_members != 1
      num_members_text += 's'
    @set('num_members_text', num_members_text)

class VenmoGroups.Collections.GroupsCollection extends Backbone.Collection
  model: VenmoGroups.Models.Group
  url: '/groups'