import UIKit
import Vision
import SwiftUISugar

extension UIImage {

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
    
    //MARK: - Private

    private func recognizeTextAndBarcodeObservations(
        config: RecognizeTextConfiguration,
        completion: @escaping TextAndBarcodesHandler
    ) throws {
        guard let fixedCGImage else {
            completion(nil, [])
            return
        }
        
        var textObservationSet: RecognizedTextObservationSet? = nil
        var barcodes: [RecognizedBarcode] = []
        
        let requestHandler = VNImageRequestHandler(cgImage: fixedCGImage)
        
        let textRequest = config.recognizeTextRequest { _textObservationSet in
            textObservationSet = _textObservationSet
        }
        let barcodesRequest = VNDetectBarcodesRequest.request { _barcodes in
            barcodes = _barcodes
        }
        
        try requestHandler.perform([textRequest, barcodesRequest])
        
        completion(textObservationSet, barcodes)
    }

    private func recognizeTextObservations(
        config: RecognizeTextConfiguration,
        completion: @escaping TextObservationSetHandler
    ) throws {
        guard let fixedCGImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: fixedCGImage)
        let request = config.recognizeTextRequest(completion: completion)
        try requestHandler.perform([request])
    }
    
    //MARK: Helpers
    
    private var fixedCGImage: CGImage? {
        fixOrientationIfNeeded().cgImage
    }
}


extension VNDetectBarcodesRequest {
    static func request(completion: @escaping BarcodesHandler) -> VNDetectBarcodesRequest {
        let barcodesRequest = VNDetectBarcodesRequest { (request, error) in
            guard let observations = request.results as? [VNBarcodeObservation] else {
                return
            }
            
            var barcodes: [RecognizedBarcode] = []
            for observation in observations {
                guard let string = observation.payloadStringValue,
                      !barcodes.contains(where: { $0.string == string })
                else {
                    continue
                }
                barcodes.append(RecognizedBarcode(observation: observation))
            }
            
            completion(barcodes)
        }
        /// Required because revision 3 (which is the default in iOS 16) isn't working currently. Also, setting this to revision 2 doesn't work in the iOS 16 simulator. See [here](https://stackoverflow.com/a/73770832) for more info.
        barcodesRequest.revision = VNDetectBarcodesRequestRevision1
        return barcodesRequest
    }
}
