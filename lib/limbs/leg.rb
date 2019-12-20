require_relative 'limb'

class Leg < Limb

  private

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

    @draw_data << draw_caption(caption, (@x0 + 10).round, (@y0 + 10).round, 9, :tb)
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
