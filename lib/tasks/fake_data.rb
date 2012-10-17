component_types = ComponentType.all
1000.times{
  c = Component.new :name => Faker::Lorem.sentence((1..3).to_a.sample)
  [2,3].sample.times{c.attrs << Attr.new(:name => Component::ATTRIBUTES.sample, :value => rand(100))}
  c.component_types << component_types.all.sample
  c.save
}