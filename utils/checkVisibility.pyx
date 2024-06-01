cpdef list check_visibility(body_landmarker): # Check visibility of specific torso landmarks
  cdef list result = []
  cdef double shoulder_left_visibility = body_landmarker.result.pose_landmarks[0][12].visibility
  cdef double hip_right_visibility = body_landmarker.result.pose_landmarks[0][23].visibility

  cdef double shoulder_right_visibility = body_landmarker.result.pose_landmarks[0][11].visibility
  cdef double hip_left_visibility = body_landmarker.result.pose_landmarks[0][24].visibility

  cdef double nose_visibility = body_landmarker.result.pose_landmarks[0][0].visibility

  if 0.85 < shoulder_left_visibility and 0.85 < hip_right_visibility: # Check if first pair is visible
    result.insert(0, True)
  else:
    result.insert(0, False)

  if 0.85 < shoulder_right_visibility and 0.85 < hip_left_visibility: # Check if second pair is visible
    result.insert(1, True)
  else:
    result.insert(1, False)

  if 0.85 < nose_visibility: # Check if nose is visible
    result.insert(2, True)
  else:
    result.insert(2, False)
  return result
