require_relative 'limb'

class Arm < Limb
  attr_reader :body_side

  def initialize(params, x0, y0, body_side)
    @body_side = body_side
    super(params, x0, y0)
  end

  private

  def draw
    caption = @params[:name]
    length = @params[:length]
    conditions = @params[:conditions]
    args_num = @params[:args]

    arm_length = limb_length(length, Config::METHOD_LENGTH_OK_MAX,
                             Config::ARM_LENGTH, Config::ARM_LENGTH_LONG)
    arm_length = - arm_length if @body_side == :left
    @end_x = @x0 + arm_length

    if conditions.positive?
      draw_conditions(conditions, arm_length)
    else
      @draw_data << draw_line(@x0, @y0, @x0 + arm_length, @y0)
    end

    @draw_data << draw_caption(caption, (@end_x - 20).round, (@y0 - 10).round)
    draw_fingers(args_num)
  end

  def draw_conditions(conditions, arm_length)
    @lines_num = conditions + 1
    @line_length = ((arm_length.abs - conditions * Config::ELLIPSE_LENGTH) / @lines_num).round
    @body_side == :left ? @orientation = -1 : @orientation = 1

    @x1 = @x0 + @line_length * @orientation

    @lines_num.times { |i| draw_condition(i) }
  end

  def draw_condition(i)
    @draw_data << draw_line(@x0, @y0, @x1, @y0)

    @draw_data << { ellipse: {
                    cx: (@x1 + Config::ELLIPSE_LENGTH * @orientation / 2).round,
                    cy: @y0, rx: (Config::ELLIPSE_LENGTH / 2).round,
                    ry: (Config::ELLIPSE_LENGTH / 4).round }} if i < @lines_num - 1

    @x0 += (@line_length + Config::ELLIPSE_LENGTH) * @orientation
    @x1 = @x0 + @line_length * @orientation
  end

  def draw_fingers(args_num)
    if body_side == :left
      finger_angle_start = Config::FINGER_ANGLE_START
      finger_angle_end = finger_angle_start + Config::FINGERS_RANGE
      finger_angle_step = calc_fingers_range(Config::FINGERS_RANGE, args_num)
    else
      finger_angle_start = - Config::FINGER_ANGLE_START + Math::PI
      finger_angle_end = finger_angle_start - Config::FINGERS_RANGE
      finger_angle_step = - calc_fingers_range(Config::FINGERS_RANGE, args_num)
    end

    args_num.times do |i|
      finger_end_x, finger_end_y = circle_rotate(end_x, end_y, Config::FINGER_LENGTH,
                                                 finger_angle_start + finger_angle_step * i)

      @draw_data << draw_line(end_x, end_y, finger_end_x, finger_end_y)
    end
  end

  def calc_fingers_range(fingers_range, args_num)
    return fingers_range / (args_num - 1).to_f if args_num > 1
    return fingers_range / args_num.to_f if args_num == 1
    return 0
  end
end
