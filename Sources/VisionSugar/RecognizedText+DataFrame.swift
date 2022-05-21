import Foundation
import TabularData

public extension Array where Element == RecognizedText {
    var dataFrame: DataFrame {
        
        func candidatesAtIndex(_ index: Int) -> [String?] {
            self.map {
                if index < $0.candidates.count {
                    return $0.candidates[index]
                } else {
                    return nil
                }
            }
        }
        
        let ids = map { $0.id }
        let rectStrings = map { NSCoder.string(for: $0.rect) }
//        let strings = map { $0.candidates }
        
        let dataFrame: DataFrame = [
            "id": ids,
            "rectString": rectStrings,
            "candidate1": candidatesAtIndex(0),
            "candidate2": candidatesAtIndex(1),
            "candidate3": candidatesAtIndex(2),
            "candidate4": candidatesAtIndex(3),
            "candidate5": candidatesAtIndex(4)
        ]
        return dataFrame
    }
}

public extension DataFrame {
    static func forRecognizedTexts(_ recognizedTexts: [RecognizedText]) -> DataFrame {
        recognizedTexts.dataFrame
    }
    
    var recognizedTexts: [RecognizedText]? {
        var recognizedTexts: [RecognizedText] = []
        for row in rows {
            guard let id = row["id"] as? String,
                  let uuid = UUID(uuidString: id),
                  let rectString = row["rectString"] as? String else {
                return nil
            }
            
            var candidates: [String] = []
            for index in 1...5 {
                guard let candidate = row["candidate\(index)"] as? String else {
                    break
                }
                candidates.append(candidate)
            }
            
            let recognizedText = RecognizedText(id: uuid, rectString: rectString, candidates: candidates)
            recognizedTexts.append(recognizedText)
        }
        return recognizedTexts
    }
}
