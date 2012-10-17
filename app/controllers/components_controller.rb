class ComponentsController < ApplicationController
  before_filter :find!, :only => [:show, :edit, :update, :destroy]

  def index
    @components = Component.all
    @component_types = ComponentType.all
  end

  def show
  end

  def new
    @component = Component.new
    @component.attrs.build
  end

  def create
    @component = Component.new params[:component]
    if @component.save
      flash[:notice] = "Succeeded!"
      redirect_to @component
    else
      render "new"
    end
  end

  def edit
    @component.attrs.build
  end

  def update
    if @component.update_attributes params[:component]
      flash[:notice] = "Succeeded!"
      redirect_to @component
    else
      flash[:alert] = "Failed!"
      render "edit"
    end
  end

  def destroy
    @component.destroy
    flash[:notice] = "Succeeded!"
    redirect_to request.referer || components_path
  end

  private
  def find!
    unless @component = Component.find(params[:id])
      flash[:alert] = "Component not found!"
      redirect_to request.referer || components_path
    end
  end
end
