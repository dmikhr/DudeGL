require 'byebug'
# require all filder from current dir and subdirectories
Dir[File.dirname(__FILE__) + '/**/*.rb'].each {|file| require_relative file }

class DudeGl
  def initialize(params_list, opts = {})
    @params_list = params_list
    @dudes = []
    opts.key?(:dudes_per_row_max) ? dudes_per_row_max = opts[:dudes_per_row_max] : dudes_per_row_max = nil
    @locations = DudesLocation.new(@params_list, dudes_per_row_max)

    build_dudes
  end

  def render
    @svg = Render.new(@dudes.flatten,
                      width = @locations.canvas_size_x,
                      height = @locations.canvas_size_y)
  end

  def save(file_name)
    File.open("images/#{file_name}.svg", 'w') { |file| file.write(@svg.contents) }
  end

  private

  def build_dudes
    @params_list.each_with_index { |params, index| @dudes << build_dude(params, index) }
  end

  def build_dude(params, index)
    body = Body.new(params[:name], offsets = @locations.offsets[index])

    # draw all methods as arms, keep legs for something else...
    arms = Arms.new(params, body).limbs
    arms_draw_params = arms.map { |arm| arm.draw_data }

    legs_draw_params = []

    (body.draw_data + arms_draw_params + legs_draw_params).flatten
  end
end
