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
    
    public func recognizedTextSet(for config: RecognizeTextConfiguration) async throws -> RecognizedTextSet {
        try await config.recognizedTextSet(recognizeTextObservationsHandler: recognizeTextObservations)
    }

//    public func recognizedTextSet(for config: RecognizeTextConfiguration) async throws -> RecognizedTextSet {
//        var textSets: [RecognizedTextSet] = []
//        try recognizeTextObservations(config: config) { observationSet in
//            guard let observationSet else { return }
//            textSets.append(observationSet.textSet)
//        }
//        return textSets.first ?? RecognizedTextSet(config: config, texts: [])
//    }
    
//    public func recognizeTextObservationsAndBarcodes(
//        configs: [RecognizeTextConfiguration],
//        completion: @escaping ((RecognizedTextObservationSet?) -> Void)
//    ) throws {
//        let textRequests = recognizeTextRequests(for: configs) { observationSet in
//            <#code#>
//        }
//    }
    
    public func recognizeTextObservations(
        config: RecognizeTextConfiguration,
        completion: @escaping TextObservationSetHandler
    ) throws {
        let request = config.recognizeTextRequest(completion: completion)
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: self, orientation: .right)
        try requestHandler.perform([request])
    }
}

extension RecognizeTextConfiguration {
    
    public func recognizedTextSet(
        recognizeTextObservationsHandler: @escaping TextObservationsHandler
    ) async throws -> RecognizedTextSet {
        var textSets: [RecognizedTextSet] = []
        try recognizeTextObservationsHandler(self) { observationSet in
            guard let observationSet else { return }
            textSets.append(observationSet.textSet)
        }
        return textSets.first ?? RecognizedTextSet(config: self, texts: [])
    }
    
    func recognizeTextRequest(completion: @escaping TextObservationSetHandler) -> VNRecognizeTextRequest
    {
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            let observationSet = RecognizedTextObservationSet(config: self, observations: observations)
            completion(observationSet)
        }
        
        if let languages = self.languages {
            request.recognitionLanguages = languages
        }
        request.recognitionLevel = self.level
        request.usesLanguageCorrection = self.languageCorrection
        request.customWords = self.customWords
        return request
    }
}
