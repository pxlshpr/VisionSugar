import Vision
import SwiftUI

public struct RecognizedTextObservationSet {
    public let config: RecognizeTextConfiguration
    public let observations: [VNRecognizedTextObservation]
}

extension RecognizedTextObservationSet {
    var textSet: RecognizedTextSet {
        let texts = observations.map {
            let rect = $0.boundingBox.rectForSize(UIScreen.main.bounds.size)
            return RecognizedText(observation: $0, rect: rect, boundingBox: $0.boundingBox)
        }
        let textSet = RecognizedTextSet(config: config, texts: texts)
        return textSet
    }
}
