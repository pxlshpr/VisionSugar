import UIKit
import Vision

extension CMSampleBuffer {
    
    public func rectangleObservations(completion: @escaping ([VNRectangleObservation]) -> ()) throws {
        let request = VNDetectRectanglesRequest { (request, error) in
            guard let observations = request.results as? [VNRectangleObservation] else {
                return
            }
            completion(observations)
        }
        try imageRequestHandler.perform([request])
    }

    public func recognizedTextSet(for config: RecognizeTextConfiguration = .accurate, includeBarcodes: Bool = false
    ) async throws -> RecognizedTextSet {
        try await imageRequestHandler.recognizedTextSet(for: config, includeBarcodes: includeBarcodes)
    }
    
    public func recognizedBarcodes() async throws -> [RecognizedBarcode] {
        try await imageRequestHandler.recognizedBarcodes()
    }
    
    var imageRequestHandler: VNImageRequestHandler {
        VNImageRequestHandler(cmSampleBuffer: self, orientation: .right)
    }
}
