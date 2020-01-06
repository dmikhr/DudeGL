require_relative '../utils'
require_relative '../config'

class Body
  include Utils

  attr_reader :body_right_x, :body_right_top_y,
              :body_left_x, :body_left_top_y, :draw_data

  def initialize(name, offsets)
    @name = name
    @draw_data = []
    @offset_x = offsets[:offset_x]
    @offset_y = offsets[:offset_y]
    draw_body
  end

  def draw_body
    # head center
    head_center_x = 0.5 * Config::DUDE_FRAME_SIZE + @offset_x
    head_center_y = 0.3 * Config::DUDE_FRAME_SIZE + @offset_y

    @body_right_x, @body_right_top_y = circle_rotate(head_center_x, head_center_y,
                                                     Config::HEAD_RADIUS,
                                                     Config::BODY_CENTER + Config::SLIM_FACTOR)
    @body_left_x, @body_left_top_y = circle_rotate(head_center_x, head_center_y,
                                                     Config::HEAD_RADIUS,
                                                     Config::BODY_CENTER - Config::SLIM_FACTOR)

    @draw_data << {
      circle: {
      cx: head_center_x,
      cy: head_center_y,
      r: Config::HEAD_RADIUS
      }
    }

    @draw_data << draw_line(@body_right_x, @body_right_top_y,
                            @body_right_x, @body_right_top_y + Config::BODY_LENGTH)
    # left part of a body
    @draw_data << draw_line(@body_left_x, @body_left_top_y,
                            @body_left_x, @body_left_top_y + Config::BODY_LENGTH)
    # bottom
    @draw_data << draw_line(@body_right_x, @body_right_top_y + Config::BODY_LENGTH,
                            @body_left_x, @body_left_top_y + Config::BODY_LENGTH)

    @draw_data << draw_caption(@name, head_center_x - Config::HEAD_RADIUS,
                               head_center_y - 1.1 * Config::HEAD_RADIUS,
                               font_size: 10)
  end
end
