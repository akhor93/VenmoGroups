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
    groups = @options.groups.toJSON()
    group
    for g in groups
      if g.id == transaction.group_id
        group = g
        members = JSON.parse(group.members)
        num_members = members.length
        break
    transaction.amount = @flipSigns(transaction.amount)
    @$el.html(@template({
      transaction: transaction
      friends: @options.friends
      group: group
      date: date.format("MM/DD/YY")
    }))
    return this

  flipSigns: (amount) ->
    return Math.abs(amount)