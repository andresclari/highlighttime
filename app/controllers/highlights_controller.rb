class HighlightsController < ApplicationController
  include HighlightsHelper

  before_action :set_record, only: [:update, :destroy]
  before_action :authenticate_user!
  skip_before_filter :verify_authenticity_token

  def index
    if params[:stream_id]
      @records = Highlight.where(stream_id: params[:stream_id])
    else
      @records = Highlight.where(user_id: current_user.id)
    end
  end

  def create
    @record = Highlight.new
    @record.stream_id = params[:highlight][:stream_id]
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
    @record.destroy
    return render status: 200, json: { }
  end

  private
    def set_record
      @record = Highlight.find(params[:id])
    end

    def record_params
      accessible = [ :stream_id, :start_time ]
      params.require(:highlight).permit(accessible)
    end
end
