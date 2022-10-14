import Vision

public struct RecognizedBarcode: Identifiable, Hashable, Codable {
    public var id: UUID
    public var boundingBox: CGRect
    public var string: String
    public var symbology: VNBarcodeSymbology
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension VNBarcodeSymbology: Codable {
}
