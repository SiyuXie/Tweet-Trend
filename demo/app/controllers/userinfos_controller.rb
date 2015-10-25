require 'json'

class UserinfosController < ApplicationController
  before_action :set_userinfo, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  # GET /userinfos
  # GET /userinfos.json
  def index
    # @userinfos = Userinfo.all
    @userinfo = Userinfo.where(id: current_user.id)[0]
    if @userinfo == nil
      # new user
      new_record = {'id' => current_user.id,
        'user_name' => current_user.email,
        'country' => '-'}
      Userinfo.create(new_record).save

      @userinfo = Userinfo.where(id: current_user.id)[0]
    end
  end

  # GET /userinfos/1
  # GET /userinfos/1.json
  def show
  end

  # GET /userinfos/new
  # def new
  #   @userinfo = Userinfo.new
  # end

  # GET /userinfos/1/edit
  def edit
  end

  # POST /userinfos
  # POST /userinfos.json

  # PATCH/PUT /userinfos/1
  # PATCH/PUT /userinfos/1.json
  def update
    respond_to do |format|
      if @userinfo.update(userinfo_params)
        format.html { redirect_to @userinfo, notice: 'Userinfo was successfully updated.' }
        format.json { render :show, status: :ok, location: @userinfo }
      # else
      #   format.html { render :edit }
      #   format.json { render json: @userinfo.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_userinfo
      # @userinfo = Userinfo.find(params[:id])
      @userinfo = Userinfo.find(current_user.id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def userinfo_params
      params.require(:userinfo).permit(:user_name, :country, :city, :age)
    end
end
