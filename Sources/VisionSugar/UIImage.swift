import UIKit
import Vision
import SwiftUISugar

public struct RecognizeTextConfiguration {
    public let level: VNRequestTextRecognitionLevel
    public let languageCorrection: Bool
    public let languages: [String]?
    public let customWords: [String]
    public init(level: VNRequestTextRecognitionLevel = .accurate, languageCorrection: Bool = true, languages: [String]? = nil, customWords: [String] = []) {
        self.level = level
        self.languageCorrection = languageCorrection
        self.languages = languages
        self.customWords = customWords
    }
    
    public static let accurate = RecognizeTextConfiguration(level: .accurate, languageCorrection: true)
    public static let accurateWithoutLanguageCorrection = RecognizeTextConfiguration(level: .accurate, languageCorrection: false)
    public static let fast = RecognizeTextConfiguration(level: .fast)
}

public struct RecognizedTextSet {
    public let config: RecognizeTextConfiguration
    public let texts: [RecognizedText]
}

public struct RecognizedTextObservationSet {
    public let config: RecognizeTextConfiguration
    public let observations: [VNRecognizedTextObservation]
}

extension UIImage {

    public func recognizedTextSet(for config: RecognizeTextConfiguration, inContentSize contentSize: CGSize) async throws -> RecognizedTextSet {
        var textSets: [RecognizedTextSet] = []
        try recognizeTextObservations(configs: [config]) { observationSet in
            guard let observationSet else {
                return
            }
            let textSet = RecognizedTextSet(
                config: observationSet.config,
                texts: self.recognizedTexts(from: observationSet.observations, inContentSize: contentSize)
            )
            textSets.append(textSet)
        }
        return textSets.first ?? RecognizedTextSet(config: config, texts: [])
    }

    public func recognizeTextObservations(configs: [RecognizeTextConfiguration], completion: @escaping ((RecognizedTextObservationSet?) -> Void)) throws {
        guard let cgImage = fixOrientationIfNeeded().cgImage else {
            completion(nil)
            return
        }

        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        var requests: [VNRecognizeTextRequest] = []
        for config in configs {
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                
                completion(RecognizedTextObservationSet(config: config, observations: observations))
            }

            if let languages = config.languages {
                request.recognitionLanguages = languages
            }
            request.recognitionLevel = config.level
            request.usesLanguageCorrection = config.languageCorrection
            request.customWords = config.customWords
            requests.append(request)
        }
        
        try requestHandler.perform(requests)
    }
    
    public func recognizedTexts(from observations: [VNRecognizedTextObservation], inContentSize contentSize: CGSize) -> [RecognizedText] {
        observations.map { observation in
            recognizedText(from: observation, inContentSize: contentSize)
        }
    }

    public func recognizedText(from observation: VNRecognizedTextObservation, inContentSize contentSize: CGSize) -> RecognizedText {
        let width: CGFloat, height: CGFloat
        if size.widthToHeightRatio > contentSize.widthToHeightRatio {
            width = contentSize.width
            height = size.height * width / size.width
        } else {
            height = contentSize.height
            width = size.width * height / size.height
        }
        let rect = observation.boundingBox.rectForSize(CGSize(width: width, height: height))
        return RecognizedText(observation: observation, rect: rect, boundingBox: observation.boundingBox)
    }
}

