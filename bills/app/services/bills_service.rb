class BillsService
  def self.get_bills_by_range(start_date, end_date)
    bills = Bill.all

    if Date.parse(start_date) > Date.parse(end_date)
      self.send_audit_event(
        type: "PETICION_FACTURA_ERROR",
        entity_id: 0,
        description: "La fecha #{start_date} no puede ser despues de la fecha #{end_date}",
        payload: {}
      )
      return
    end

    if start_date.present?
      bills = bills.where("bill_date >= ?", start_date)
    end

    if end_date.present?
      bills = bills.where("bill_date <= ?", end_date)
    end

    self.send_audit_event(
      type: "PETICION_FACTURA",
      entity_id: 0,
      description: "Se enviaron todas las facturas entre #{start_date} y #{end_date}",
      payload: {
        count: bills.count
      }
    )

    bills
  end 

  def self.create_bill(bill_params)
    if !self.user_exists?(bill_params[:user_id])
      self.send_audit_event(
        type: "FACTURA_CREADA_ERROR",
        entity_id: 0,
        description: "Hubo un error creando la factura Error: EL usuario con id: #{bill_params[:user_id]} no existe",
        payload: {}
      )

      return
    end

    bill = Bill.new(bill_params)

    if bill.save
      self.send_audit_event(
        type: "FACTURA_CREADA",
        entity_id: bill.id,
        description: "Una factura fue creada",
        payload: bill.as_json
      )
    else
      self.send_audit_event(
        type: "FACTURA_CREADA_ERROR",
        entity_id: 0,
        description: "Hubo un error creando la factura con id #{bill.id} Error: #{bill.errors.full_messages}",
        payload: {}
      )
    end

    bill
  end

  def self.get_bill_by_id(id)
    bill = Bill.find_by(id: id)
    if bill.present?
      self.send_audit_event(
        type: "PETICION_FACTURA",
        entity_id: bill.id,
        description: "Se envio la factura con id #{bill.id}",
        payload: bill.as_json
      )
    else
      self.send_audit_event(
        type: "PETICION_FACTURA_ERROR",
        entity_id: 0,
        description: "La factura con id: #{id} no existe",
        payload: {}
      )
    end

    bill
  end

  private

  def self.send_audit_event(data)
    AuditClient.send_event(data)
  end

  def self.user_exists?(user_id)
    ClientsClient.user_exists?(user_id)
  end
end
