class ComponentType
  include Mongoid::Document
  field :name, :type => String
  has_and_belongs_to_many :components
  validates :name, :presence => true
end
