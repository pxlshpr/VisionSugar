import Vision

public struct Box: Identifiable, Hashable {
    public var id: UUID
    public var observation: VNRecognizedTextObservation
    public var rect: CGRect
    
    public init(observation: VNRecognizedTextObservation, rect: CGRect) {
        self.id = observation.uuid
        self.observation = observation
        self.rect = rect
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public extension Box: CustomStringConvertible {
    var description: String {
        string
    }
}
