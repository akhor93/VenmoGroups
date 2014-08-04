class TransactionsController < ApplicationController
  def create
    @transactions = Transaction.submit(params, current_user)
    respond_to do |format|
      format.html { redirect_to '/' }
      format.js   {}
    end
  end
end
