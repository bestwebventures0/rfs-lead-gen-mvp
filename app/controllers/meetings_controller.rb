class MeetingsController < ApplicationController
  layout "dashboard"
  before_action :authenticate_user!
  
  # before_action :set_meeting, only: %i[ edit update ]
  before_action :set_advisor, only: %i[ new create ]

  # GET /meetings/new
  def new
    @meeting = Meeting.new    
  end

  # GET /meetings/1/edit
  # def edit
  #   if @meeting.done
  #     redirect_to dashboard_advisors_path, alert: "Meeting has been concluded."
  #   end
  # end

  # POST /meetings or /meetings.json
  def create
    @meeting = Meeting.new(meeting_params)
    @meeting.match = Match.where(advisor: @advisor, user: current_user).uniq.first

    respond_to do |format|
      if @meeting.save
        DashboardMailer.new_meeting(current_user, @advisor, @meeting).deliver_later
        format.html { redirect_to dashboard_advisors_path, notice: "Meeting was successfully created." }
        # format.json { render :show, status: :created, location: @meeting }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meetings/1 or /meetings/1.json
  # def update
  #   respond_to do |format|
  #     if @meeting.update(meeting_params)
  #       format.html { redirect_to dashboard_advisors_path, notice: "Meeting was successfully updated." }
  #       # format.json { render :show, status: :ok, location: @meeting }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @meeting.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    # def set_meeting
    #   @meeting = Meeting.find(params[:id])
    # end

    def set_advisor
      @advisor = Advisor.find(params[:advisor_id])
    end

    # Only allow a list of trusted parameters through.
    def meeting_params
      params.require(:meeting).permit(:day, :when, :how, :note)
    end
end
