class Admin::ClientsController < ApplicationController
  before_action :set_client, only: %i[ show edit update destroy ]

  def index
    @clients = Client.all
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @client.update(client_params)
        format.html { redirect_to admin_client_url(@client), notice: "Client was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_client
      @client = Client.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def client_params
      params.require(:client).permit(:fontsize)
    end
end
