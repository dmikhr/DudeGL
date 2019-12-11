# custom logic of drawing arms using dudegl API
class DrawArms

  def initialize(object, canvas, dude, dudegl)
    @object = object
    @canvas = canvas
    @dude = dude
    @dudegl = dudegl
    draw_arms
  end

  def draw_arms
    arms_draw_parameters
    divide_arms

    @left_arms_num.times do |i|
      @dudegl.add_arm(@canvas, @left_arms[i], @dude.body_left_x, hy(i), :left)
    end

    @right_arms_num.times do |i|
       @dudegl.add_arm(@canvas, @right_arms[i], @dude.body_right_x, hy(i), :right)
    end
  end

  def arms_draw_parameters
    @methods_num = @object[:methods].size
    remainder = @methods_num % 2

    @left_arms_num = (@methods_num - remainder) / 2 + remainder
    @right_arms_num = @methods_num - @left_arms_num

    # BODY_LENGTH * 0.9 - to avoid drawing hands on a body edges
    @arms_step = ((140 * 0.9) / @left_arms_num).round
  end

  def divide_arms
    @left_arms = @object[:methods][0, @left_arms_num]
    @right_arms = @object[:methods][@left_arms_num, @methods_num]
  end

  def hy(i)
    (1.05 * @dude.body_left_top_y + i * @arms_step).round
  end
end
