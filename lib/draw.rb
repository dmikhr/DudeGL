require_relative 'utils'
require_relative 'config'

# arrange several dudes on canvas
class LocateDudes
  attr_reader :offsets, :canvas_size_x, :canvas_size_y

  def initialize(params_list)
    @dudes_num = params_list.size
    @offsets = []

    compute_dudes_coordiantes
    compute_canvas_size
  end

  private

  # returns array with number of dudes in each row
  # e.g. if we have 12 dudes and only 5 are allowed per row, then the output will be [5, 5, 2])
  def compute_dudes_per_each_row
    remaining_dudes = @dudes_num % Config::DUDES_PER_ROW_MAX
    rows_num = (@dudes_num - remaining_dudes) / Config::DUDES_PER_ROW_MAX
    full_rows = [Config::DUDES_PER_ROW_MAX] * rows_num
    remaining_dudes > 0 ? full_rows + [remaining_dudes]: full_rows
  end

  def compute_dudes_coordiantes
    @dudes_per_each_row = compute_dudes_per_each_row
    offset_y = 0
    @dudes_per_each_row.each_with_index do |dudes_in_row, y_index|
      dudes_in_row.times do |x_index|
        @offsets << { offset_x: x_index * Config::OFFSET_X, offset_y: y_index * Config::OFFSET_Y }
      end
    end
  end

  def compute_canvas_size
    #  max x size of canvas is x offset for the last dude in 1st row - @dudes_per_each_row.first - 1
    # @offsets.last[:offset_y] - last dude has max y offset
    @canvas_size_x = @offsets[@dudes_per_each_row.first - 1][:offset_x] + Config::DUDE_FRAME_SIZE
    @canvas_size_y = @offsets.last[:offset_y] + Config::DUDE_FRAME_SIZE
  end
end

class Body
  include Utils

  attr_reader :body_right_x, :body_right_top_y, :body_left_x, :body_left_top_y, :draw_data

  def initialize(name, offsets)
    @name = name
    @draw_data = []
    @offset_x = offsets[:offset_x]
    @offset_y = offsets[:offset_y]
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

    @draw_data << draw_caption(@name, head_center_x - Config::HEAD_RADIUS,
                               head_center_y - 1.1 * Config::HEAD_RADIUS,
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
