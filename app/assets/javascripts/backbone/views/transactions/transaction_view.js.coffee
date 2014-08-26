VenmoGroups.Views.Transactions ||= {}

class VenmoGroups.Views.Transactions.TransactionView extends Backbone.View
  template: JST['backbone/templates/transactions/transaction']

  tagName: 'div'

  events: {
    'click .toggle-transaction-info' : 'toggleInfo'
  }

  toggleInfo: (e) ->
    link = $(e.currentTarget)
    chevron = link.find('.chevron').first()
    chevron.toggleClass "glyphicon-chevron-down"
    chevron.toggleClass "glyphicon-chevron-up"

  render: ->
    transaction = @model.toJSON()
    @$el.addClass('transaction-container')
    date = moment(transaction.created_at)
    transaction.amount = @flipSigns(transaction.amount)
    console.log(transaction)
    @$el.html(@template({
      transaction: transaction
      friends: @options.friends
      members: JSON.parse(transaction.members)
      date: date.format("MM/DD/YY")
    }))
    return this

  flipSigns: (amount) ->
    return Math.abs(amount)