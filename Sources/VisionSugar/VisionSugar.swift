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

    public static func recognizedTexts(for image: UIImage, inContentSize contentSize: CGSize, completion: @escaping (([RecognizedText]?) -> Void)) {
        recognizeTexts(in: image) { observations in
            guard let observations = observations else {
                completion(nil)
                return
            }
            completion(recognizedTexts(of: observations, for: image, inContentSize: contentSize))
        }
    }
    
    public static func recognizedTexts(of observations: [VNRecognizedTextObservation], for image: UIImage, inContentSize contentSize: CGSize) -> [RecognizedText] {
        var recognizedTexts: [RecognizedText] = []
        for observation in observations {
            let recognizedText = VisionSugar.recognizedText(of: observation, for: image, inContentSize: contentSize)
            recognizedTexts.append(recognizedText)
        }
        return recognizedTexts
    }
    
    public static func recognizedText(of observation: VNRecognizedTextObservation, for image: UIImage, inContentSize contentSize: CGSize) -> RecognizedText {
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
        request.recognitionLanguages = ["en_GB", "de_DE", "fr_FR", "it_IT"]
//        request.recognitionLevel = .accurate
//        request.usesLanguageCorrection = false
        do {
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
}

