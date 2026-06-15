require 'swagger_helper'

RSpec.describe 'Health API', type: :request do
  path '/health' do
    get 'Health check' do
      tags 'Health'
      produces 'application/json'

      response '200', 'ok' do
        run_test!
      end
    end
  end

  path '/health/ready' do
    get 'Readiness check' do
      tags 'Health'
      produces 'application/json'

      response '200', 'ok' do
        run_test!
      end

      response '503', 'service unavailable' do
        before do
          allow(ActiveRecord::Base.connection_pool).to receive(:with_connection).and_raise(PG::ConnectionBad, 'error')
        end

        run_test!
      end
    end
  end
end
