require 'swagger_helper'

RSpec.describe 'Plataformas API', type: :request do
  path '/plataformas' do
    get 'Lista plataformas' do
      tags 'Plataformas'
      produces 'application/json'

      response '200', 'sucesso' do
        run_test!
      end
    end

    post 'Cria uma plataforma' do
      tags 'Plataformas'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :plataforma, in: :body, schema: {
        type: :object,
        properties: {
          nome: { type: :string },
          url: { type: :string }
        },
        required: [ 'nome' ]
      }

      response '201', 'criado' do
        let(:plataforma) { { nome: 'Netflix', url: 'https://netflix.com' } }
        run_test!
      end
    end
  end

  path '/plataformas/{id}' do
    get 'Busca plataforma' do
      tags 'Plataformas'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer

      response '200', 'sucesso' do
        let(:plataforma_obj) { Plataforma.create!(nome: 'Crunchyroll') }
        let(:id) { plataforma_obj.id }

        run_test!
      end
    end
  end
end
