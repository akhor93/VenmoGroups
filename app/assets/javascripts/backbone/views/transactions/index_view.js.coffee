VenmoGroups.Views.Transactions ||= {}

class VenmoGroups.Views.Transactions.IndexView extends Backbone.View
  template: JST['backbone/templates/transactions/index']

  initialize: () ->
    @listenTo( @collection, 'add', @addOne )

  addAll: () =>
    @collection.each(@addOne)

  addOne: (transaction) =>
    view = new VenmoGroups.Views.Transactions.TransactionView({
      model: transaction
      friends: @options.friends
    })
    @$('#transactions-accordion').prepend(view.render().el)

  render: =>
    @$el.html(@template())
    @addAll()

    return this
