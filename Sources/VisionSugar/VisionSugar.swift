import UIKit
import Vision
import TabularData

public typealias BarcodesHandler = (([RecognizedBarcode]) -> Void)
public typealias BarcodesHandlerHandler = ((BarcodesHandler) -> Void)
public typealias TextObservationSetHandler = ((RecognizedTextObservationSet?) -> Void)
public typealias TextObservationsHandler = ((RecognizeTextConfiguration, @escaping TextObservationSetHandler) throws -> ())

public typealias TextAndBarcodesHandler = ((RecognizedTextObservationSet?, [RecognizedBarcode]) -> Void)
public typealias TextAndBarcodesHandlerHandler = ((RecognizeTextConfiguration, @escaping TextAndBarcodesHandler) throws -> ())

//TODO: Remove these
//public struct VisionSugar {
//
//    public static func recognizedTexts(
//        for image: UIImage,
//        useLanguageCorrection: Bool = true,
//        recognitionLanguages: [String]? = nil,
//        recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
//        inContentSize contentSize: CGSize,
//        completion: @escaping (([RecognizedText]?) -> Void)
//    ) {
//        recognizeTexts(
//            in: image,
//            useLanguageCorrection: useLanguageCorrection,
//            recognitionLanguages: recognitionLanguages,
//            recognitionLevel: recognitionLevel)
//        { observations in
//            guard let observations = observations else {
//                completion(nil)
//                return
//            }
//            completion(recognizedTexts(of: observations, for: image, inContentSize: contentSize))
//        }
//    }
//
//    public static func recognizedTexts(
//        of observations: [VNRecognizedTextObservation],
//        for image: UIImage,
//        inContentSize contentSize: CGSize
//    ) -> [RecognizedText] {
//        var recognizedTexts: [RecognizedText] = []
//        for observation in observations {
//            let recognizedText = VisionSugar.recognizedText(of: observation, for: image, inContentSize: contentSize)
//            recognizedTexts.append(recognizedText)
//        }
//        return recognizedTexts
//    }
//
//    public static func recognizedText(
//        of observation: VNRecognizedTextObservation,
//        for image: UIImage,
//        inContentSize contentSize: CGSize
//    ) -> RecognizedText {
//        let width: CGFloat, height: CGFloat
//        if image.size.widthToHeightRatio > contentSize.widthToHeightRatio {
//            width = contentSize.width
//            height = image.size.height * width / image.size.width
//        } else {
//            height = contentSize.height
//            width = image.size.width * height / image.size.height
//        }
//        let rect = observation.boundingBox.rectForSize(CGSize(width: width, height: height))
//
//        return RecognizedText(observation: observation, rect: rect, boundingBox: observation.boundingBox)
//    }
//
//    public static func recognizeTexts(
//        in image: UIImage,
//        useLanguageCorrection: Bool = true,
//        recognitionLanguages: [String]? = nil,
//        recognitionLevel: VNRequestTextRecognitionLevel = .accurate,
//        customWords: [String] = [],
//        completion: @escaping (([VNRecognizedTextObservation]?) -> Void))
//    {
//        guard let cgImage = image.fixOrientationIfNeeded().cgImage else {
//            completion(nil)
//            return
//        }
//
//        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
//        let request = VNRecognizeTextRequest { request, error in
//            guard let observations = request.results as? [VNRecognizedTextObservation] else {
//                return
//            }
//            completion(observations)
//        }
//
//        if let recognitionLanguages = recognitionLanguages {
//            request.recognitionLanguages = recognitionLanguages
//        }
//        request.recognitionLevel = recognitionLevel
//        request.usesLanguageCorrection = useLanguageCorrection
//        request.customWords = customWords
//        do {
//            try requestHandler.perform([request])
//        } catch {
//            print("Unable to perform the requests: \(error).")
//        }
//    }
//}
//
