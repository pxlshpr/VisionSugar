import Foundation

public extension Array where Element == RecognizedText {
    var boundingBox: CGRect {
        map{$0.boundingBox}.union
    }
}

public extension Array where Element == CGRect {
    var union: CGRect {
        guard !isEmpty else { return .zero }
        return reduce(.null) { partialResult, rect in
            partialResult.union(rect)
        }
    }
}
