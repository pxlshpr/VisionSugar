import XCTest
@testable import VisionSugar

final class VisionSugarTests: XCTestCase {
    func test() async throws {
        guard let path = Bundle.module.path(forResource: "multiple", ofType: "png"),
              let image = UIImage(contentsOfFile: path)
        else {
            XCTFail("Couldn't get image")
            return
        }
        
        let textSet = try await image.recognizedTextSet(includeBarcodes: true)
        print("🍄 We have: \(textSet.texts.count) texts")
    }

}
