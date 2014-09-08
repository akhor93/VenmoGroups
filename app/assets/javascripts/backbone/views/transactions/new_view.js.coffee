VenmoGroups.Views.Transactions ||= {}

class VenmoGroups.Views.Transactions.NewView extends Backbone.View
  template: JST['backbone/templates/transactions/new']

  events:
    'submit #new-transaction': 'save'
    'change #transaction-amount': 'renderTotal'
    'click .action-button': 'setAction'
    'change input#transaction-amount': 'updateAmount'

  initialize: ->
    @model.on('change:members', @renderFields, this)
    @model.on('change:amount', @renderTotal, this)
    Backbone.Validation.bind(this);

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    transactionDetails = $(e.currentTarget).serializeObject();
    transactionDetails.members = @model.get('members') #preserve because input for members is always empty
    transactionDetails.amount = @model.get('amount')
    @model.save(transactionDetails, {
      success: (transaction) ->
        that.collection.add(transaction)
        window.location.hash = "#/"
    });

  renderFields: ->
    @renderNumPeople()
    @renderTotal()

  renderNumPeople: ->
    @$('#num-people-text').html(@model.get('num_people'))

  renderTotal: ->
    @$('#transaction-total').html(@model.get('total').toFixed(2))

  setAction: (ev) ->
    $('#transaction-submit-button').html($(ev.currentTarget).html())

  updateAmount: (ev) ->
    @model.set('amount',Number($(ev.currentTarget).val()))

  render: (options) ->
    group = if @options.group then @options.group.toJSON() else null
    action = if @options.action then @options.action else 'pay'
    @$el.html(@template({
      model: @model.toJSON()
      group: group
      action: action
    }))
    # Work around so JqueryUI and Bootstrap play nice
    if $.fn.button.noConflict
      btn = $.fn.button.noConflict()
      $.fn.btn = btn

    @$('#actions').buttonset()
    @$("form").backboneLink(@model)
    return this