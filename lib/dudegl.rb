require 'victor'
require 'byebug'
require_relative 'config'
require_relative 'utils'

class DudeGl
  include Utils

  BODY_LENGTH = 140
  BODY_CENTER = Math::PI * (3 / 2.0)
  # defines how slim is a body
  SLIM_FACTOR = Math::PI * (2 / 8.0)
  HEAD_RADIUS = 40

  METHOD_LENGTH_OK_MAX = 5
  ARM_LENGTH = 40
  ARM_LENGTH_LONG = 70
  ELLIPSE_LENGTH = 10

  FINGER_LENGTH = 10
  FINGER_ANGLE_START = Math::PI * (3 / 4.0)

  def initialize(object, width = 400, height = 400)
    @object = object
    @width = width
    @height = height
    create_canvas
    draw_dude
    draw_arms
  end

  def save_to_svg(file_name)
    @canvas.save "#{Config::IMAGE_DIR}/#{file_name}"
  end

  private

  def create_canvas
    @canvas = Victor::SVG.new width: @width, height: @height, style: { background: 'white' }
  end

  def draw_dude
    # head center
    head_center_x = (0.5 * @width).round
    head_center_y = (0.3 * @height).round

    @body_right_x, @body_right_top_y = circle_rotate(head_center_x, head_center_y,
                                                     HEAD_RADIUS, BODY_CENTER + SLIM_FACTOR)
    @body_left_x, @body_left_top_y = circle_rotate(head_center_x, head_center_y,
                                                   HEAD_RADIUS, BODY_CENTER - SLIM_FACTOR)
    # head
    @canvas.circle cx: head_center_x, cy: head_center_y, r: HEAD_RADIUS,
                fill: 'white', style: Config::STYLE
    # right part of a body
    draw_line(@canvas, @body_right_x, @body_right_top_y,
              @body_right_x, @body_right_top_y + BODY_LENGTH)
    # left part of a body
    draw_line(@canvas, @body_left_x, @body_left_top_y,
              @body_left_x, @body_left_top_y + BODY_LENGTH)
    # bottom
    draw_line(@canvas, @body_right_x, @body_right_top_y + BODY_LENGTH,
              @body_left_x, @body_left_top_y + BODY_LENGTH)
  end

  def draw_arm(side_arms, x0, y0, body_side)
    method_name = side_arms[:name]
    length = side_arms[:length]
    args_num = side_arms[:args]
    conditions = side_arms[:conditions]

    length <= METHOD_LENGTH_OK_MAX ? arm_length = ARM_LENGTH : arm_length = ARM_LENGTH_LONG
    arm_length = - arm_length if body_side == :left

    if conditions.positive?
      draw_conditions(conditions, arm_length, x0, y0, body_side)
    else
      draw_line(@canvas, x0, y0, x0 + arm_length, y0)
    end

    draw_caption(@canvas, method_name, 0.8 * (x0 + arm_length).round, (0.95 * y0).round)
    draw_fingers(args_num, x0 + arm_length, y0, body_side)
  end

  def draw_arms
    arms_draw_parameters
    divide_arms

    @left_arms_num.times do |i|
      hy = (1.05 * @body_left_top_y + i * @arms_step).round
      draw_arm(@left_arms[i], @body_left_x, hy, :left)
    end

    @right_arms_num.times do |i|
      hy = (1.05 * @body_right_top_y + i * @arms_step).round
      draw_arm(@right_arms[i], @body_right_x, hy, :right)
    end
  end

  def draw_conditions(conditions, arm_length, x0, y0, body_side)
    lines_num = conditions + 1
    line_length = ((arm_length.abs - conditions * ELLIPSE_LENGTH) / lines_num).round
    body_side == :left ? orientation = -1 : orientation = 1

    x0 = x0
    x1 = x0 + line_length * orientation

    lines_num.times do |i|
      draw_line(@canvas, x0, y0, x1, y0)

      @canvas.ellipse cx: (x1 + ELLIPSE_LENGTH * orientation / 2).round,
                      cy: y0, rx: (ELLIPSE_LENGTH / 2).round, ry: (ELLIPSE_LENGTH / 4).round,
                      style: Config::STYLE, fill: 'white' if i < lines_num - 1

      x0 = x0 + (line_length + ELLIPSE_LENGTH) * orientation
      x1 = x0 + line_length * orientation
    end
  end

  def arms_draw_parameters
    @methods_num = @object[:methods].size
    remainder = @methods_num % 2

    @left_arms_num = (@methods_num - remainder) / 2 + remainder
    @right_arms_num = @methods_num - @left_arms_num

    # BODY_LENGTH * 0.9 - to avoid drawing hands on a body edges
    @arms_step = ((BODY_LENGTH * 0.9) / @left_arms_num).round
  end

  def divide_arms
    @left_arms = @object[:methods][0, @left_arms_num]
    @right_arms = @object[:methods][@left_arms_num, @methods_num]
  end

  def draw_fingers(args_num, arm_end_x, arm_end_y, body_side)
    fingers_range = Math::PI / 2.0

    if body_side == :left
      finger_angle_start = FINGER_ANGLE_START
      finger_angle_end = finger_angle_start + fingers_range
      finger_angle_step = calc_range(fingers_range, args_num)
    else
      finger_angle_start = - FINGER_ANGLE_START + Math::PI
      finger_angle_end = finger_angle_start - fingers_range
      finger_angle_step = - calc_range(fingers_range, args_num)
    end

    args_num.times do |i|
      finger_end_x, finger_end_y = circle_rotate(arm_end_x, arm_end_y, FINGER_LENGTH,
                                                 finger_angle_start + finger_angle_step * i)
      draw_line(@canvas, arm_end_x, arm_end_y, finger_end_x, finger_end_y)
    end
  end
end
