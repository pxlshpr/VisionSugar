import Vision

public struct RecognizeTextConfiguration {
    
    public let level: VNRequestTextRecognitionLevel
    public let languageCorrection: Bool
    public let languages: [String]?
    public let customWords: [String]
    
    public init(
        level: VNRequestTextRecognitionLevel = .accurate,
        languageCorrection: Bool = true,
        languages: [String]? = nil,
        customWords: [String] = []
    ) {
        self.level = level
        self.languageCorrection = languageCorrection
        self.languages = languages
        self.customWords = customWords
    }
    
    public static let accurate = RecognizeTextConfiguration(level: .accurate, languageCorrection: true)
    public static let accurateWithoutLanguageCorrection = RecognizeTextConfiguration(level: .accurate, languageCorrection: false)
    public static let fast = RecognizeTextConfiguration(level: .fast)
}

public struct RecognizedTextSet {
    public let config: RecognizeTextConfiguration
    public let texts: [RecognizedText]
}

public struct RecognizedTextObservationSet {
    public let config: RecognizeTextConfiguration
    public let observations: [VNRecognizedTextObservation]
}
