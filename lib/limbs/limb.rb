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
end
