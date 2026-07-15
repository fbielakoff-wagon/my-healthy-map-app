class SpotsController < ApplicationController
  before_action :set_spot, only: %i[show edit update destroy]

  # GET /spots
  # GET /spots?city=London
  # GET /spots?category=fitness
  # GET /spots?city=London&category=fitness
  def index
    @spots = Spot.all
    @spots = @spots.where(city: params[:city]) if params[:city].present?
    @spots = @spots.where(category: params[:category]) if params[:category].present?

    respond_to do |format|
      format.html # renders app/views/spots/index.html.erb, uses @spots
      format.json { render json: @spots }
    end
  end

  # GET /spots/:id
  def show
    respond_to do |format|
      format.html
      format.json { render json: @spot }
    end
  end

  # GET /spots/new
  def new
    @spot = Spot.new
  end

  # POST /spots
  def create
    @spot = current_user.spots.new(spot_params)

    if @spot.save
      redirect_to @spot, notice: "Spot was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /spots/:id/edit
  def edit
  end

  # PATCH/PUT /spots/:id
  def update
    if @spot.update(spot_params)
      redirect_to @spot, notice: "Spot was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /spots/:id
  def destroy
    @spot.destroy
    redirect_to spots_path, notice: "Spot was successfully deleted.", status: :see_other
  end

  private

  def set_spot
    @spot = Spot.find(params[:id])
  end

  def spot_params
    params.require(:spot).permit(:name, :description, :category, :address, :latitude, :longitude, :city)
  end
end
