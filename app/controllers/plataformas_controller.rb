class PlataformasController < ApplicationController
  def index
    plataformas = Plataforma.all
    render json: plataformas
  end

  def show
    plataforma = Plataforma.find(params[:id])
    render json: plataforma
  end

  def create
    plataforma = Plataforma.new(plataforma_params)

    if plataforma.save
      render json: plataforma, status: :created
    else
      render json: { errors: plataforma.errors }, status: :unprocessable_entity
    end
  end

  def update
    plataforma = Plataforma.find(params[:id])

    if plataforma.update(plataforma_params)
      render json: plataforma
    else
      render json: { errors: plataforma.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    plataforma = Plataforma.find(params[:id])
    plataforma.destroy

    head :no_content
  end

  private

  def plataforma_params
    params.require(:plataforma).permit(:nome, :url)
  end
end
