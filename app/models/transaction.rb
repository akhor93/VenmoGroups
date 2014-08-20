class Transaction < ActiveRecord::Base
  #Validations
  validates :group, presence: true
  validates :venmo_transaction_ids, presence: true

  #Associations
  belongs_to :group
  belongs_to :user

  def self.submit_and_save(params, user)
    group_id = params[:groupid]
    group = Group.find(group_id)
    members = JSON.parse(group.members);
    amount = params[:amount]
    if params[:action] === 'charge'
      amount.insert(0,'-');
    end
    transaction_ids = Array.new
    members.each do |m|
      uri = URI('https://api.venmo.com/v1/payments');
      # res = Net::HTTP.post_form(uri, 'access_token' => user.access_token, 'user_id' => m, 'note' => params[:note], 'amount' => amount, 'audience' => 'friends');
      # res_json = JSON.parse res.body
      # payment = res_json['data']['payment']
      # transaction_ids << payment['id']
      transaction_ids << '1234'
    end
    transaction_params = { :group => group, :user => user, :amount => amount, :note => params[:note], :action => params[:action], :venmo_transaction_ids => transaction_ids.to_json }
    transaction = Transaction.create(transaction_params)
    return transaction
  end

  def self.get_transactions_from_group(group, user)
    transactions = Array.new();
    group.transactions.each do |t|
      uri = URI('https://api.venmo.com/v1/payments/' + t.venmo_transaction_id + '?access_token=' + user.access_token)
      data = JSON.parse Net::HTTP.get(uri)
      transactions << data['data']
    end
    return transactions
  end
end
