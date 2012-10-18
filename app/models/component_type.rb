class ComponentType
  include Mongoid::Document
  scope :roots, where(:parent => nil)
  field :name, :type => String
  has_and_belongs_to_many :components
  belongs_to :parent, :class_name => "ComponentType"
  has_many :children, :class_name => "ComponentType", :foreign_key => :parent_id
  validates :name, :presence => true

  def self.post_order root, level = 1, &block
    yield root, level
    level += 1
    root.children.each do |child|
      ComponentType.post_order(child, level, &block)
    end
  end

  def post_order &block
    ComponentType.post_order(self, &block)
  end
end
