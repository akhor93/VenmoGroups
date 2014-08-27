class VenmoGroups.Models.Transaction extends Backbone.Model
  paramRoot: 'transaction'
  urlRoot: '/transactions'

  defaults: {
    'members': new Array()
    'action': 'pay'
    'amount': 0
    'note': ''
    'total': 0
    'num_people': 0
  }

  initialize: (options) ->
    if options.group
      @set('members', options.group.members)
    @on('change:amount', @calculateTotal, this)
    @on('change:members', @calculateTotal, this)
    @on('change:members', @calculateNumPeople, this)

  calculateTotal: ->
    @set('total', @get('amount') * @get('members').length)

  calculateNumPeople: ->
    @set('num_people', @get('members').length)

class VenmoGroups.Collections.TransactionsCollection extends Backbone.Collection
  model: VenmoGroups.Models.Transaction
  url: '/transactions'