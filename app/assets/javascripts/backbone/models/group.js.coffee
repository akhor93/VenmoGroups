class VenmoGroups.Models.Group extends Backbone.Model
  get_num_members_text: ->
    members = @.get('members')
    if !members
      return ''
    num_members = (JSON.parse(members)).length
    num_members_text = num_members + " member"
    if num_members != 1
      num_members_text += 's'
    return num_members_text

  paramRoot: 'group'

  urlRoot: '/groups'

class VenmoGroups.Collections.GroupsCollection extends Backbone.Collection
  model: VenmoGroups.Models.Group
  url: '/groups'