require 'test/unit'
require 'byebug'
require_relative '../lib/compose/body'


class TestUtils < Test::Unit::TestCase

  def test_circle_rotate
    rotate = Math::PI
    x_rot, y_rot = Body.new('the_dude', { offset_x: 0, offset_y: 0 }).circle_rotate(10, 10, 10, rotate)
    assert_in_delta(0.0, x_rot, 0.1)
    assert_in_delta(10, y_rot, 0.1)
  end

  def test_draw_line
    assert_kind_of(Hash, Body.new('the_dude', { offset_x: 0, offset_y: 0 }).draw_line(10, 10, 20, 20))
  end

  def test_draw_caption
    assert_kind_of(Hash, Body.new('the_dude', { offset_x: 0, offset_y: 0 }).draw_caption('test', 10, 10))
  end
end
