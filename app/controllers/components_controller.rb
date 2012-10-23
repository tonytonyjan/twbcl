class ComponentsController < ApplicationController
  before_filter :find!, :only => [:show, :edit, :update, :destroy, :sort_os_obj]

  def index
    @components = Component.search(params)
    @component_types = ComponentType.all
  end

  def show
    case request.format
    when "json" then render :json => @component
    when "xml" then render :xml => @component
    when "yaml" then render :text => @component.to_yaml, :content_type => 'text/yaml'
    end
  end

  def new
    if found = params[:template_id] && Component.find(params[:template_id])
      @component = found.dup
      @component.is_template = false
    else
      @component = Component.new
    end
    @component.os_objects.build.attrs.build
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
    @component.os_objects.build.attrs.build
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

  def sort_os_obj
    if @component.sort_os_obj params[:os_obj_order]
      render :nothing => true, :status => 200
    else
      render :nothing => true, :status => 400
    end
  end

  private
  def find!
    unless @component = Component.find(params[:id])
      flash[:alert] = "Component not found!"
      redirect_to request.referer || components_path
    end
  end
end
