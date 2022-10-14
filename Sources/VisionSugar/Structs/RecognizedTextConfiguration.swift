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

extension RecognizeTextConfiguration {
    
    public func recognizedTextSet(
        recognizeTextObservationsHandler: @escaping TextObservationsHandler
    ) async throws -> RecognizedTextSet {
        var textSets: [RecognizedTextSet] = []
        try recognizeTextObservationsHandler(self) { observationSet in
            guard let observationSet else { return }
            textSets.append(observationSet.textSet)
        }
        return textSets.first ?? RecognizedTextSet(config: self)
    }
    
    func recognizeTextRequest(completion: @escaping TextObservationSetHandler) -> VNRecognizeTextRequest
    {
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            
            let observationSet = RecognizedTextObservationSet(config: self, observations: observations)
            completion(observationSet)
        }
        
        if let languages = self.languages {
            request.recognitionLanguages = languages
        }
        request.recognitionLevel = self.level
        request.usesLanguageCorrection = self.languageCorrection
        request.customWords = self.customWords
        return request
    }
}
