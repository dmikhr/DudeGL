module Config
  IMAGE_DIR = 'images'

  METHOD_LENGTH_OK_MAX = 5

  # dude parameters
  BODY_LENGTH = 140
  BODY_CENTER = Math::PI * (3 / 2.0)
  # defines how slim is a body
  SLIM_FACTOR = Math::PI * (2 / 8.0)
  HEAD_RADIUS = 40

  ARM_LENGTH = 40
  ARM_LENGTH_LONG = 70
  ELLIPSE_LENGTH = 10

  FINGER_LENGTH = 10
  FINGER_ANGLE_START = Math::PI * (3 / 4.0)

  LEG_LENGTH = 40
  LEG_LENGTH_LONG = 70

  # size of an square area in pixels where one dude is depicted
  DUDE_FRAME_SIZE = 400

  # for LocateDudes class
  DUDES_PER_ROW_MAX = 2
  DUDES_ROWS_MAX = 3

  # coordinates offset for drawing multiple dudes on a canvas
  OFFSET_X = 0.7 * DUDE_FRAME_SIZE
  OFFSET_Y = 0.8 * DUDE_FRAME_SIZE
end
