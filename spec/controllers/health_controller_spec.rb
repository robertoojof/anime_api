require 'rails_helper'

RSpec.describe HealthController, type: :controller do
  describe 'GET #health' do
    it 'returns status ok' do
      get :health

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({ 'status' => 'ok' })
    end
  end

  describe 'GET #ready' do
    context 'quando o banco está saudável' do
      before do
        fake_conn = double('connection')
        allow(fake_conn).to receive(:execute).with('SELECT 1')

        allow(ActiveRecord::Base.connection_pool)
          .to receive(:with_connection).and_yield(fake_conn)
      end

      it 'retorna status ok com os checks' do
        get :ready

        expect(response).to have_http_status(:ok)

        body = JSON.parse(response.body)
        expect(body['status']).to eq('ok')
        expect(body['checks']['database']['status']).to eq('ok')
        expect(body['checks']['database']).to have_key('response_time_ms')
      end
    end

    context 'quando o banco está com erro' do
      before do
        allow(ActiveRecord::Base.connection_pool)
          .to receive(:with_connection).and_raise(PG::ConnectionBad, 'connection refused')
      end

      it 'retorna status 503 com a mensagem de erro' do
        get :ready

        expect(response).to have_http_status(:service_unavailable)

        body = JSON.parse(response.body)
        expect(body['status']).to eq('error')
        expect(body['checks']['database']['status']).to eq('error')
        expect(body['checks']['database']['message']).to eq('connection refused')
      end

      it 'loga o erro' do
        expect(Rails.logger).to receive(:error)
          .with('[HEALTH CHECK] DATABASE ERROR: connection refused')

        get :ready
      end
    end
  end
end
