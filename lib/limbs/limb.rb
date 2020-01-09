require_relative '../config'

class Limb
  include Utils

  attr_reader :end_x, :end_y, :draw_data

  def initialize(params, x0, y0, opts = {})
    @params = params
    @x0 = x0
    @end_y = @y0 = y0
    @draw_data = []
    @opts = opts
    @name, @color_limb = process_item(params[:name])
    # if dude is new or was removed - paint everything in green/red since the whole object has been changed
    body_color = apply_body_color(@opts[:body_color]) if @opts.key?(:body_color)
    @color_limb = body_color unless body_color.nil?

    draw
  end

  private

  def draw
    @limb_length = compute_limb_length
  end

  def compute_limb_length
    @params[:length] <= Config::METHOD_LENGTH_OK_MAX ? Config::LIMB_LENGTH * orientation : Config::LIMB_LENGTH_LONG * orientation
  end

  def orientation
    return 1 if @opts[:body_side].nil?
    @opts[:body_side] == :left ? -1 : 1
  end

  def draw_conditions; end

  def set_additional_colors(items, value)
    return [@color_limb] * items if @color_limb == :green || @color_limb == :red
    return value
  end

  def apply_body_color(body_color)
    return body_color if body_color == :green || body_color == :red
  end
end
