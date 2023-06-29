import Foundation

public extension Array where Element == RecognizedText {
    var boundingBox: CGRect {
        map{$0.boundingBox}.union
    }
}
