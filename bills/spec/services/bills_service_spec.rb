require "rails_helper"

RSpec.describe BillsService do
  describe ".get_bills_by_range" do
    before do
      allow(AuditClient).to receive(:send_event)
    end

    let!(:bill1) { create(:bill, bill_date: Date.new(2024, 1, 10)) }
    let!(:bill2) { create(:bill, bill_date: Date.new(2024, 1, 15)) }
    let!(:bill3) { create(:bill, bill_date: Date.new(2024, 2, 1)) }

    it "returns bills within date range" do
      bills = BillsService.get_bills_by_range("2024-01-01", "2024-01-31")

      expect(bills.count).to eq(2)
      expect(bills).to include(bill1, bill2)
      expect(bills).not_to include(bill3)
      expect(AuditClient).to have_received(:send_event).with(
        hash_including(
          type: "PETICION_FACTURA",
          entity_id: 0,
          description: "Se enviaron todas las facturas entre 2024-01-01 y 2024-01-31"
        )
      )
    end

    it "sends an error event when start_date > end_date" do
      BillsService.get_bills_by_range("2024-02-01", "2024-01-01")

      expect(AuditClient).to have_received(:send_event).with(
        hash_including(
          type: "PETICION_FACTURA_ERROR",
          description: "La fecha 2024-02-01 no puede ser despues de la fecha 2024-01-01"
        )
      )
    end
  end

  describe ".create_bill" do
    before do
      allow(AuditClient).to receive(:send_event)
    end

    let!(:user_id) { 1 }

    context "when user exists" do
      before do
        allow(ClientsClient).to receive(:user_exists?).and_return(true)
      end

      it "creates the bill and sends success event" do
        params = {
          user_id: user_id,
          description: "Test",
          product: "Item",
          amount: 123,
          bill_date: Date.today
        }

        bill = BillsService.create_bill(params)

        expect(bill).to be_persisted

        expect(AuditClient).to have_received(:send_event).with(
          hash_including(
            type: "FACTURA_CREADA",
            entity_id: bill.id,
            description: "Una factura fue creada",
          )
        )
      end
    end

    context "when user does NOT exist" do
      before do
        allow(ClientsClient).to receive(:user_exists?).and_return(false)
      end

      it "does not create a bill and sends error event" do
        params = {
          user_id: 99999,
          description: "Test",
          product: "Item",
          amount: 123,
          bill_date: Date.today
        }

        bill = BillsService.create_bill(params)

        expect(bill).to be_nil

        expect(AuditClient).to have_received(:send_event).with(
          hash_including(
            type: "FACTURA_CREADA_ERROR",
            description: "Hubo un error creando la factura Error: EL usuario con id: 99999 no existe"
          )
        )
      end
    end
  end

  describe ".get_bill_by_id" do
    before do
      allow(AuditClient).to receive(:send_event)
    end

    let!(:bill) { create(:bill) }

    it "returns the bill and sends success audit" do
      result = BillsService.get_bill_by_id(bill.id)

      expect(result).to eq(bill)

      expect(AuditClient).to have_received(:send_event).with(
        hash_including(
          type: "PETICION_FACTURA",
          entity_id: bill.id,
        )
      )
    end

    it "returns nil and sends error when bill not found" do
      result = BillsService.get_bill_by_id(99999)

      expect(result).to be_nil

      expect(AuditClient).to have_received(:send_event).with(
        hash_including(
          type: "PETICION_FACTURA_ERROR",
          description: "La factura con id: 99999 no existe"
        )
      )
    end
  end
end
