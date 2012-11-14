require 'carrierwave/mongoid'
class Component
  include Mongoid::Document
  # callbacks
  #before_save :process_for_template
  # scopes
  default_scope order_by(:score => :desc)
  scope :templates, where(:is_template => true)
  # fields
  field :name, :type => String
  field :is_template, :type => Boolean, :default => false
  field :template_type_id, :type => String
  field :score, :type => Float
  # relations
  embeds_many :os_objects
  has_and_belongs_to_many :component_types
  belongs_to :template_type, :class_name => "ComponentType", :inverse_of => :template
  accepts_nested_attributes_for :os_objects, :allow_destroy => true, :reject_if => proc{|attributes| attributes['name'].blank?}
  # validations
  validates :name, :presence => true

  def self.search params
    components = Component.where(:is_template => params[:template] || false)
    types = params[:types] && ComponentType.in(:name => params[:types].split(','))
    components = components.in(:component_type_ids => types.to_a) if types.present?
    components
  end

  # It' very expensive
  def self.generate_score
    ComponentType.all.each{|ct|
      ct.generate_max_score
      ct.generate_min_score
    }
    Component.all.each &:generate_score
  end

  def generate_score
    type = template_type || component_types.first
    if type
      f = os_objects.where(name: "XYZ").first
           .attrs.where(name: "xyz").first
           .value.to_f
      score = f / (type.max_score - type.min_score)
      update_attribute :score, score
    end
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
  accepts_nested_attributes_for :attrs, :allow_destroy => true, :reject_if => proc{|attributes| attributes['name'].blank?}
end

class Attr
  include Mongoid::Document
  field :name, :type => String
  field :value, :type => String
  embedded_in :OsObject
end