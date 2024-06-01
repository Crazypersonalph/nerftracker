import numpy as np
import utils.checkVisibility as checkVis
def calculate(body_landmarker):
    shoulder_left = [0, 0, 0]
    hip_right = [0, 0, 0]
    shoulder_right = [0, 0, 0]
    hip_left = [0, 0, 0]
    xyz = [0, 0, 0]

    if body_landmarker.result.pose_landmarks:
        shoulder_left[0] = body_landmarker.result.pose_landmarks[0][12].x
        shoulder_left[1] = body_landmarker.result.pose_landmarks[0][12].y
        shoulder_left[2] = body_landmarker.result.pose_landmarks[0][12].z

        hip_right[0] = body_landmarker.result.pose_landmarks[0][23].x
        hip_right[1] = body_landmarker.result.pose_landmarks[0][23].y
        hip_right[2] = body_landmarker.result.pose_landmarks[0][23].z

        shoulder_right[0] = body_landmarker.result.pose_landmarks[0][11].x
        shoulder_right[1] = body_landmarker.result.pose_landmarks[0][11].y
        shoulder_right[2] = body_landmarker.result.pose_landmarks[0][11].z

        hip_left[0] = body_landmarker.result.pose_landmarks[0][24].x
        hip_left[1] = body_landmarker.result.pose_landmarks[0][24].y
        hip_left[2] = body_landmarker.result.pose_landmarks[0][24].z

        cv = checkVis.check_visibility(body_landmarker)
        cv0 = cv[0]
        cv1 = cv[1]
        for i in range(3):
            if cv0 and not cv1:
                xyz[i] = (shoulder_left[i] + hip_right[i]) / 2
            elif not cv0 and cv1:
                xyz[i] = (shoulder_right[i] + hip_left[i]) / 2
            elif cv0 and cv1:
                xyz[i] = (shoulder_left[i] + hip_right[i] + shoulder_right[i] + hip_left[i]) / 4
            elif not cv0 and not cv1:
                no_detection = True
    else:
        return None
    if no_detection:
        return None
    return np.asarray(xyz)
