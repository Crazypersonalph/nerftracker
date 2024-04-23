from mediapipe import solutions
from mediapipe.framework.formats import landmark_pb2
import numpy as np
cimport numpy as cnp

cpdef cnp.ndarray[cnp.uint8_t, ndim=3, mode="c"] draw_body_landmarks_on_image(cnp.ndarray[cnp.uint8_t, ndim=3, mode="c"] rgb_image, detection_result):
  cdef int idx
  cdef cnp.ndarray[cnp.uint8_t, ndim=3, mode="c"] annotated_image = np.copy(rgb_image)

  # Loop through the detected poses to visualize.
  for idx in range(len(detection_result.pose_landmarks)):
    pose_landmarks = detection_result.pose_landmarks[idx]

    # Draw the pose landmarks.
    pose_landmarks_proto = landmark_pb2.NormalizedLandmarkList()
    pose_landmarks_proto.landmark.extend([
      landmark_pb2.NormalizedLandmark(x=landmark.x, y=landmark.y, z=landmark.z) for landmark in pose_landmarks
    ])
    # noinspection PyTypeChecker
    solutions.drawing_utils.draw_landmarks(
      annotated_image,
      pose_landmarks_proto,
      solutions.pose.POSE_CONNECTIONS,
      solutions.drawing_styles.get_default_pose_landmarks_style())
  return annotated_image
