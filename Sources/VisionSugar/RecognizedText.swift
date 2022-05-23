import Vision

public struct RecognizedText: Identifiable, Hashable {
    public var id: UUID
    public var rect: CGRect
    public var boundingBox: CGRect
    public var candidates: [String]
    
    public init(observation: VNRecognizedTextObservation, rect: CGRect, boundingBox: CGRect) {
        self.id = observation.uuid
        
        /// Save up to the first 5 candidates with a confidence of at least 0.4
        self.candidates = Array(observation.topCandidates(20).filter {
            $0.confidence >= 0.4
        }
        .map { $0.string }
        .prefix(5))
        
        self.rect = rect
        self.boundingBox = boundingBox
    }

    public init(id: UUID, rectString: String, boundingBoxString: String, candidates: [String]) {
        self.id = id
        self.candidates = candidates
        self.rect = NSCoder.cgRect(for: rectString)
        self.boundingBox = NSCoder.cgRect(for: boundingBoxString)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension RecognizedText: CustomStringConvertible {
    public var string: String {
        candidates.first ?? ""
    }
    
    public var description: String {
        candidates.joined(separator: ", ")
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
