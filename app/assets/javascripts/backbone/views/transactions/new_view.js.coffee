VenmoGroups.Views.Transactions ||= {}

class VenmoGroups.Views.Transactions.NewView extends Backbone.View
  template: JST['backbone/templates/transactions/new']

  initialize: ->
    @model = new @collection.model()

  events:
    'submit #new-transaction': 'save'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    transactionDetails = $(e.currentTarget).serializeObject();
    @model.save(transactionDetails, {
      success: (transaction) ->
        that.collection.add(transaction)
        window.location.hash = "#/groups/"
    });

  render: (options) ->
    @$el.html(@template({
      model: @model.toJSON()
      group: @options.group.toJSON()
      action: @options.action
      friends: @options.friends
    }))
    @$("form").backboneLink(@model)
    return this