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
end
