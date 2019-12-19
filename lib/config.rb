module Config
  IMAGE_DIR = 'images'

  BODY_LENGTH = 140
  BODY_CENTER = Math::PI * (3 / 2.0)
  # defines how slim is a body
  SLIM_FACTOR = Math::PI * (2 / 8.0)
  HEAD_RADIUS = 40

  METHOD_LENGTH_OK_MAX = 5
  ARM_LENGTH = 40
  ARM_LENGTH_LONG = 70
  ELLIPSE_LENGTH = 10

  FINGER_LENGTH = 10
  FINGER_ANGLE_START = Math::PI * (3 / 4.0)

  LEG_LENGTH = 40
  LEG_LENGTH_LONG = 70

  # size of a square in pixels where dude is depicted
  DUDE_FRAME_SIZE = 400

  DUDES_PER_ROW_MAX = 3
  DUDES_ROWS_MAX = 2
end
