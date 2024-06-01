import utils.landmarker as bl # bl for body landmarker
import utils.mpdrawer as mpb # mpb for mediapipe drawer
import utils.calculate as calc # self-explanatory
import cv2
import requests
cimport numpy as cnp

cdef float horiz_mov
cdef float vert_mov
cdef int height
cdef int width

cpdef void main():
  cdef cnp.ndarray[cnp.uint8_t, ndim=3, mode="c"] frame
  cdef cnp.ndarray[cnp.float64_t, ndim=1] xyz

  body_landmarker = bl.BodyLandmarkerResults()
  vid = cv2.VideoCapture(0)
  while True:
      ret, frame = vid.read() # Start reading frames from camera
      # noinspection PyUnresolvedReferences
      height = frame.shape[0]
      # noinspection PyUnresolvedReferences
      width = frame.shape[1]
      body_landmarker.detect(frame) # Start async detection of all bodies
      if body_landmarker.result is not None:
        frame = mpb.draw_body_landmarks_on_image(frame, body_landmarker.result) # Draw body landmarks onto image
        # Calculate coordinates of centre of torso relative to frame
        xyz = calc.calculate(body_landmarker)
        if xyz is not None:
            cv2.circle(frame, (int(xyz[0] * width), int(xyz[1] * height)), 20, (0,0,255), -1)
            cv2.line(frame, (int(width/2), int(height/2)), (int(xyz[0] * width), int(xyz[1] * height)), (0,255,0), 8)
            horiz_mov = ((width/2)-int(xyz[0] * width)) # Set how much we need to move in pixels
            vert_mov = ((height/2)-int(xyz[1]*height))

            if abs(horiz_mov) < 20:
              horiz_mov = 90
            elif horiz_mov < 0:
              horiz_mov = 90-(abs(horiz_mov/width)*90)
            elif horiz_mov > 0:
              horiz_mov = 90+(abs(horiz_mov/width)*90)

            if abs(vert_mov) < 20:
              vert_mov = 90
            elif vert_mov < 0:
              vert_mov = 90-(abs(vert_mov/height)*90)
            elif vert_mov > 0:
              vert_mov = 90+(abs(vert_mov/height)*90)

            xy_mov = (horiz_mov, vert_mov)
            requests.get('http://192.168.4.1/', params={'yaw': xy_mov[0], 'pitch': xy_mov[1]})
      cv2.imshow('frame', frame) # Show the resulting image

      if cv2.waitKey(1) & 0xFF == ord('q'):
         break
      

  body_landmarker.close()
  vid.release()
  cv2.destroyAllWindows()

if __name__ == "__main__":
   main()
