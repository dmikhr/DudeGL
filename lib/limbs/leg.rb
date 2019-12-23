require_relative 'limb'

class Leg < Limb

  private

  def draw
    super

    if @params[:conditions].positive?
      draw_conditions(@params[:conditions], @limb_length, @x0, @y0)
    else
      @draw_data << draw_line(@x0, @y0, @x0, @y0 + @limb_length)
    end

    @draw_data << draw_caption(@params[:name], (@x0 + 10).round, (@y0 + 10).round, 9, :tb)
  end

  def draw_conditions(conditions, limb_length, x0, y0)
    lines_num = conditions + 1
    line_length = ((limb_length.abs - conditions * Config::ELLIPSE_LENGTH) / lines_num).round

    y1 = y0 + line_length

    lines_num.times do |i|
      @draw_data << draw_line(x0, y0, x0, y1)

      @draw_data << { ellipse: {
        cx: x0, cy: (y1 + Config::ELLIPSE_LENGTH / 2).round ,
        rx: (Config::ELLIPSE_LENGTH / 4).round, ry: (Config::ELLIPSE_LENGTH / 2).round
        }} if i < lines_num - 1

      y0 += line_length + Config::ELLIPSE_LENGTH
      y1 = y0 + line_length
    end
  end
end
