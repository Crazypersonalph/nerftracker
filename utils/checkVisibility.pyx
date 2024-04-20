cpdef check_visibility(body_landmarker): # Check visibility of specific torso landmarks
  result = []
  shoulder_left = body_landmarker.result.pose_landmarks[0][12]
  hip_right = body_landmarker.result.pose_landmarks[0][23]

  shoulder_right = body_landmarker.result.pose_landmarks[0][11]
  hip_left = body_landmarker.result.pose_landmarks[0][24]

  if 0.85 < shoulder_left.visibility and 0.85 < hip_right.visibility: # Check if first pair is visible
    result.insert(0, True)
  else:
    result.insert(0, False)
          
  if 0.85 < shoulder_right.visibility and 0.85 < hip_left.visibility: # Check if second pair is visible
    result.insert(1, True)
  else:
    result.insert(1, False)

  return result
