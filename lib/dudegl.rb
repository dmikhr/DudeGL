require 'victor'
require 'byebug'
require_relative 'config'
require_relative 'utils'
require_relative 'dude'
require_relative 'arm'

class DudeGl
  include Utils

  def initialize(object)
    # @object = object
    # @width = width
    # @height = height
    # create_canvas
    # @dude = Dude.new(@canvas)
    # draw_arms
  end

  def create_canvas(width = 400, height = 400)
    @canvas = Victor::SVG.new width: width, height: height, style: { background: 'white' }
  end

  def create_dude
    @dude = Dude.new(@canvas)
  end

  def add_arm(canvas, params, x0, y0, body_side)
    arm = Arm.new(canvas, params, x0, y0, body_side)
  end

  def save_to_svg(file_name)
    @canvas.save "#{Config::IMAGE_DIR}/#{file_name}"
  end

  private

  def draw_arms
    arms_draw_parameters
    divide_arms

    @left_arms_num.times do |i|
      hy = (1.05 * @dude.body_left_top_y + i * @arms_step).round
      arm = add_arm(@canvas, @left_arms[i], @dude.body_left_x, hy, :left)
    end

    @right_arms_num.times do |i|
      hy = (1.05 * @dude.body_right_top_y + i * @arms_step).round
      arm = add_arm(@canvas, @right_arms[i], @dude.body_right_x, hy, :right)
    end
  end

  def arms_draw_parameters
    @methods_num = @object[:methods].size
    remainder = @methods_num % 2

    @left_arms_num = (@methods_num - remainder) / 2 + remainder
    @right_arms_num = @methods_num - @left_arms_num

    # BODY_LENGTH * 0.9 - to avoid drawing hands on a body edges
    @arms_step = ((Config::BODY_LENGTH * 0.9) / @left_arms_num).round
  end

  def divide_arms
    @left_arms = @object[:methods][0, @left_arms_num]
    @right_arms = @object[:methods][@left_arms_num, @methods_num]
  end
end
