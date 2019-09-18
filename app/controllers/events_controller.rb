class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def new
    @event = Event.new
  end

  def index
    @events = Event.where(start: params[:start]..params[:end])
  end

  def show
    #@events = Event.find(params[:id])
  end

  def edit
  end

  def create    
    @event = Event.new(event_params)
    #binding.pry
    @event.save
  end

  def update
    #binding.pry
    if params[:commit] =="Update Event"
      @event.update(event_params)
    elsif params[:commit] == "update all events"
      @event = Event.find(params[:id])
      @recurring_event = @event.recurring_event
      @recurring_events = @recurring_event.events
      @recurring_events.each do |event|
        event.update(update_all_event_params)
      end
    end
  end

  def destroy
    @event.destroy
  end



  private
    def set_event
      @event = Event.find(params[:id])  
    end

    def event_params
      params.require(:event).permit(:title, :date_range, :start, :end, :color, :recurring_event_id)
    end

    def update_all_event_params
      params.require(:event).permit(:title, :date_range, :color, :recurring_event_id)
    end
end
