class BillsController < ApplicationController
   def index
    start_date = params[:fechaInicio]
    end_date = params[:fechaFin]

    bills = Bill.all

    if start_date.present?
      bills = bills.where("bill_date >= ?", start_date)
    end

    if end_date.present?
      bills = bills.where("bill_date <= ?", end_date)
    end

    send_audit_event(
      type: "PETICION_FACTURA",
      entity_id: bills.first.id,
      description: "Se enviaron todas las facturas entre #{start_date} y #{end_date}",
      payload: bills.as_json
    )

    render json: bills
  end

  def create 
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
      render json: { errors: bill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def getBill 
    bill = Bill.find(params[:id])
    send_audit_event(
      type: "PETICION_FACTURA",
      entity_id: bill.id,
      description: "Se envio la factura con id #{bill.id}",
      payload: bill.as_json
    )

    render json: bill
  end

  private 

  def bill_params
    params.require(:bill).permit(:user_id, :description, :amount, :product, :bill_date)
  end

  def send_audit_event(data)
    AuditClient.send_event(data)
  end
end
