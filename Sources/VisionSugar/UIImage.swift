import UIKit
import Vision
import SwiftUISugar

extension UIImage {

    public func recognizedTextSet(
        for config: RecognizeTextConfiguration = .accurate,
        includeBarcodes: Bool = false
    ) async throws -> RecognizedTextSet {
        let handler = includeBarcodes ? recognizeTextAndBarcodeObservations : recognizeTextObservations
        return try await config.recognizedTextSet(recognizeTextObservationsHandler: handler)
    }
    
    //MARK: - Private

    private func recognizeTextAndBarcodeObservations(
        config: RecognizeTextConfiguration,
        completion: @escaping TextObservationSetHandler
    ) throws {
        guard let fixedCGImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: fixedCGImage)
        
        let textRequest = config.recognizeTextRequest(completion: completion)
        let barcodesRequest = VNDetectBarcodesRequest { (request, error) in
            guard let observations = request.results as? [VNBarcodeObservation] else {
                return
            }
            
            var barcodes: [(String, String)] = []
            for observation in observations {
                guard let string = observation.payloadStringValue, !barcodes.contains(where: { $0.0 == string}) else {
                    continue
                }
                barcodes.append((string, observation.symbology.rawValue))
            }
            print("🍄 Barcodes are \(barcodes)")
            print("🍄 OK then")
        }
//        let codeTypes: [AVMetadataObject.ObjectType] = [.upce, .code39, .code39Mod43, .ean13, .ean8, .code93, .code128, .pdf417, .qr, .aztec]

//        barcodesRequest.symbologies = [.upce, .code39, .ean13, .ean8, .code93, .code128, .pdf417, .qr, .aztec]
        barcodesRequest.revision = VNDetectBarcodesRequestRevision1
        try requestHandler.perform([barcodesRequest])
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

