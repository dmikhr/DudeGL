require_relative 'lib/dudegl.rb'

params_list1 =   [{ name: "AnotherCollection",
      :methods=>
       [{ name: :initialize, args: 1, length: 3, conditions: 0 },
        { name: :show, args: 0, length: 7, conditions: 2 },
        { name: :render, args: 2, length: 3, conditions: 0 },
        { name: :find, args: 0, length: 9, conditions: 1 }] },

        { name: "OldCollection",
        :methods=>
          [{ name: :initialize, args: 1, length: 3, conditions: 0 },
          { name: :show, args: 0, length: 7, conditions: 2 },
          { name: :render, args: 2, length: 3, conditions: 0 },
          { name: :find, args: 0, length: 9, conditions: 1 }] },
      ]

params_list2 =   [{ name: "AnotherCollection",
      :methods=>
        [{ name: :initialize, args: 2, length: 10, conditions: 1 },
        { name: :show, args: 0, length: 3, conditions: 1 },
        { name: :render, args: 2, length: 3, conditions: 0 },
        { name: :new_method, args: 4, length: 12, conditions: 1 },
        { name: :new_method2, args: 2, length: 3, conditions: 0 }] },

        { name: "NewCollection",
      :methods=>
        [{ name: :initialize, args: 1, length: 3, conditions: 1 },
         { name: :show, args: 0, length: 7, conditions: 2 },
         { name: :render, args: 2, length: 3, conditions: 0 },
         { name: :find, args: 0, length: 9, conditions: 1 }] }]

dudes = DudeGl.new [params_list1, params_list2], dudes_per_row_max: 2, diff: true
dudes.render
dudes.save 'dudes_diff_renamed2'

pp dudes.save_to_string[0..100]
