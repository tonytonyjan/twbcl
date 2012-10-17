class Component
  ATTRIBUTES = [
    "Design Level {W}",
    "Watts per Zone Floor Area {W/m2}",
    "Watts per Person {W/person}",
    "Fraction Latent",
    "Return Air Fraction",
    "Fraction Radiant",
    "Fraction Visible",
    "Fraction Replaceable",
    "End-Use Subcategory",
    "Return Air Fraction Calculated from Plenum Temperature",
    "Return Air Fraction Function of Plenum Temperature Coefficient 1",
    "Return Air Fraction Function of Plenum Temperature Coefficient 2",
  ]
  include Mongoid::Document
  field :name, :type => String
  embeds_many :attrs
  has_and_belongs_to_many :component_types
  accepts_nested_attributes_for :attrs,
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes['name'].blank? || attributes['value'].blank? }
  validates :name, :presence => true
end

class Attr
  include Mongoid::Document
  field :name, :type => String
  field :value, :type => String
  embedded_in :Component
end