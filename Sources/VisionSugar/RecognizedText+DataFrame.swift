import Foundation
import TabularData

public extension Array where Element == RecognizedText {
    var dataFrame: DataFrame {
        let ids = map { $0.id }
        let rectStrings = map { NSCoder.string(for: $0.rect) }
        let strings = map { $0.string }
        
        let dataFrame: DataFrame = [
            "id": ids,
            "rectString": rectStrings,
            "string": strings
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
            
            let string = row["string"] as? String ?? ""
            recognizedTexts.append(RecognizedText(id: uuid, rectString: rectString, string: string))
        }
        return recognizedTexts
    }
}