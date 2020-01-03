require_relative '../config'
require_relative 'limbs'

class Arms < Limbs

  private

  def draw
    super
    divide_arms

    @left_arms_num.times do |i|
      @limbs << Arm.new(@left_arms[i], @body.body_left_x, hy(i), body_side: :left)
    end

    @right_arms_num.times do |i|
       @limbs << Arm.new(@right_arms[i], @body.body_right_x, hy(i), body_side: :right)
    end
  end

  def draw_parameters
    return if super

    remainder = @limbs_num % 2

    @left_arms_num = (@limbs_num - remainder) / 2 + remainder
    @right_arms_num = @limbs_num - @left_arms_num

    # BODY_LENGTH * 0.9 - to avoid drawing hands on a body edges
    @arms_step = ((Config::BODY_LENGTH * 0.9) / @left_arms_num).round
  end

  def divide_arms
    @left_arms = @params_methods[0, @left_arms_num]
    @right_arms = @params_methods[@left_arms_num, @limbs_num]
  end

  def hy(i)
    (1.05 * @body.body_left_top_y + i * @arms_step).round
  end
end
