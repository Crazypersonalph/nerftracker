import math

import utils.landmarker as bl # bl for body landmarker
import utils.mpdrawer as mpb # mpb for mediapipe drawer
import utils.calculate as calc # self-explanatory
import cv2

cpdef void main():
  vid = cv2.VideoCapture(0)
  body_landmarker = bl.BodyLandmarkerResults()
  while True:
      ret, frame = vid.read() # Start reading frames from camera
      body_landmarker.detect(frame) # Start async detection of all bodies
      if body_landmarker.result is not None:
        frame = mpb.draw_body_landmarks_on_image(frame, body_landmarker.result) # Draw body landmarks onto image
        # Calculate coordinates of centre of torso relative to frame
        xyz = calc.calculate(body_landmarker)
        if xyz is not None:
            cv2.circle(frame, (int(xyz[0] * 640), int(xyz[1] * 480)), 20, (0,0,255), -1)
            cv2.line(frame, (int(640/2), int(480/2)), (int(xyz[0] * 640), int(xyz[1] * 480)), (0,255,0), 8)
            horiz_mov = (320-int(xyz[0] * 640)) # Set how much we need to move in pixels
            vert_mov = (240-int(xyz[1]*480))
            if abs(horiz_mov) <= 20: # Tell the arduino if it is within the threshold to leave it alone
                horiz_mov=0
            if abs(vert_mov) <= 20:
                vert_mov=0
            xy_mov = (horiz_mov, vert_mov)
            print(xy_mov)
      cv2.imshow('frame', frame) # Show the resulting image

      if cv2.waitKey(1) & 0xFF == ord('q'):
         break
      

  body_landmarker.close()
  vid.release()
  cv2.destroyAllWindows()

if __name__ == "__main__":
   main()
