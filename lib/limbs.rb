require_relative 'config'

class Limb
  include Utils

  attr_reader :end_x, :end_y, :draw_data

  def initialize(params, x0, y0)
    @params = params
    @x0 = x0
    @y0 = y0
    @end_y = y0
    @draw_data = []

    draw
  end

  def draw; end
end

class Arm < Limb
  attr_reader :body_side

  def initialize(params, x0, y0, body_side)
    @body_side = body_side
    super(params, x0, y0)
  end

  def draw
    caption = @params[:name]
    length = @params[:length]
    conditions = @params[:conditions]
    args_num = @params[:args]

    length <= Config::METHOD_LENGTH_OK_MAX ? arm_length = Config::ARM_LENGTH : arm_length = Config::ARM_LENGTH_LONG
    arm_length = - arm_length if @body_side == :left
    @end_x = @x0 + arm_length

    if conditions.positive?
      draw_conditions(conditions, arm_length, @x0, @y0, @body_side)
    else
      @draw_data << draw_line(@x0, @y0, @x0 + arm_length, @y0)
    end

    @draw_data << draw_caption(caption, 0.8 * (@x0 + arm_length).round, (0.95 * @y0).round)
    draw_fingers(args_num)
  end

  def draw_conditions(conditions, arm_length, x0, y0, body_side)
    lines_num = conditions + 1
    line_length = ((arm_length.abs - conditions * Config::ELLIPSE_LENGTH) / lines_num).round
    body_side == :left ? orientation = -1 : orientation = 1

    x0 = x0
    x1 = x0 + line_length * orientation

    lines_num.times do |i|
      @draw_data << draw_line(x0, y0, x1, y0)

      @draw_data << { ellipse: {
        cx: (x1 + Config::ELLIPSE_LENGTH * orientation / 2).round,
                        cy: y0, rx: (Config::ELLIPSE_LENGTH / 2).round, ry: (Config::ELLIPSE_LENGTH / 4).round
        }} if i < lines_num - 1

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

      @draw_data << draw_line(end_x, end_y, finger_end_x, finger_end_y)
    end
  end
end

class Leg < Limb
  def draw
    caption = @params[:name]
    length = @params[:length]
    conditions = @params[:conditions]
    args_num = @params[:args]

    length <= Config::METHOD_LENGTH_OK_MAX ? leg_length = Config::LEG_LENGTH : leg_length = Config::LEG_LENGTH_LONG

    if conditions.positive?
      draw_conditions(conditions, leg_length, @x0, @y0)
    else
      @draw_data << draw_line(@x0, @y0, @x0, @y0 + leg_length)
    end

    @draw_data << draw_caption(caption, 1.05 * @x0.round, (1.02 * @y0).round, 9, :tb)
  end

  def draw_conditions(conditions, leg_length, x0, y0)
    lines_num = conditions + 1
    line_length = ((leg_length.abs - conditions * Config::ELLIPSE_LENGTH) / lines_num).round

    y1 = y0 + line_length

    lines_num.times do |i|
      @draw_data << draw_line(x0, y0, x0, y0 + line_length)

      @draw_data << { ellipse: {
        cx: x0, cy: (y1 + Config::ELLIPSE_LENGTH / 2).round , rx: (Config::ELLIPSE_LENGTH / 4).round, ry: (Config::ELLIPSE_LENGTH / 2).round
        }} if i < lines_num - 1

      y0 = y0 + line_length + Config::ELLIPSE_LENGTH / 4
      y1 = y0 + line_length
    end
  end
end
