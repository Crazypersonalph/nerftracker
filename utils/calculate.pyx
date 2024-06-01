import numpy as np
cimport numpy as cnp
import utils.checkVisibility as checkVis
cpdef cnp.ndarray[double, ndim=1] calculate(body_landmarker):
    cdef list cv
    cdef double[:] xyz = np.zeros(3, dtype=np.float64)
    cdef double[:] shoulder_left = np.zeros(3, dtype=np.float64)
    cdef double[:] hip_right = np.zeros(3, dtype=np.float64)
    cdef double[:] shoulder_right = np.zeros(3, dtype=np.float64)
    cdef double[:] hip_left = np.zeros(3, dtype=np.float64)
    cdef int i
    cdef bint cv0, cv1
    cdef bint no_detection = False

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
