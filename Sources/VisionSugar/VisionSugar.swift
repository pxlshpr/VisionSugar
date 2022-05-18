import UIKit
import Vision
import SwiftUISugar

public struct VisionSugar {

    public func recognizeTexts(in image: UIImage, completion: @escaping (([VNRecognizedTextObservation]?) -> Void)) {
        guard let cgImage = image.fixOrientationIfNeeded().cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            completion(observations)
        }
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    public static func textBoxes(from image: UIImage, in frame: CGRect) -> [Box] {
        var boxes: [Box] = []
        return boxes
//        for observation in observations[index] {
//            guard let box = box(of: observation, for: images[index]) else { continue }
//            boxes.append(box)
//        }
//        return boxes
    }
}
