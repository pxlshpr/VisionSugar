import UIKit
import Vision

extension VNImageRequestHandler {
    public func recognizedTextSet(
        for config: RecognizeTextConfiguration = .accurate,
        includeBarcodes: Bool = false
    ) async throws -> RecognizedTextSet {
        if includeBarcodes {
            return try await config.recognizedTextSet(textAndBarcodesHandler: recognizeTextAndBarcodeObservations)
        } else {
            return try await config.recognizedTextSet(textHandler: recognizeTextObservations)
        }
    }

    public func recognizedBarcodes() async throws -> [RecognizedBarcode] {
        var barcodes: [RecognizedBarcode] = []
        try recognizeBarcodeObservations {
            barcodes = $0
        }
        return barcodes
    }

    //MARK: - Private

    private func recognizeBarcodeObservations(
        completion: @escaping BarcodesHandler
    ) throws {
        var barcodes: [RecognizedBarcode] = []
        let barcodesRequest = VNDetectBarcodesRequest.request { _barcodes in
            barcodes = _barcodes
        }
        try perform([barcodesRequest])
        completion(barcodes)
    }
    
    private func recognizeTextAndBarcodeObservations(
        config: RecognizeTextConfiguration,
        completion: @escaping TextAndBarcodesHandler
    ) throws {
        var textObservationSet: RecognizedTextObservationSet? = nil
        var barcodes: [RecognizedBarcode] = []
        
        let textRequest = config.recognizeTextRequest { _textObservationSet in
            textObservationSet = _textObservationSet
        }
        
        let barcodesRequest = VNDetectBarcodesRequest.request { _barcodes in
            barcodes = _barcodes
        }
        
        try perform([textRequest, barcodesRequest])
        
        completion(textObservationSet, barcodes)
    }

    private func recognizeTextObservations(
        config: RecognizeTextConfiguration,
        completion: @escaping TextObservationSetHandler
    ) throws {
        let request = config.recognizeTextRequest(completion: completion)
        try self.perform([request])
    }
    
}
