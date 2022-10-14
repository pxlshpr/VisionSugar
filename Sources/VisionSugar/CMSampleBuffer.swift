import UIKit
import Vision
import SwiftUISugar

extension CMSampleBuffer {

//    public func recognizeBarcodes(completion: @escaping ((RecognizedTextObservationSet?) -> Void)) throws {
//        let requestHandler = VNImageRequestHandler(cmSampleBuffer: self, orientation: .right)
//
//        let request = VNRecognizeTextRequest { request, error in
//            guard let observations = request.results as? [VNRecognizedTextObservation] else {
//                return
//            }
//
//            completion(RecognizedTextObservationSet(config: config, observations: observations))
//        }
//
//        if let languages = config.languages {
//            request.recognitionLanguages = languages
//        }
//        request.recognitionLevel = config.level
//        request.usesLanguageCorrection = config.languageCorrection
//        request.customWords = config.customWords
//        requests.append(request)
//        }
//
//        try requestHandler.perform(requests)
//    }
//    func something() {
//        let request = VNDetectBarcodesRequest { (request,error) in
//            if let error = error as NSError? {
//                print("Error in detecting - \(error)")
//                return
//            }
//            else {
//                guard let observations = request.results as? [VNBarcodeObservation] else {
//                    return
//                }
//                print("Observations are \(observations)")
//            }
//        }
//    }
}

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
    
//    public func recognizeTextObservationsAndBarcodes(
//        configs: [RecognizeTextConfiguration],
//        completion: @escaping ((RecognizedTextObservationSet?) -> Void)
//    ) throws {
//        let textRequests = recognizeTextRequests(for: configs) { observationSet in
//            <#code#>
//        }
//    }
    
    public func recognizeTextObservations(
        configs: [RecognizeTextConfiguration],
        completion: @escaping ((RecognizedTextObservationSet?) -> Void)
    ) throws {
        let requests = recognizeTextRequests(for: configs, completion: completion)
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: self, orientation: .right)
        try requestHandler.perform(requests)
    }
    
    func recognizeTextRequests(
        for configs: [RecognizeTextConfiguration],
        completion: @escaping ((RecognizedTextObservationSet) -> ())
    ) -> [VNRecognizeTextRequest] {
        var requests: [VNRecognizeTextRequest] = []
        for config in configs {
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    return
                }
                
                let observationSet = RecognizedTextObservationSet(config: config, observations: observations)
                completion(observationSet)
            }
            
            if let languages = config.languages {
                request.recognitionLanguages = languages
            }
            request.recognitionLevel = config.level
            request.usesLanguageCorrection = config.languageCorrection
            request.customWords = config.customWords
            requests.append(request)
        }
        return requests
    }
    
    public func recognizedTexts(from observations: [VNRecognizedTextObservation], inContentSize contentSize: CGSize) -> [RecognizedText] {
        observations.map { observation in
            recognizedText(from: observation, inContentSize: contentSize)
        }
    }
    
    public func recognizedText(from observation: VNRecognizedTextObservation, inContentSize contentSize: CGSize) -> RecognizedText {
        
        return RecognizedText(observation: observation,
                              rect: observation.boundingBox,
                              boundingBox: observation.boundingBox
        )
//        let rect = observation.boundingBox.rectForSize(UIScreen.main.bounds.size)
//        return RecognizedText(observation: observation, rect: rect, boundingBox: observation.boundingBox)
    }
}

