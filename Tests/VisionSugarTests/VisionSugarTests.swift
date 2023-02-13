import XCTest
@testable import VisionSugar

final class VisionSugarTests: XCTestCase {
    func test() async throws {
        guard let path = Bundle.module.path(forResource: "blue-tuna-can", ofType: "jpg"),
              let image = UIImage(contentsOfFile: path)
        else {
            XCTFail("Couldn't get image")
            return
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        let textSet = try await image.recognizedTextSet(includeBarcodes: true)
        
        print("🍄 Took: \(CFAbsoluteTimeGetCurrent()-startTime)s")
        print("🍄 We have: \(textSet.texts.count) texts")
        for text in textSet.texts {
            print("     ⚪️ \(text.string)")
        }
        print("🍄 We have: \(textSet.barcodes.count) barcodes")
    }

}
