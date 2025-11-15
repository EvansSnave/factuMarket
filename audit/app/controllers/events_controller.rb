class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def home
    if params[:search_id].present?
      @events = EventsService.get_bill_events(params[:search_id]);
    end
  end

  def create
    event = Event.new(event_params)

    if event.save
      render json: { message: "Evento registrado", event: event }, status: :created
    else
      render json: { errors: event.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def get_bill_events
    bill_id = params[:id]
    if !BillsClient.bill_exists?(bill_id)
      render json: { errors: "La factura con id: #{bill_id} no existe" }, status: :unprocessable_entity
      return
    end

    events = EventsService.get_bill_events(bill_id)

    if events.count > 0
      render json: { message: "Eventos obtenidos para factura con id #{bill_id}", events: events }, status: :created
    else
      render json: { errors: "No hay eventos para la facura con id: #{bill_id}" }, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:entity_id, :service, :type, :description, :state, payload: {})
  end
end
