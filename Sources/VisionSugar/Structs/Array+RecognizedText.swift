import Foundation
import SwiftUISugar

public extension Array where Element == RecognizedText {
    var boundingBox: CGRect {
        map{$0.boundingBox}.union
    }
}
