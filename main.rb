require_relative 'lib/dudes.rb'

params_list = [{ name: "ThingCollection",
  :methods=>
   [{ name: :initialize, args: 2, length: 2, conditions: 0 },
    { name: :all_types, args: 0, length: 6, conditions: 2 },
    { name: :one_type_things, args: 6, length: 9, conditions: 0 },
    { name: :one_thing_by_type, args: 3, length: 9, conditions: 0 },
    { name: :weather_clothing, args: 4, length: 10, conditions: 0 },
    { name: :message, args: 0, length: 10, conditions: 1 },
    { name: :signal, args: 5, length: 10, conditions: 4 }] },

    { name: "AnotherCollection",
      :methods=>
       [{ name: :initialize, args: 1, length: 1, conditions: 0 },
        { name: :show, args: 0, length: 7, conditions: 2 },
        { name: :render, args: 2, length: 3, conditions: 0 },
        { name: :find, args: 0, length: 9, conditions: 1 }] },

      { name: "SomeClass",
        :methods=>
          [{ name: :initialize, args: 3, length: 4, conditions: 0 },
          { name: :scan, args: 0, length: 5, conditions: 1 },
          { name: :compute, args: 4, length: 4, conditions: 1 }] }
  ]


dudes = Dudes.new params_list
dudes.render
dudes.save 'dudes'
