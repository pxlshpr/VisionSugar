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

extension Box: CustomStringConvertible {
    public var description: String {
        string
    }
}

public extension Box {
    func isInSameColumnAs(_ box: Box) -> Bool {
        rect.minX < box.rect.maxX
        && rect.maxX > box.rect.minX
    }
    
    func isInSameRowAs(_ box: Box) -> Bool {
        rect.minY < box.rect.maxY
        && rect.maxY > box.rect.minY
    }
    
    var string: String {
        observation.topCandidates(1).first?.string ?? ""
    }
}
