import utils.checkVisibility as checkVis

cdef double x1,y1,z1
cdef double x2,y2,z2
cdef double x3,y3,z3
cdef double x4,y4,z4

def calculate(body_landmarker):
  if body_landmarker.result.pose_landmarks: # Check if pose landmarks exist
          shoulder_left = body_landmarker.result.pose_landmarks[0][12]
          hip_right = body_landmarker.result.pose_landmarks[0][23]

          shoulder_right = body_landmarker.result.pose_landmarks[0][11]
          hip_left = body_landmarker.result.pose_landmarks[0][24]


          cv = checkVis.check_visibility(body_landmarker) # Check visibility of shoulder and hip landmarks
          if cv[0] == True and cv[1] == False: # If only shoulder pair 1 is available
            # Get all xyz values from hip and shoulder landmarks
            x1 = shoulder_left.x
            x2 = hip_right.x

            y1 = shoulder_left.y
            y2 = hip_right.y

            z1 = shoulder_left.z
            z2 = hip_right.z

            # Get averaged out values
            xyz = ((x1+x2)/2, (y1+y2)/2, (z1+z2)/2)
            return xyz
          
          if cv[0] == False and cv[1] == True: # If only shoulder pair 2 is available
            # Get all xyz values from hip and shoulder landmarks
            x1 = shoulder_right.x
            x2 = hip_left.x

            y1 = shoulder_right.y
            y2 = hip_left.y

            z1 = shoulder_right.z
            z2 = hip_left.z

            # Get averaged out values
            xyz = ((x1+x2)/2, (y1+y2)/2, (z1+z2)/2)
            return xyz
          
          if cv[0] == True and cv[1] == True: # If all pairs are available (most accurate)
            # Get all xyz values from hip and shoulder landmarks
            x1 = shoulder_left.x
            x2 = hip_right.x
            x3 = shoulder_right.x
            x4 = hip_left.x

            y1 = shoulder_left.y
            y2 = hip_right.y
            y3 = shoulder_right.y
            y4 = hip_left.y

            z1 = shoulder_left.z
            z2 = hip_right.z
            z3 = shoulder_right.z
            z4 = hip_left.z

            # Get averaged out values
            xyz = ((x1+x2+x3+x4)/4, (y1+y2+y3+y4)/4, (z1+z2+z3+z4)/4)
            return xyz
