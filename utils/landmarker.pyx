import mediapipe as mp
import time

body_model_path = './models/pose_landmarker_full.task'


class BodyLandmarkerResults:
    def __init__(self):
      # Get all variables needed
      self.BaseOptions = mp.tasks.BaseOptions
      self.PoseLandmarker = mp.tasks.vision.PoseLandmarker
      self.PoseLandmarkerOptions = mp.tasks.vision.PoseLandmarkerOptions
      self.PoseLandmarkerResult = mp.tasks.vision.PoseLandmarkerResult   
      self.VisionRunningMode = mp.tasks.vision.RunningMode
      self.result = None
      self.create_landmarker()
    def create_landmarker(self):
        def update_result(result: mp.tasks.vision.PoseLandmarkerResult, output_image: mp.Image, timestamp_ms: int):
            self.result = result # Make result accessible

        options = self.PoseLandmarkerOptions( # Mediapipe options
          base_options=self.BaseOptions(model_asset_path=body_model_path),
          running_mode=self.VisionRunningMode.LIVE_STREAM,
          min_pose_detection_confidence=0.7,
          result_callback=update_result)
        
        self.PoseLandmarker = self.PoseLandmarker.create_from_options(options)
    def detect(self, frame):
        mp_image = mp.Image(image_format=mp.ImageFormat.SRGB, data=frame)
        self.PoseLandmarker.detect_async(mp_image, int(time.time() * 1000))
    def close(self):
        self.PoseLandmarker.close()
