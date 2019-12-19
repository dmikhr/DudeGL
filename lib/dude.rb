require 'byebug'
require_relative 'utils'
require_relative 'config'
require_relative 'draw'
require_relative 'limbs'
require_relative 'render'

class Dude
  def initialize(params)
    @params = params
    body = Body.new(params[:name])

    @arms = DrawArms.new(@params, body).arms
    arms_draw_params = @arms.map { |arm| arm.draw_data }

    @legs = DrawLegs.new(@params, body).legs
    legs_draw_params = @legs.map { |leg| leg.draw_data }

    @dude_parts = (body.draw_data + arms_draw_params + legs_draw_params).flatten
  end

  def render
    @svg = Render.new(@dude_parts)
  end

  def save(file_name)
    File.open("images/#{file_name}.svg", 'w') { |file| file.write(@svg.contents) }
  end
end
