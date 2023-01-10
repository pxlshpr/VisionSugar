import Foundation
import Vision

public struct RecognizedTextSet: Codable {
    public let config: RecognizeTextConfiguration
    public let texts: [RecognizedText]
    public var barcodes: [RecognizedBarcode]
    public var detectBarcodesRevision: Int
    public var recognizeTextRevision: Int
    
    init(config: RecognizeTextConfiguration, texts: [RecognizedText] = [], barcodes: [RecognizedBarcode] = []) {
        self.config = config
        self.texts = texts
        self.barcodes = barcodes
        
        self.detectBarcodesRevision = VNDetectBarcodesRequest.currentRevision
        self.recognizeTextRevision = VNRecognizeTextRequest.currentRevision
    }
}
