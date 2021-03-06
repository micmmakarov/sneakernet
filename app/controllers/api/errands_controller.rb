class Api::ErrandsController < Api::ApplicationController

  def index
    @errands = Errand.scoped
    if params[:source_place_id].present?
      @errands = @errands.where(:source_place_id => params[:source_place_id])
    end
    if params[:arrival_place_id].present?
      @errands = @errands.where(:arrival_place_id => params[:arrival_place_id])
    end
    @errands = @errands.order("deadline desc").limit(30)
    render json: @errands.to_json(include_hash)
  end

  def create
    @errand = Errand.new(params[:errand])
    @errand.requester_id = current_user.id
    from_coords = Geocoder.coordinates(@errand.source_place.display_name)
    to_coords = Geocoder.coordinates(@errand.arrival_place.display_name)
    @errand.distance = Geocoder::Calculations.distance_between(to_coords,
                                                               from_coords)
    @errand.save!
    render json: @errand.to_json(include_hash)
  end

  def update
    @errand = Errand.find(params[:id])
    if @errand.requester_id = current_user.id
      if @errand.update_attributes(params[:errand])
        render json: @errand.to_json(include_hash)
      else
        head :no_content
      end
    end
  end

  def destroy
    @errand = Errand.find(params[:id])
    @errand.destroy if @errand.requester_id == current_user.id
    head :no_content
  end

  def show
    @errand = Errand.find(params[:id])
    render json: @errand.to_json(include_hash)
  end

private
  def include_hash
    {:include => {:source_place => {:only => :display_name}, :arrival_place => {:only => :display_name}, :requester => {:only => [:name, :image_url]}}}
  end
end
