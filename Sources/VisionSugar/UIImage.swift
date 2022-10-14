import UIKit
import Vision
import SwiftUISugar

extension UIImage {

    public func recognizedTextSet(for config: RecognizeTextConfiguration = .accurate, includeBarcodes: Bool = false
    ) async throws -> RecognizedTextSet {
        guard let imageRequestHandler else {
            return RecognizedTextSet(config: config)
        }
        return try await imageRequestHandler.recognizedTextSet(for: config, includeBarcodes: includeBarcodes)
    }
    
    var imageRequestHandler: VNImageRequestHandler? {
        guard let fixedCGImage else {
            return nil
        }
        return VNImageRequestHandler(cgImage: fixedCGImage)
    }
    
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
