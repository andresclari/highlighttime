class StreamsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:update, :destroy]
  skip_before_filter :verify_authenticity_token

  def index
    @records = Stream.where(user_id: current_user.id)
  end

  def create
    @record = Stream.new
    @record.user_id = current_user.id
    @record.start_time = DateTime.now
    unless @record.save
      return render status: 400, json: { }
    end
    render :show
  end

  def show
  end

  def update
    @record.stop_time = DateTime.now
    unless @record.save
      return render status: 400, json: { }
    end
    render :show
  end

  def destroy
    @record.highlights.each do |highlight|
      highlight.destroy
    end
    @record.destroy
    return render status: 200, json: { }
  end

  private
    def set_record
      @record = Stream.find(params[:id])
    end

    def record_params
      accessible = [ :start_time, :stop_time ]
      params.require(:stream).permit(accessible)
    end

end
