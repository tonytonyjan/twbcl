require 'carrierwave/mongoid'
class Component
  include Mongoid::Document
  # callbacks
  before_save :process_for_template
  # scopes
  scope :templates, where(:is_template => true)
  # fields
  field :name, :type => String
  field :is_template, :type => Boolean, :default => false
  # relations
  embeds_many :os_objects
  has_and_belongs_to_many :component_types
  accepts_nested_attributes_for :os_objects, :allow_destroy => true, :reject_if => proc{|attributes| attributes['name'].blank?}
  # validations
  validates :name, :presence => true

  def self.search params
    components = Component.where(:is_template => params[:template] || false)
    types = params[:types] && ComponentType.in(:name => params[:types].split(','))
    components = components.in(:component_type_ids => types.to_a) if types.present?
    components
  end

  def template?
    is_template
  end

  def to_osm
    rt = ""
    os_objects.each{|obj|
      rt += "#{obj.name},\n"
      obj.attrs.each_with_index {|attr, index|
        rt += "  #{attr.value}#{index == obj.attrs.size - 1 ? ';' : ','}\t! #{attr.name}\n"
      }
      rt += $/
    }
    rt
  end

  def sort_os_obj obj_ids
    obj_ids.each_with_index{|id, index|
      if obj = os_objects.find(id)
        obj.order = index
      end
    }
    save
  end

  private
  def process_for_template
    if is_template == true
      os_objects.each{|obj|
        obj.attrs.each{|attribute|
          p attribute
          attribute.update_attributes :value => nil
          p attribute
        }
      }
    end
  end
end

class OsObject
  include Mongoid::Document
  default_scope order_by(:order => :asc)
  field :name, :type => String
  field :order, :type => Integer, :default => 0
  embeds_many :attrs
  embedded_in :component
  accepts_nested_attributes_for :attrs,
    :allow_destroy => true,
    :reject_if => proc{|attributes| attributes['name'].blank? || attributes['value'].blank?}
end

class Attr
  include Mongoid::Document
  field :name, :type => String
  field :value, :type => String
  embedded_in :OsObject
end