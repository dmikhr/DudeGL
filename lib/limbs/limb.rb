require_relative '../config'

class Limb
  include Utils

  attr_reader :end_x, :end_y, :draw_data

  def initialize(params, x0, y0)
    @params = params
    @x0 = x0
    @end_y = @y0 = y0
    @draw_data = []

    draw
  end

  private

  def draw; end

  def limb_length(length, limit, length_default, length_long)
    length <= limit ? length_default : length_long
  end
end
