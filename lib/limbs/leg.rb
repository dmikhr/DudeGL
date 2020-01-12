require_relative 'limb'

class Leg < Limb

  private

  def draw
    super
    caption_start_x = @x0
    caption_y_start = @y0

    if @params[:conditions].positive?
      draw_conditions
    else
      @draw_data << draw_line(@x0, @y0, @x0, @y0 + @limb_length)
    end

    @draw_data << draw_caption(@params[:name], (caption_start_x + 10).round, (caption_y_start + 10).round, 9, :tb)
  end

  def draw_conditions
    @lines_num = @params[:conditions] + 1
    @line_length = ((@limb_length.abs - @params[:conditions] * Config::ELLIPSE_LENGTH) / @lines_num).round

    @y1 = @y0 + @line_length

    @lines_num.times { |i| draw_condition(i) }
  end

  def draw_condition(i)
    @draw_data << draw_line(@x0, @y0, @x0, @y1)

    @draw_data << draw_ellipse(cx = @x0, cy = (@y1 + Config::ELLIPSE_LENGTH / 2),
                              rx = (Config::ELLIPSE_LENGTH / 4),
                              ry = (Config::ELLIPSE_LENGTH / 2)) if i < @lines_num - 1

    @y0 += @line_length + Config::ELLIPSE_LENGTH
    @y1 = @y0 + @line_length
  end
end
