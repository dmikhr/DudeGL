require_relative '../config'
require_relative 'limbs'

class Legs < Limbs

  private

  def draw
    super

    @limbs_num.times do |i|
      @limbs << Leg.new(@params_methods[i], hx(i), @body.body_right_top_y + Config::BODY_LENGTH)
    end
  end

  def draw_parameters
    return if super
    @legs_step = (((@body.body_right_x - @body.body_left_x) * 0.9) / @limbs_num).round
  end

  def hx(i)
    body_margin = (@body.body_right_x - @body.body_left_x) * 0.1
    (@body.body_left_x + i * @legs_step + body_margin).round
  end
end
