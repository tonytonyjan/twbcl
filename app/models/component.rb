require 'carrierwave/mongoid'
class Component
  include Mongoid::Document
  field :name, :type => String
  embeds_many :os_objects
  has_and_belongs_to_many :component_types
  accepts_nested_attributes_for :os_objects, :allow_destroy => true
  validates :name, :presence => true
end

class OsObject
  include Mongoid::Document
  field :name, :type => String
  embeds_many :attrs
  accepts_nested_attributes_for :attrs,
    :allow_destroy => true,
    :reject_if => proc { |attributes| attributes['name'].blank? || attributes['value'].blank? }
end

class Attr
  include Mongoid::Document
  field :name, :type => String
  field :value, :type => String
  embedded_in :OsObject
end