class ComponentType
  include Mongoid::Document
  scope :roots, where(:parent => nil)
  field :name, :type => String
  field :average_score, :type => Float
  field :max_score, :type => Float
  field :min_score, :type => Float
  has_and_belongs_to_many :components
  belongs_to :parent, :class_name => "ComponentType"
  has_many :children, :class_name => "ComponentType", :foreign_key => :parent_id
  has_one :template, :class_name => "Component", :inverse_of => :template_type
  validates :name, :presence => true

  def self.post_order root, level = 1, &block
    yield root, level
    level += 1
    root.children.each do |child|
      ComponentType.post_order(child, level, &block)
    end
  end

  def self.calculate_average_score
    ComponentType.all.each &:calculate_average_score
  end
  
  def calculate_average_score
    sum = components.sum{|c|
      c.os_objects.where(name: "XYZ").first
       .attrs.where(name: "xyz").first
       .value.to_f
    }
    avg = sum/components.count
    update_attribute(:average_score, avg)
  end

  def generate_max_score
    components.all.each{|c|
      f = c.os_objects.where(name: "XYZ").first
       .attrs.where(name: "xyz").first
       .value.to_f
      @max ||= f
      @max = f if f > @max
    }
    update_attribute :max_score, @max
  end

  def generate_min_score
    components.all.each{|c|
      f = c.os_objects.where(name: "XYZ").first
       .attrs.where(name: "xyz").first
       .value.to_f
      @min ||= f
      @min = f if f < @min
    }
    update_attribute :min_score, @min
  end

  def post_order &block
    ComponentType.post_order(self, &block)
  end
end
