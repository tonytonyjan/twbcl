class ComponentTypesController < ApplicationController
  before_filter :find!, :only => [:show, :edit, :update, :destroy]

  def index
    @component_types = ComponentType.all
  end

  def show
    @component_types = ComponentType.all
    @components = @component_type.components
  end

  def new
    @component_type = ComponentType.new
  end

  def create
    @component_type = ComponentType.new params[:component_type]
    if @component_type.save
      flash[:notice] = "Succeeded!"
      redirect_to component_types_path
    else
      flash[:alert] = "Failed!"
      render "new"
    end
  end

  def edit
  end

  def update
    if @component_type.update_attributes params[:component_type]
      flash[:notice] = "Succeeded!"
      redirect_to component_types_path
    else
      flash[:alert] = "Failed!"
      render "edit"
    end
  end

  def destroy
    @component_type.destroy
    flash[:alert] = "Succeeded!"
    redirect_to component_types_path
  end

  private
  def find!
    unless @component_type = ComponentType.find(params[:id])
      flash[:alert] = "Component type not found!"
      redirect_to request.referer || root_path
    end
  end
end
