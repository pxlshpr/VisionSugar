import UIKit
import Vision
import SwiftUISugar

extension CMSampleBuffer {
    
    public func recognizedTextSet(for config: RecognizeTextConfiguration) async throws -> RecognizedTextSet {
        try await config.recognizedTextSet(textHandler: recognizeTextObservations)
    }
    public func recognizeTextObservations(
        config: RecognizeTextConfiguration,
        completion: @escaping TextObservationSetHandler
    ) throws {
        let request = config.recognizeTextRequest(completion: completion)
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: self, orientation: .right)
        try requestHandler.perform([request])
    }
}
