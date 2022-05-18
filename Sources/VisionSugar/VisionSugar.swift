import UIKit
import Vision
import SwiftUISugar

extension CGRect {
    func rectForSize(_ size: CGSize) -> CGRect {
        var rect = VNImageRectForNormalizedRect(self, Int(size.width), Int(size.height) )
        rect.origin.y = size.height - rect.origin.y - rect.size.height
        return rect
    }
}

public struct VisionSugar {

    public static func recognizeTexts(in image: UIImage, completion: @escaping (([VNRecognizedTextObservation]?) -> Void)) {
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
    
    public static func boxes(of observations: [VNRecognizedTextObservation], for image: UIImage, inContentSize contentSize: CGSize) -> [Box] {
        var boxes: [Box] = []
        for observation in observations {
            let box = VisionSugar.box(of: observation, for: image, inContentSize: contentSize)
            boxes.append(box)
        }
        return boxes
    }
    
    public static func box(of observation: VNRecognizedTextObservation, for image: UIImage, inContentSize contentSize: CGSize) -> Box {
        let width: CGFloat, height: CGFloat
        if image.size.widthToHeightRatio > contentSize.widthToHeightRatio {
            width = contentSize.width
            height = image.size.height * width / image.size.width
        } else {
            height = contentSize.height
            width = image.size.width * height / image.size.height
        }
        let rect = observation.boundingBox.rectForSize(CGSize(width: width, height: height))

        return Box(observation: observation, rect: rect)
    }
}
