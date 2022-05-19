import Vision

public struct RecognizedText: Identifiable, Hashable {
    public var id: UUID
    public var rect: CGRect
    public var string: String
    
    public init(observation: VNRecognizedTextObservation, rect: CGRect) {
        self.id = observation.uuid
        self.string = observation.topCandidates(1).first?.string ?? ""
        self.rect = rect
    }

    public init(id: UUID, rectString: String, string: String) {
        self.id = id
        self.string = string
        self.rect = NSCoder.cgRect(for: rectString)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension RecognizedText: CustomStringConvertible {
    public var description: String {
        string
    }
}

public extension RecognizedText {
    func isInSameColumnAs(_ box: RecognizedText) -> Bool {
        rect.minX < box.rect.maxX
        && rect.maxX > box.rect.minX
    }
    
    func isInSameRowAs(_ box: RecognizedText) -> Bool {
        rect.minY < box.rect.maxY
        && rect.maxY > box.rect.minY
    }
}
