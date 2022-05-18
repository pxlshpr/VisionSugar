import Vision

public struct Box: Identifiable, Hashable {
    public var id = UUID()
    public var observation: VNRecognizedTextObservation
    public var rect: CGRect
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
