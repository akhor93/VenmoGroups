class VenmoGroups.Routers.TransactionRouter extends Backbone.Router
  initialize: (options) ->
    @transactions = options.transactions

  routes:
    '': 'index'
    '/index': 'index'

  index: ->
    @view = new VenmoGroups.Views.Transactions.IndexView({
      collection: @transactions
      user: @user
      friends: @friends
    })
    $('#main-content').html(@view.render().el)