require_relative 'config'

class Render
  attr_reader :contents

  HEADER = %Q[<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">]

  def initialize(elements, width = Config::DUDE_FRAME_SIZE, height = Config::DUDE_FRAME_SIZE)
    code = []
    code << HEADER
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
    <<~LINE.gsub(/\s+/, " ").strip
      <line x1="#{params[:x1]}" y1="#{params[:y1]}"
      x2="#{params[:x2]}"
      y2="#{params[:y2]}"
      style="stroke:#{params[:color]}; stroke-width:1"/>
    LINE
  end

  def svg_circle(params)
    <<~CIRCLE.gsub(/\s+/, " ").strip
      <circle cx="#{params[:cx]}"
      cy="#{params[:cy]}"
      r="#{params[:r]}"
      fill="white" style="stroke:#{params[:color].to_s}; stroke-width:1"/>
    CIRCLE
  end

  def svg_ellipse(params)
    <<~ELLIPSE.gsub(/\s+/, " ").strip
      <ellipse cx="#{params[:cx]}"
      cy="#{params[:cy]}"
      rx="#{params[:rx]}"
      ry="#{params[:ry]}"
      style="stroke:#{params[:color].to_s}; stroke-width:1" fill="white"/>
    ELLIPSE
  end

  def svg_text(params)
    <<~TEXT.gsub(/\s+/, " ").strip
      <text x="#{params[:x]}"
      y="#{params[:y]}"
      font-family="arial" font-size="#{params[:font_size]}"
      fill="#{params[:color].to_s}" style="writing-mode:
      #{params[:orientation].to_s}">#{params[:caption]}</text>
    TEXT
  end
end
