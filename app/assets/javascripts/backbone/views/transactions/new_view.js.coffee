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
    group = if @options.group then @options.group.toJSON() else null
    @$el.html(@template({
      model: @model.toJSON()
      group: group
      action: @options.action
    }))
    # Work around so JqueryUI and Bootstrap play nice
    btn = $.fn.button.noConflict()
    $.fn.btn = btn

    @$('#actions').buttonset()
    @$("form").backboneLink(@model)
    return this