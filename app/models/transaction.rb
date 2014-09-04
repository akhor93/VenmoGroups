class Transaction < ActiveRecord::Base
  validates :members, presence: true
  validates :amount, presence: true
  validates :note, presence: true
  validates :action, presence: true
  validates :venmo_transaction_ids, presence: true

  #Associations
  belongs_to :user

  def self.submit_and_save(params, user)
    amount = params[:amount]
    if params[:action] === 'charge'
      amount.insert(0,'-');
    end
    transaction_ids = Array.new
    params[:members].each do |m|
      res_json = JSON.parse(RestClient.post('https://api.venmo.com/v1/payments', 'access_token' => user.access_token, 'user_id' => m, 'note' => params[:note], 'amount' => amount, 'audience' => 'friends'))
      payment = res_json['data']['payment']
      transaction_ids << payment['id']
      # transaction_ids << '1234'
    end
    transaction_params = { :members => params[:members].to_json, :user => user, :amount => amount, :note => params[:note], :action => params[:action], :venmo_transaction_ids => transaction_ids.to_json }
    transaction = Transaction.create(transaction_params)
    return transaction
  end
end