import UIKit
import Vision
import SwiftUISugar

extension CMSampleBuffer {

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
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: self)
        
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
//        let width: CGFloat, height: CGFloat
//        if size.widthToHeightRatio > contentSize.widthToHeightRatio {
//            width = contentSize.width
//            height = size.height * width / size.width
//        } else {
//            height = contentSize.height
//            width = size.width * height / size.height
//        }
//        let rect = observation.boundingBox.rectForSize(CGSize(width: width, height: height))
//        return RecognizedText(observation: observation, rect: rect, boundingBox: observation.boundingBox)
        
        let rect = observation.boundingBox.rectForSize(UIScreen.main.bounds.size)
        return RecognizedText(observation: observation, rect: rect, boundingBox: observation.boundingBox)
    }
}

