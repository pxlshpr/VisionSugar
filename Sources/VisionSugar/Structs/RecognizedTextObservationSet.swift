import Vision

public struct RecognizedTextObservationSet {
    public let config: RecognizeTextConfiguration
    public let observations: [VNRecognizedTextObservation]
}

extension RecognizedTextObservationSet {
    var textSet: RecognizedTextSet {
        let texts = observations.map {
            RecognizedText(observation: $0, rect: $0.boundingBox, boundingBox: $0.boundingBox)
        }
        let textSet = RecognizedTextSet(config: config, texts: texts)
        return textSet
    }
}
