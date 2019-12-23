require_relative '../config'

class DrawLegs < DrawLimbs

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
    (1.05 * @body.body_left_x + i * @legs_step).round
  end
end
