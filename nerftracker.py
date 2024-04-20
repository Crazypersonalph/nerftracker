import utils.landmarker as bl # bl for body landmarker
import utils.mpdrawer as mpb # mpb for mediapipe drawer
import utils.calculate as calc # self explanatory
import cv2

def main():
  vid = cv2.VideoCapture(0)
  body_landmarker = bl.body_landmarker_results()
  while True:
      ret, frame = vid.read() # Start reading frames from camera
      body_landmarker.detect(frame) # Start async detection of all bodies
      if (body_landmarker.result != None):
        frame = mpb.draw_body_landmarks_on_image(frame, body_landmarker.result) # Draw body landmarks onto image
        # Calculate coordinates of centre of torso relative to frame
        xyz = calc.calculate(body_landmarker)
        print(xyz)
        if (xyz != None):
          cv2.circle(frame, (int(xyz[0] * 640), int(xyz[1] * 480)), 20, (0,0,255), -1)
      cv2.imshow('frame', frame) # Show the resulting image

      if cv2.waitKey(1) & 0xFF == ord('q'):
         break
      

  body_landmarker.close()
  vid.release()
  cv2.destroyAllWindows()

if __name__ == "__main__":
   main()