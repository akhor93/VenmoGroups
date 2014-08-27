VenmoGroups.Views.Transactions ||= {}

class VenmoGroups.Views.Transactions.NewView extends Backbone.View
  template: JST['backbone/templates/transactions/new']

  events:
    'submit #new-transaction': 'save'
    'remove-memberbox': 'removeMemberbox'
    'add-memberbox': 'updateFields'
    'change #transaction-amount': 'updateTotal'
    'click .action-button': 'setAction'

  save: (e) ->
    that = this
    e.preventDefault()
    e.stopPropagation()

    transactionDetails = $(e.currentTarget).serializeObject();
    transactionDetails.members = @model.get('members')
    
    @model.save(transactionDetails, {
      success: (transaction) ->
        that.collection.add(transaction)
        window.location.hash = "#/"
    });

  removeMemberbox: (ev, id) ->
    $('#memberbox-' + id).remove()
    @updateFields()

  updateFields: ->
    @updateNumPeople()
    @updateTotal()

  updateNumPeople: ->
    @$('#num-people-text').html(@model.get('num_people'))

  updateTotal: ->
    @$('#transaction-total').html(@model.get('total').toFixed(2))

  setAction: (ev) ->
    $('#transaction-submit-button').html($(ev.currentTarget).html())

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