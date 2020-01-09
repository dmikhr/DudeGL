require_relative '../config'
require_relative 'limbs'

class Arms < Limbs

  private

  def draw
    super
    divide_arms

    @left_arms_num.times { |i| draw_arms_on_side(@left_arms[i], i, :left) }
    @right_arms_num.times { |i| draw_arms_on_side(@right_arms[i], i, :right) }
  end

  def draw_arms_on_side(side_arms, i, body_side)
    body_side == :left ? body_x = @body.body_left_x : body_x = @body.body_right_x

    if arm_size_changed?(side_arms[:length])
      side_arms_initial = side_arms.dup
      side_arms[:length] = side_arms[:length].first
      side_arms[:name] = change_arm_name_param(side_arms[:name], 1)
      @limbs << Arm.new(side_arms, body_x, hy(i), body_side: body_side, body_color: @body_color)

      side_arms = side_arms_initial
      side_arms[:name] = change_arm_name_param(side_arms[:name], -1)
      side_arms[:length] = side_arms[:length].first - side_arms[:length].last
      @limbs << Arm.new(side_arms, body_x, hy_same_arm(i), body_side: body_side, body_color: @body_color)
    else
      side_arms[:length] = arm_length_value(side_arms[:length])
      @limbs << Arm.new(side_arms, body_x, hy(i), body_side: body_side, body_color: @body_color)
    end
  end

  def change_arm_name_param(name, param)
    if name.class == Array
      name[1] = param
      return name
    end

    return [name, value]
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

  def hy_same_arm(i)
    (1.05 * @body.body_left_top_y + (i + 1) * 0.5 * @arms_step).round
  end

  def arm_length_value(item)
    return item.first if item.class == Array
    return item
  end

  def arm_size_changed?(length_params)
    if length_params.class == Array
      current_length = length_params.first
      delta = length_params.last

      current_length_short = current_length <= Config::METHOD_LENGTH_OK_MAX
      previous_length_short = current_length - delta <= Config::METHOD_LENGTH_OK_MAX
      changed = (current_length_short != previous_length_short)

      return changed
    end

    return false
  end
end
