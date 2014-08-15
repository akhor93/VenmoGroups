class VenmoGroups.Models.Transaction extends Backbone.Model
  paramRoot: 'transaction'

  urlRoot: '/transactions'

class VenmoGroups.Collections.TransactionsCollection extends Backbone.Collection
  model: VenmoGroups.Models.Transaction
  url: '/transactions'