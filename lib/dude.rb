require_relative 'utils'
require_relative 'config'

class Dude
  include Utils

  attr_reader :body_right_x, :body_right_top_y, :body_left_x, :body_left_top_y

  def initialize(canvas, width = 400, height = 400)
    @width = width
    @height = height
    @canvas = canvas
    draw_dude
  end

  def draw_dude
    # head center
    head_center_x = (0.5 * @width).round
    head_center_y = (0.3 * @height).round

    @body_right_x, @body_right_top_y = circle_rotate(head_center_x, head_center_y,
                                                     Config::HEAD_RADIUS,
                                                     Config::BODY_CENTER + Config::SLIM_FACTOR)
    @body_left_x, @body_left_top_y = circle_rotate(head_center_x, head_center_y,
                                                   Config::HEAD_RADIUS,
                                                   Config::BODY_CENTER - Config::SLIM_FACTOR)
    # head
    @canvas.circle cx: head_center_x, cy: head_center_y, r: Config::HEAD_RADIUS,
                fill: 'white', style: Config::STYLE
    # right part of a body
    draw_line(@canvas, @body_right_x, @body_right_top_y,
              @body_right_x, @body_right_top_y + Config::BODY_LENGTH)
    # left part of a body
    draw_line(@canvas, @body_left_x, @body_left_top_y,
              @body_left_x, @body_left_top_y + Config::BODY_LENGTH)
    # bottom
    draw_line(@canvas, @body_right_x, @body_right_top_y + Config::BODY_LENGTH,
              @body_left_x, @body_left_top_y + Config::BODY_LENGTH)
  end
end
