require 'victor'
require_relative 'dude'
require_relative 'arm'

class DudeGl
  def create_canvas(width = 400, height = 400)
    @canvas = Victor::SVG.new width: width, height: height, style: { background: 'white' }
  end

  def create_dude
    Dude.new(@canvas)
  end

  def add_arm(params, x0, y0, body_side)
    Arm.new(@canvas, params, x0, y0, body_side)
  end

  def save_to_svg(file_name)
    @canvas.save "#{Config::IMAGE_DIR}/#{file_name}"
  end
end
