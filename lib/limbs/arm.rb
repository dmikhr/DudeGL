require_relative 'limb'

class Arm < Limb

  private

  def draw
    super
    @end_x = @x0 + @limb_length

    @condition_colors = process_item_set(@params[:conditions])
    @conditions = @condition_colors.size
    @condition_colors = set_additional_colors(@conditions, @condition_colors)

    if @conditions.positive?
      draw_conditions
    else
      @draw_data << draw_line(@x0, @y0, @x0 + @limb_length, @y0, @color_limb)
    end

    @draw_data << draw_caption(@name, (@end_x - 20).round, (@y0 - 10).round, 10, :lr, @color_limb)

    @color_fingers = process_item_set(@params[:args])
    @args = @color_fingers.size
    @color_fingers = set_additional_colors(@args, @color_fingers)
    draw_fingers
  end

  def draw_conditions
    @lines_num = @conditions + 1
    @line_length = ((@limb_length.abs - @conditions * Config::ELLIPSE_LENGTH) / @lines_num).round

    @x1 = @x0 + @line_length * orientation

    @lines_num.times { |i| draw_condition(i) }
  end

  def draw_condition(i)
    @draw_data << draw_line(@x0, @y0, @x1, @y0, @color_limb)

    @draw_data << draw_ellipse(cx = (@x1 + Config::ELLIPSE_LENGTH * orientation / 2), cy = @y0,
                              rx = (Config::ELLIPSE_LENGTH / 2),
                              ry = (Config::ELLIPSE_LENGTH / 4), @condition_colors[i]) if i < @lines_num - 1

    @x0 += (@line_length + Config::ELLIPSE_LENGTH) * orientation
    @x1 = @x0 + @line_length * orientation
  end

  def draw_fingers
    if @opts[:body_side] == :left
      finger_angle_start = Config::FINGER_ANGLE_START
      finger_angle_end = finger_angle_start + Config::FINGERS_RANGE
      finger_angle_step = calc_fingers_range
    else
      finger_angle_start = - Config::FINGER_ANGLE_START + Math::PI
      finger_angle_end = finger_angle_start - Config::FINGERS_RANGE
      finger_angle_step = - calc_fingers_range
    end

    @args.times do |i|
      finger_end_x, finger_end_y = circle_rotate(end_x, end_y, Config::FINGER_LENGTH,
                                                 finger_angle_start + finger_angle_step * i)

      @draw_data << draw_line(end_x, end_y, finger_end_x, finger_end_y, @color_fingers[i])
    end
  end

  def calc_fingers_range
    return Config::FINGERS_RANGE / (@args - 1).to_f if @args > 1
    return Config::FINGERS_RANGE / @args.to_f if @args == 1
    return 0
  end
end
