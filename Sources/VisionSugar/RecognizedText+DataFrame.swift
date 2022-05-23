import Foundation
import TabularData

public extension Array where Element == RecognizedText {
    var dataFrame: DataFrame {
        
        func candidatesAtIndex(_ index: Int) -> [String?] {
            self.map {
                if index < $0.candidates.count {
                    let string = $0.candidates[index]
                    if string == "nil" {
                        return "\"nil\""
                    } else {
                        return $0.candidates[index]
                    }
                } else {
                    return nil
                }
            }
        }
        
        let ids = map { $0.id }
        let rectStrings = map { NSCoder.string(for: $0.rect) }
        let boundingBoxSrings = map { NSCoder.string(for: $0.boundingBox) }
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
                  let rectString = row["rectString"] as? String
            else {
                return nil
            }
            
            let boundingBoxString = row["boundingBoxString"] as? String
            
            var candidates: [String] = []
            for index in 1...5 {
                guard let string = row["candidate\(index)"] as? String else {
                    break
                }
                if string == "\"nil\"" {
                    candidates.append("nil")
                } else {
                    candidates.append(string)
                }
            }
            
            let recognizedText = RecognizedText(id: uuid, rectString: rectString, boundingBoxString: boundingBoxString, candidates: candidates)
            recognizedTexts.append(recognizedText)
        }
        return recognizedTexts
    }
}
