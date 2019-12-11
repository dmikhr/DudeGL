require_relative 'config'

module Utils
  def circle_rotate(center_x, center_y, r, rotation)
    x_rotated = center_x + r * Math.cos(rotation)
    y_rotated = center_y - r * Math.sin(rotation)
    return [x_rotated, y_rotated]
  end

  def calc_range(fingers_range, args_num)
    return fingers_range / (args_num - 1).to_f if args_num > 1
    return fingers_range / args_num.to_f if args_num == 1
    return 0
  end

  def draw_line(svg, x1, y1, x2, y2)
    svg.line x1: x1, y1: y1, x2: x2, y2: y2, style: Config::STYLE
  end

  def draw_caption(svg, caption, x, y)
    svg.text caption, x: x, y: y, font_family: 'arial', font_size: 9, fill: 'black'
  end
end
