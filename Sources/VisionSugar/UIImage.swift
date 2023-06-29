import UIKit
import Vision

extension UIImage {
    
    public func contourObservations(completion: @escaping ([VNContoursObservation]) -> ()) throws {
        guard let imageRequestHandler else { return }
        let request = VNDetectContoursRequest { (request, error) in
            guard let observations = request.results as? [VNContoursObservation] else {
                return
            }
            completion(observations)
        }
        try imageRequestHandler.perform([request])
    }
    
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

#if canImport(UIKit)
import UIKit

public extension UIImage {
    func fixOrientationIfNeeded() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        guard let normalizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
            print("Unable to fix orientation of image")
            return self
        }
        UIGraphicsEndImageContext()

        return normalizedImage
    }
    
    var isLandscape: Bool {
        size.width > size.height
    }
}
#endif


extension VNDetectBarcodesRequest {
    static func request(completion: @escaping BarcodesHandler) -> VNDetectBarcodesRequest {
        let request = VNDetectBarcodesRequest { (request, error) in
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
#if targetEnvironment(simulator) && compiler(>=5.7)
        if #available(iOS 16, *) {
            request.revision = VNDetectBarcodesRequestRevision1
        }
#endif
        return request
    }
}
