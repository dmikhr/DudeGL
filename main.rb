require_relative 'lib/dudegl.rb'

object = {:name=>"ThingCollection",
  :methods=>
   [{:name=>:initialize, :args=>3, :length=>2, :conditions=>0},
    {:name=>:all_types, :args=>0, :length=>5, :conditions=>2},
    {:name=>:one_type_things, :args=>6, :length=>9, :conditions=>0},
    {:name=>:one_thing_by_type, :args=>2, :length=>9, :conditions=>0},
    {:name=>:weather_clothing, :args=>4, :length=>10, :conditions=>0},
    {:name=>:message, :args=>1, :length=>6, :conditions=>1},
    {:name=>:signal, :args=>5, :length=>10, :conditions=>4}],
  :references=>["Dir", "Thing"]}

visual = DudeGl.new(object)

visual.save_to_svg "dude_test"
