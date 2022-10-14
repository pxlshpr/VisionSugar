import Foundation

public struct RecognizedTextSet {
    public let config: RecognizeTextConfiguration
    public let texts: [RecognizedText]
    public var barcodes: [RecognizedBarcode]
    
    init(config: RecognizeTextConfiguration, texts: [RecognizedText] = [], barcodes: [RecognizedBarcode] = []) {
        self.config = config
        self.texts = texts
        self.barcodes = barcodes
    }
}
