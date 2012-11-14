class TemplatesController < ApplicationController
  before_filter :find_component_type!, :only => [:new]

  def new
    @header = @component_type.name
    @component = @component_type.template.presence || Component.new(is_template: true, template_type: @component_type, name: @component_type.name)
    @component.os_objects.build.attrs.build
    render "components/new"
  end

  def create
    @component = Component.create(params[:component])
    if @component.save
      flash[:notice] = t("succeed")
      redirect_to component_types_path
    else
      flash[:alert] = t("fail")
      render "new"
    end
  end

  def index
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def choose_type
    @header = "#{t("obj_complements.new", :thing => t("template"))} / #{t("please_choose_a_type")}"
    @component_types = ComponentType.all
  end

  private
  def find_component_type!
    unless @component_type = ComponentType.find(params[:component_type_id])
      flash[:alert] = "Not found"
      redirect request.referer || components_path
    end
  end
end
