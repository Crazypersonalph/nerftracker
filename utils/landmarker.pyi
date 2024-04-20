import mediapipe as mp



class BodyLandmarkerResults:
    def __init__(self):
        self.BaseOptions = mp.tasks.BaseOptions
        self.PoseLandmarker = mp.tasks.vision.PoseLandmarker
        self.PoseLandmarkerOptions = mp.tasks.vision.PoseLandmarkerOptions
        self.PoseLandmarkerResult = mp.tasks.vision.PoseLandmarkerResult
        self.VisionRunningMode = mp.tasks.vision.RunningMode
        self.result = None
        ...

    def create_landmarker(self):
        def update_result(result: mp.tasks.vision.PoseLandmarkerResult, output_image: mp.Image, timestamp_ms: int):
            self.result = result
            ...
        ...
    def detect(self, frame): ...
    def close(self): ...
