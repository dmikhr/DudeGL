require_relative 'utils'
require_relative 'config'

class Body
  include Utils

  attr_reader :body_right_x, :body_right_top_y, :body_left_x, :body_left_top_y, :draw_data

  def initialize(name, offset_x = 0, offset_y = 0)
    @name = name
    @draw_data = []
    @offset_x = offset_x
    @offset_y = offset_y
    draw_body
  end

  def draw_body
    # head center
    head_center_x = 0.5 * Config::DUDE_FRAME_SIZE + @offset_x
    head_center_y = 0.3 * Config::DUDE_FRAME_SIZE + @offset_y

    @body_right_x, @body_right_top_y = circle_rotate(head_center_x, head_center_y,
                                                     Config::HEAD_RADIUS,
                                                     Config::BODY_CENTER + Config::SLIM_FACTOR)
    @body_left_x, @body_left_top_y = circle_rotate(head_center_x, head_center_y,
                                                     Config::HEAD_RADIUS,
                                                     Config::BODY_CENTER - Config::SLIM_FACTOR)

    @draw_data << {
      circle: {
      cx: head_center_x,
      cy: head_center_y,
      r: Config::HEAD_RADIUS
      }
    }

    @draw_data << draw_line(@body_right_x, @body_right_top_y,
              @body_right_x, @body_right_top_y + Config::BODY_LENGTH)
    # left part of a body
    @draw_data << draw_line(@body_left_x, @body_left_top_y,
              @body_left_x, @body_left_top_y + Config::BODY_LENGTH)
    # bottom
    @draw_data << draw_line(@body_right_x, @body_right_top_y + Config::BODY_LENGTH,
              @body_left_x, @body_left_top_y + Config::BODY_LENGTH)

    @draw_data << draw_caption(@name, 0.6 * head_center_x,
                              (0.95 * (head_center_y - Config::HEAD_RADIUS)),
                              font_size: 10)
  end
end


class DrawLimbs
  attr_reader :limbs

  def initialize(params, body)
    @params = params
    @body = body

    draw
  end

  private

  def draw
    draw_parameters
  end

  def draw_parameters; end
end

class DrawArms < DrawLimbs

  attr_reader :arms

  def initialize(params, body)
    @arms = []
    super(params, body)
  end

  private

  def draw
    super
    divide_arms

    @left_arms_num.times do |i|
      @arms << Arm.new(@left_arms[i], @body.body_left_x, hy(i), :left)
    end

    @right_arms_num.times do |i|
       @arms << Arm.new(@right_arms[i], @body.body_right_x, hy(i), :right)
    end
  end

  def draw_parameters
    @params_methods = @params[:methods].select { |param| param[:args] > 0 }
    @arms_num = @params_methods.size

    remainder = @arms_num % 2

    @left_arms_num = (@arms_num - remainder) / 2 + remainder
    @right_arms_num = @arms_num - @left_arms_num

    # BODY_LENGTH * 0.9 - to avoid drawing hands on a body edges
    @arms_step = ((Config::BODY_LENGTH * 0.9) / @left_arms_num).round
  end

  def divide_arms
    @left_arms = @params_methods[0, @left_arms_num]
    @right_arms = @params_methods[@left_arms_num, @arms_num]
  end

  def hy(i)
    (1.05 * @body.body_left_top_y + i * @arms_step).round
  end
end

class DrawLegs < DrawLimbs
  attr_reader :legs

  def initialize(params, body)
    @legs = []
    super(params, body)
  end

  private

  def draw
    super

    @legs_num.times do |i|
      @legs << Leg.new(@params_methods[i], hx(i), @body.body_right_top_y + Config::BODY_LENGTH)
    end
  end

  def draw_parameters
    @params_methods = @params[:methods].select { |param| param[:args] == 0 }
    @legs_num = @params_methods.size

    @legs_step = (((@body.body_right_x - @body.body_left_x) * 0.9) / @legs_num).round
  end

  def hx(i)
    (1.05 * @body.body_left_x + i * @legs_step).round
  end
end
