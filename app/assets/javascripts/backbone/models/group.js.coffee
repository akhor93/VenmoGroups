class VenmoGroups.Models.Group extends Backbone.Model
  paramRoot: 'group'

  urlRoot: '/groups'

class VenmoGroups.Collections.GroupsCollection extends Backbone.Collection
  model: VenmoGroups.Models.Group
  url: '/groups'