class BillsController < ApplicationController
  def home
    @bill = Bill.new

    if params[:fechaInicio].present?
      @bills = BillsService.get_bills_by_range(params[:fechaInicio], params[:fechaFin])
    end

    if params[:commit] == "Crear factura"
      @bill = BillsService.create_bill(bill_params)
    end

    if params[:search_id].present?
      @requestedBill = BillsService.get_bill_by_id(params[:search_id])
    end
  end

  def index
    start_date = params[:fechaInicio]
    end_date = params[:fechaFin]
    bills = BillsService.get_bills_by_range(start_date, end_date)

    if Date.parse(start_date) > Date.parse(end_date)
      render json: { errors: "La fecha #{start_date} no puede ser despues de la fecha #{end_date}" }
      return
    end

    render json: bills
  end

  def create 
    bill = BillsService.create_bill(bill_params)

    if bill.save
      render json: { message: "Factura creada", bill: bill }, status: :created
    else
      render json: { errors: bill.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def getBill
    bill = BillsService.get_bill_by_id(params[:id])
    if bill.present?
      render json: bill
    else
      render json: { errors: "La factura con id: #{params[:id]} no existe"}
    end
  end

  private 

  def bill_params
    params.require(:bill).permit(:user_id, :description, :amount, :product, :bill_date)
  end
end
