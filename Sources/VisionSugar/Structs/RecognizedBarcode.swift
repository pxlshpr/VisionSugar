import Vision

public struct RecognizedBarcode: Identifiable, Hashable, Codable {
    public var id: UUID
    public var boundingBox: CGRect
    public var string: String
    public var symbology: VNBarcodeSymbology
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    init(observation: VNBarcodeObservation) {
        self.id = UUID()
        self.boundingBox = observation.boundingBox
        self.string = observation.payloadStringValue ?? ""
        self.symbology = observation.symbology
    }
}

extension VNBarcodeSymbology: Codable {
}
