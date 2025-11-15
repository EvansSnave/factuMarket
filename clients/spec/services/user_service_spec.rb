require "rails_helper"

RSpec.describe UserService do
  describe ".create_user" do
    context "when the user is valid" do
      let(:params) do
        {
          name: "Test",
          email: "test@example.com",
          password: "123",
          password_confirmation: "123",
          identification: "10000"
        }
      end

      it "creates the user and sends the audit event" do
        allow(AuditClient).to receive(:send_event)

        user = UserService.create_user(params)

        expect(user).to be_persisted
        expect(AuditClient).to have_received(:send_event).with(
          hash_including(
            type: "CLIENTE_CREADO",
            entity_id: user.id,
            description: "Un cliente fue creado",
            payload: user.as_json
          )
        )
      end
    end

    context "when user is not valid" do
      let(:params) do
        {
          name: "Test",
          email: "",
          password: "123",
          password_confirmation: "123",
          identification: "10000"
        }
      end

      it "does not create the user and sends an error audit event" do
        allow(AuditClient).to receive(:send_event)

        user = UserService.create_user(params)

        expect(user).not_to be_persisted
        expect(AuditClient).to have_received(:send_event).with(
          hash_including(
            type: "CLIENTE_CREADO_ERROR",
            entity_id: 0,
            description: "Hubo un error al crear el cliente Error: #{user.errors.full_messages}",
            payload: {}
          )
        )
      end
    end
  end

  describe ".get_all_users" do
    it "gets all users and sends an audit event" do
      allow(AuditClient).to receive(:send_event)
      create_list(:user, 3)

      users = UserService.get_all_users

      expect(users.count).to eq(3)
      expect(AuditClient).to have_received(:send_event).with(
        hash_including(
          type: "PETICION_CLIENTE",
          entity_id: 0,
          description: "Se enviaron todos los clientes",
        )
      )
    end
  end

  describe ".get_user_by_id" do
    context "when user with id exists" do
      it "gets an user by id and send an audit event" do
        user = create(:user)
        allow(AuditClient).to receive(:send_event)

        result = UserService.get_user_by_id(user.id)

        expect(result).to eq(user)
        expect(AuditClient).to have_received(:send_event).with(
          hash_including(
            type: "PETICION_CLIENTE",
            entity_id: user.id,
            description: "Se envio el cliente con id #{user.id}",
            payload: user.as_json
          )
        )
      end
    end

    context "when user with id does not exist" do
      it "returns nill and sends audit error event" do
        allow(AuditClient).to receive(:send_event)
        result = UserService.get_user_by_id(-1)

        expect(result).to be_nil
        expect(AuditClient).to have_received(:send_event).with(
          hash_including(
            type: "PETICION_CLIENTE_ERROR",
            entity_id: 0,
            description: "El cliente con id -1 no existe",
            payload: {}
          )
        )
      end
    end
  end
end
