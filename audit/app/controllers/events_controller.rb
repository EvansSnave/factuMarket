class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    event = Event.new(event_params)

    if event.save
      render json: { message: "Evento registrado", event: event }, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def getBill
    render json: Event.find(params[:entity_id])
  end

  private

  def event_params
    params.require(:event).permit(:entity_id, :service, :type, :description, :state, payload: {})
  end
end
