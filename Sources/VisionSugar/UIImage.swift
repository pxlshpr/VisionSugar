import UIKit
import Vision
import SwiftUISugar

public typealias TextObservationSetHandler = ((RecognizedTextObservationSet?) -> Void)
public typealias TextObservationsHandler = ((RecognizeTextConfiguration, @escaping TextObservationSetHandler) throws -> ())

extension UIImage {

    public func recognizedTextSet(for config: RecognizeTextConfiguration) async throws -> RecognizedTextSet {
        try await config.recognizedTextSet(recognizeTextObservationsHandler: recognizeTextObservations)
    }

    public func recognizeTextObservations(
        config: RecognizeTextConfiguration,
        completion: @escaping TextObservationSetHandler
    ) throws {
        guard let cgImage = fixOrientationIfNeeded().cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = config.recognizeTextRequest(completion: completion)
        try requestHandler.perform([request])
    }
}

extension RecognizedTextObservationSet {
    
    var textSet: RecognizedTextSet {
        let texts = observations.map {
            RecognizedText(observation: $0, rect: $0.boundingBox, boundingBox: $0.boundingBox)
        }
        let textSet = RecognizedTextSet(config: config, texts: texts)
        return textSet
    }
}
