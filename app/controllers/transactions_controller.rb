class TransactionsController < ApplicationController
  def create
    @transaction = Transaction.submit_and_save(params[:transaction], current_user)
    respond_to do |format|
      format.html { redirect_to @transaction, notice: 'Group was successfully created.' }
      format.json { render json: @transaction, status: :created, location: @group }
    end
  end
end
