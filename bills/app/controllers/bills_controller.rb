class BillsController < ApplicationController
   def index
    start_date = params[:fechaInicio]
    end_date = params[:fechaFin]

    bills = Bill.all

    if Date.parse(start_date) > Date.parse(end_date)
      send_audit_event(
        type: "PETICION_FACTURA_ERROR",
        entity_id: 0,
        description: "La fecha #{start_date} no puede ser despues de la fecha #{end_date}",
        payload: {}
      )

      render json: { errors: "La fecha #{start_date} no puede ser despues de la fecha #{end_date}" }
      return
    end

    if start_date.present?
      bills = bills.where("bill_date >= ?", start_date)
    end

    if end_date.present?
      bills = bills.where("bill_date <= ?", end_date)
    end

    send_audit_event(
      type: "PETICION_FACTURA",
      entity_id: 0,
      description: "Se enviaron todas las facturas entre #{start_date} y #{end_date}",
      payload: bills.as_json
    )

    render json: bills
  end

  def create 
    if !user_exists?(bill_params[:user_id])
      send_audit_event(
        type: "FACTURA_CREADA_ERROR",
        entity_id: 0,
        description: "Hubo un error creando la factura Error: EL usuario con id: #{bill_params[:user_id]} no existe",
        payload: {}
      )

      render json: { errors: "Hubo un error creando la factura Error: EL usuario con id: #{bill_params[:user_id]} no existe" }, status: :unprocessable_entity
      return
    end

    bill = Bill.new(bill_params)

    if bill.save
      send_audit_event(
        type: "FACTURA_CREADA",
        entity_id: bill.id,
        description: "Una factura fue creada",
        payload: bill.as_json
      )

      render json: { message: "Factura creada", bill: bill }, status: :created
    else
      send_audit_event(
        type: "FACTURA_CREADA_ERROR",
        entity_id: 0,
        description: "Hubo un error creando la factura con id #{bill.id} Error: #{bill.errors.full_messages}",
        payload: {}
      )

      render json: { errors: bill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def getBill 
    bill = Bill.find_by(id: params[:id])
    if bill.present?
      send_audit_event(
        type: "PETICION_FACTURA",
        entity_id: bill.id,
        description: "Se envio la factura con id #{bill.id}",
        payload: bill.as_json
      )

      render json: bill
    else
      send_audit_event(
        type: "PETICION_FACTURA_ERROR",
        entity_id: 0,
        description: "La factura con id: #{params[:id]} no existe",
        payload: {}
      )

      render json: { errors: "La factura con id: #{params[:id]} no existe"}
    end
  end

  private 

  def bill_params
    params.require(:bill).permit(:user_id, :description, :amount, :product, :bill_date)
  end

  def send_audit_event(data)
    AuditClient.send_event(data)
  end

  def user_exists?(user_id)
    ClientsClient.user_exists?(user_id)
  end
end
