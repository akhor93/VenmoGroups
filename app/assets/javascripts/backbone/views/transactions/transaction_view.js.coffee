VenmoGroups.Views.Transactions ||= {}

class VenmoGroups.Views.Transactions.TransactionView extends Backbone.View
  template: JST['backbone/templates/transactions/transaction']

  tagName: 'tr'

  render: ->
    @$el.html(@template({
      transaction: @model
      friends: @options.friends
    }))
    return this