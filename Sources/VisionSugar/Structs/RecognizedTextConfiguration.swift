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
        textHandler: TextObservationsHandler? = nil,
        textAndBarcodesHandler: TextAndBarcodesHandlerHandler? = nil
    ) async throws -> RecognizedTextSet
    {
        var textSet: RecognizedTextSet? = nil
        if let textHandler {
            try textHandler(self) { observationSet in
                guard let observationSet else { return }
                textSet = observationSet.textSet
            }
        } else if let textAndBarcodesHandler {
            try textAndBarcodesHandler(self) { observationSet, barcodes in
                guard let observationSet else { return }
                var newTextSet = observationSet.textSet
                newTextSet.barcodes = barcodes
                textSet = newTextSet
            }
        }
        return textSet ?? RecognizedTextSet(config: self)
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
