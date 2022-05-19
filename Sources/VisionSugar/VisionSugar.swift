import UIKit
import Vision
import SwiftUISugar
import TabularData

extension CGRect {
    func rectForSize(_ size: CGSize) -> CGRect {
        var rect = VNImageRectForNormalizedRect(self, Int(size.width), Int(size.height) )
        rect.origin.y = size.height - rect.origin.y - rect.size.height
        return rect
    }
}

public struct VisionSugar {

    public static func boxes(for image: UIImage, inContentSize contentSize: CGSize, completion: @escaping (([RecognizedText]?) -> Void)) {
        recognizeTexts(in: image) { observations in
            guard let observations = observations else {
                completion(nil)
                return
            }
            completion(boxes(of: observations, for: image, inContentSize: contentSize))
        }
    }
    
    public static func boxes(of observations: [VNRecognizedTextObservation], for image: UIImage, inContentSize contentSize: CGSize) -> [RecognizedText] {
        var boxes: [RecognizedText] = []
        for observation in observations {
            let box = VisionSugar.box(of: observation, for: image, inContentSize: contentSize)
            boxes.append(box)
        }
        return boxes
    }
    
    public static func box(of observation: VNRecognizedTextObservation, for image: UIImage, inContentSize contentSize: CGSize) -> RecognizedText {
        let width: CGFloat, height: CGFloat
        if image.size.widthToHeightRatio > contentSize.widthToHeightRatio {
            width = contentSize.width
            height = image.size.height * width / image.size.width
        } else {
            height = contentSize.height
            width = image.size.width * height / image.size.height
        }
        let rect = observation.boundingBox.rectForSize(CGSize(width: width, height: height))

        return RecognizedText(observation: observation, rect: rect)
    }

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
}

public extension Array where Element == RecognizedText {
    
    var dataFrame: DataFrame {
        let ids = map { $0.id }
        let rectStrings = map { NSCoder.string(for: $0.rect) }
        let strings = map { $0.string }
        
        let dataFrame: DataFrame = [
            "id": ids,
            "rectString": rectStrings,
            "string": strings
        ]
        return dataFrame
    }
}
