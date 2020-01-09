require_relative 'lib/dudegl.rb'

params_list = [
{:name=>["AnotherCollection", 0], :methods=>[{:name=>[:new_method, 1], :args=>4, :length=>12, :conditions=>1}, {:name=>[:new_method2, 1], :args=>2, :length=>3, :conditions=>0}, {:name=>[:find, -1], :args=>0, :length=>9, :conditions=>1}, {:name=>[:initialize, 0], :args=>[2, 1], :length=>[10, 7], :conditions=>[1, 1]}, {:name=>[:render, 0], :args=>[2, 0], :length=>[3, 0], :conditions=>[0, 0]}]},
{:name=>["DiffCollection", 0], :methods=>[{:name=>[:archive, 1], :args=>5, :length=>3, :conditions=>0}, {:name=>[:initialize, 0], :args=>[2, -2], :length=>10, :conditions=>[1, -1]}, {:name=>[:get_data, 0], :args=>[1, -2], :length=>9, :conditions=>[3, 3]}, {:name=>[:search, -1], :args=>1, :length=>9, :conditions=>1}]},
{:name=>["NewCollection", 1], :methods=>[{:name=>:initialize, :args=>1, :length=>3, :conditions=>0}, {:name=>:show, :args=>0, :length=>7, :conditions=>2}, {:name=>:render, :args=>2, :length=>3, :conditions=>0}, {:name=>:find, :args=>0, :length=>9, :conditions=>1}]},
 {:name=>["OldCollection", -1], :methods=>[{:name=>:initialize, :args=>1, :length=>3, :conditions=>0}, {:name=>:show, :args=>0, :length=>7, :conditions=>2}, {:name=>:render, :args=>2, :length=>3, :conditions=>0}, {:name=>:find, :args=>0, :length=>9, :conditions=>1}]},]

dudes = DudeGl.new params_list, dudes_per_row_max: 2
dudes.render
dudes.save 'dudes_diff'
