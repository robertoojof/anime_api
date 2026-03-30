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

  path '/ready' do
    get 'Readiness check' do
      tags 'Health'
      produces 'application/json'

      response '200', 'ok' do
        run_test!
      end

      response '503', 'service unavailable' do
        run_test!
      end
    end
  end
end
