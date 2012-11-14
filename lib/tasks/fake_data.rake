require 'faker'

namespace :faker  do
  desc "create some fake data"
  task :components => :environment do
    print "How many fake component do you want?"
    num = $stdin.gets.to_i
    component_types = ComponentType.all
    num.times{
      c = Component.new :name => Faker::Lorem.sentence((1..3).to_a.sample)
      [2,4].sample.times{
        os_obj = OsObject.new :name => "OS:#{Faker::Lorem.sentence([1,2].sample)}"
        [2,4].sample.times{os_obj.attrs << Attr.new(:name => Faker::Lorem.sentence([1,2].sample), :value => rand(100))}
        c.os_objects << os_obj
      }
      c.component_types << component_types.all.sample
      c.save
    }
    print "#{num} created.\n"
  end
end

# 10.times{ComponentType.create :name => Faker::Lorem.sentence((1..3).to_a.sample)}