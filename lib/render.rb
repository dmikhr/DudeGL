require_relative 'config'

class Render
  attr_reader :contents

  def initialize(elements, width = Config::DUDE_FRAME_SIZE, height = Config::DUDE_FRAME_SIZE)
    code = []
    code << %Q[<svg width="#{width}" height="#{height}" style="background:white" xmlns="http://www.w3.org/2000/svg">]
    elements.each { |element| code << hash_to_svg(element) }
    code << %Q[</svg>]

    @contents = code.join("\n")
  end

  private

  def hash_to_svg(hash)
    operator, params = hash.first
    send("svg_#{operator.to_s}".to_sym, params) if defined? operator
  end

  def svg_line(params)
    %Q[<line x1="#{params[:x1]}" y1="#{params[:y1]}" x2="#{params[:x2]}" y2="#{params[:y2]}" style="stroke:black; stroke-width:1"/>]
  end

  def svg_circle(params)
    %Q[<circle cx="#{params[:cx]}" cy="#{params[:cy]}" r="#{params[:r]}" fill="white" style="stroke:black; stroke-width:1"/>]
  end

  def svg_ellipse(params)
    %Q[<ellipse cx="#{params[:cx]}" cy="#{params[:cy]}" rx="#{params[:rx]}" ry="#{params[:ry]}" style="stroke:black; stroke-width:1" fill="white"/>]
  end

  def svg_text(params)
    %Q[<text x="#{params[:x]}" y="#{params[:y]}" font-family="arial" font-size="#{params[:font_size]}" fill="black" style="writing-mode: #{params[:orientation].to_s}">#{params[:caption]}</text>]
  end
end
