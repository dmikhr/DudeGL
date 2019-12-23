require_relative '../config'

# arrange several dudes on canvas
class DudesLocation
  attr_reader :offsets, :canvas_size_x, :canvas_size_y

  def initialize(params_list)
    @dudes_num = params_list.size
    @offsets = []

    compute_dudes_coordiantes
    compute_canvas_size
  end

  private

  # returns array with number of dudes in each row
  # e.g. if we have 12 dudes and only 5 are allowed per row, then the output will be [5, 5, 2])
  def compute_dudes_per_each_row
    remaining_dudes = @dudes_num % Config::DUDES_PER_ROW_MAX
    rows_num = (@dudes_num - remaining_dudes) / Config::DUDES_PER_ROW_MAX
    full_rows = [Config::DUDES_PER_ROW_MAX] * rows_num
    remaining_dudes > 0 ? full_rows + [remaining_dudes]: full_rows
  end

  def compute_dudes_coordiantes
    @dudes_per_each_row = compute_dudes_per_each_row
    offset_y = 0
    @dudes_per_each_row.each_with_index do |dudes_in_row, y_index|
      dudes_in_row.times do |x_index|
        @offsets << { offset_x: x_index * Config::OFFSET_X, offset_y: y_index * Config::OFFSET_Y }
      end
    end
  end

  def compute_canvas_size
    #  max x size of canvas is x offset for the last dude in 1st row - @dudes_per_each_row.first - 1
    # @offsets.last[:offset_y] - last dude has max y offset
    @canvas_size_x = @offsets[@dudes_per_each_row.first - 1][:offset_x] + Config::DUDE_FRAME_SIZE
    @canvas_size_y = @offsets.last[:offset_y] + Config::DUDE_FRAME_SIZE
  end
end
