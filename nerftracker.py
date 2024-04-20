import utils.landmarker as bl
import utils.mpdrawer as db
import cv2

def main():
  vid = cv2.VideoCapture(0)
  body_landmarker = bl.body_landmarker_results()
  while True:
      ret, frame = vid.read() # Start reading frames from camera
      body_landmarker.detect(frame) # Start async detection of all bodies
      if (body_landmarker.result != None):
        frame = db.draw_body_landmarks_on_image(frame, body_landmarker.result) # Draw body landmarks onto image
        if (body_landmarker.result.pose_world_landmarks): # Check if pose landmarks exist
          if (0.85 < body_landmarker.result.pose_world_landmarks[0][12].visibility and 0.85 < body_landmarker.result.pose_world_landmarks[0][23].visibility):
            # Get all xyz values from hip and shoulder landmarks
            x1 = body_landmarker.result.pose_world_landmarks[0][12].x
            x2 = body_landmarker.result.pose_world_landmarks[0][23].x

            y1 = body_landmarker.result.pose_world_landmarks[0][12].y
            y2 = body_landmarker.result.pose_world_landmarks[0][23].y

            z1 = body_landmarker.result.pose_world_landmarks[0][12].z
            z2 = body_landmarker.result.pose_world_landmarks[0][23].z

            # Get averaged out values
            xyz = ((x1+x2)/2, (y1+y2)/2, (z1+z2)/2)
            print(xyz)
            
      cv2.imshow('frame', frame) # Show the resulting image


      if cv2.waitKey(1) & 0xFF == ord('q'):
         break
      

  body_landmarker.close()
  vid.release()
  cv2.destroyAllWindows()

if __name__ == "__main__":
   main()