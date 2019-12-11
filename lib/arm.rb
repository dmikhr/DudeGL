require_relative 'config'
require_relative 'utils'

class Arm
  include Utils

  attr_reader :end_x, :end_y, :body_side

  def initialize(canvas, params, x0, y0, body_side)
    @canvas = canvas
    @params = params
    @x0 = x0
    @y0 = y0
    @end_y = y0
    @body_side = body_side

    draw_arm
  end

  def draw_arm
    caption = @params[:name]
    length = @params[:length]
    args_num = @params[:args]
    conditions = @params[:conditions]

    length <= Config::METHOD_LENGTH_OK_MAX ? arm_length = Config::ARM_LENGTH : arm_length = Config::ARM_LENGTH_LONG
    arm_length = - arm_length if @body_side == :left
    @end_x = @x0 + arm_length

    if conditions.positive?
      draw_conditions(conditions, arm_length, @x0, @y0, @body_side)
    else
      draw_line(@canvas, @x0, @y0, @x0 + arm_length, @y0)
    end

    draw_caption(@canvas, caption, 0.8 * (@x0 + arm_length).round, (0.95 * @y0).round)
    draw_fingers(args_num)
  end

  def draw_conditions(conditions, arm_length, x0, y0, body_side)
    lines_num = conditions + 1
    line_length = ((arm_length.abs - conditions * Config::ELLIPSE_LENGTH) / lines_num).round
    body_side == :left ? orientation = -1 : orientation = 1

    x0 = x0
    x1 = x0 + line_length * orientation

    lines_num.times do |i|
      draw_line(@canvas, x0, y0, x1, y0)

      @canvas.ellipse cx: (x1 + Config::ELLIPSE_LENGTH * orientation / 2).round,
                      cy: y0, rx: (Config::ELLIPSE_LENGTH / 2).round, ry: (Config::ELLIPSE_LENGTH / 4).round,
                      style: Config::STYLE, fill: 'white' if i < lines_num - 1

      x0 = x0 + (line_length + Config::ELLIPSE_LENGTH) * orientation
      x1 = x0 + line_length * orientation
    end
  end

  def draw_fingers(args_num)
    fingers_range = Math::PI / 2.0

    if body_side == :left
      finger_angle_start = Config::FINGER_ANGLE_START
      finger_angle_end = finger_angle_start + fingers_range
      finger_angle_step = calc_range(fingers_range, args_num)
    else
      finger_angle_start = - Config::FINGER_ANGLE_START + Math::PI
      finger_angle_end = finger_angle_start - fingers_range
      finger_angle_step = - calc_range(fingers_range, args_num)
    end

    args_num.times do |i|
      finger_end_x, finger_end_y = circle_rotate(end_x, end_y, Config::FINGER_LENGTH,
                                                 finger_angle_start + finger_angle_step * i)

      draw_line(@canvas, end_x, end_y, finger_end_x, finger_end_y)
    end
  end
end
