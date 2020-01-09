# require_relative 'config'

module Utils
  def circle_rotate(center_x, center_y, r, rotation)
    x_rotated = center_x + r * Math.cos(rotation)
    y_rotated = center_y - r * Math.sin(rotation)
    return [x_rotated, y_rotated]
  end

  def draw_line(x1, y1, x2, y2, color = :black)
    { line: { x1: x1, y1: y1, x2: x2, y2: y2, color: color } }
  end

  def draw_caption(caption, x, y, font_size = 9, orientation = :lr, color = :black)
    { text: { x: x, y: y, caption: caption, font_size: font_size, orientation: orientation, color: color } }
  end

  def draw_circle(head_center_x, head_center_y, r, color = :black)
    { circle: { cx: head_center_x, cy: head_center_y, r: r, color: color } }
  end

  def draw_ellipse(cx, cy, rx, ry, color = :black)
    { ellipse: { cx: cx, cy: cy, rx: rx, ry: ry, color: color } }
  end

  def set_color(color_id)
    return :red if color_id == -1
    return :green if color_id == 1
    return :black
  end

  def process_item(item)
    # for item like ['new_method', 1]
    if item.class == Array
      name = item.first
      color = set_color(item.last)

      return [name, color]
    end
    # 'new_method'
    return [item, :black]
  end

  def process_item_set(item)
    return [:black] * item unless item.class == Array

    current_num = item.first
    delta = item.last
    return [:black] * current_num if delta == 0

    if delta > 0
      colors_changed = [:green] * delta
      colors_unchanged = [:black] * (current_num - delta)
    elsif delta < 0
      colors_changed = [:red] * delta.abs
      colors_unchanged = [:black] * current_num
    end

    return colors_changed + colors_unchanged
  end
end
