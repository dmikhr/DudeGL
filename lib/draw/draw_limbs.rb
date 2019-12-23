require_relative '../config'

class DrawLimbs
  attr_reader :limbs

  def initialize(params, body)
    @params = params
    @body = body
    @limbs = []

    draw_parameters
    draw if @limbs_num.positive?
  end

  private

  def draw; end

  def draw_parameters
    @params_methods = @params[:methods].select { |param| param[:args].public_send(select_operator, 0) }
    @limbs_num = @params_methods.size
    return true if @limbs_num == 0
  end

  # dynamically select operator depending on a child class name
  def select_operator
    return '>' if self.class.name.downcase.include?('arm')
    return '==' if self.class.name.downcase.include?('leg')
  end
end
