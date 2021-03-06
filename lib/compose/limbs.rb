require_relative '../config'

class Limbs
  attr_reader :limbs

  def initialize(params, body, opts = {})
    @params = params
    @body = body
    @limbs = []
    opts.key?(:body_color) ? @body_color = opts[:body_color] : @body_color = nil

    draw_parameters
    draw if @limbs_num.positive?
  end

  private

  def draw; end

  def draw_parameters
    @params_methods = @params[:methods]
    @limbs_num = @params_methods.size
    return true if @limbs_num == 0
  end

  # dynamically select operator depending on a child class name
  def select_operator
    return '>' if self.class.name.downcase.include?('arm')
    return '==' if self.class.name.downcase.include?('leg')
  end
end
