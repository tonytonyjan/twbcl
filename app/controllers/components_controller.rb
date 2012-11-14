class ComponentsController < ApplicationController
  before_filter :find!, :only => [:show, :edit, :update, :destroy, :download_osm]
  before_filter :find_component_type!, :only => [:new]
  before_filter :set_header, :only => [:new, :edit]

  def index
    @header = Component.model_name.human
    @components = Component.paginate(:page => params[:page], :per_page => 40)
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
    @header += "/" + @component_type.name
    @component = @component_type.template ? @component_type.template.dup : Component.new
    @component.assign_attributes name: nil, is_template: false
    @component.component_types << @component_type
    # @component.os_objects.build.attrs.build
  end

  def create
    @component = Component.create(params[:component])
    if @component.save
      flash[:notice] = t("succeed")
      redirect_to @component.is_template ? component_types_path : @component
    else
      flash[:alert] = t("fail")
      render "new"
    end
  end

  def edit
    @header += "/#{@component.name.presence || @component.component_types.first.name}"
    #@component.os_objects.build.attrs.build
  end

  def update
    if @component.update_attributes params[:component]
      flash[:notice] = t("succeed")
      redirect_to @component.is_template ? component_types_path : @component
    else
      flash[:alert] = t("fail")
      render "edit"
    end
  end

  def destroy
    @component.destroy
    flash[:notice] = t("succeed")
    redirect_to request.referer || components_path
  end

  def download_osm
    send_data @component.to_osm, :filename => "#{@component.name.parameterize}.osm"
  end

  def choose_type
    @header = "#{t("obj_complements.new", :thing => Component.model_name.human)} / #{t("please_choose_a_type")}"
    @component_types = ComponentType.all
    render "templates/choose_type"
  end

  private
  def find!
    unless @component = Component.find(params[:id])
      flash[:alert] = "Component not found!"
      redirect_to request.referer || components_path
    end
  end

  private
  def find_component_type!
    unless @component_type = ComponentType.find(params[:component_type_id])
      flash[:alert] = "Not found"
      redirect request.referer || components_path
    end
  end
end
